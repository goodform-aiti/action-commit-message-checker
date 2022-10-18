#!/bin/bash

# BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
PREFIX_REGEX="[a-zA-Z]+-\d+"
VALID_PREFIX=$(echo ${BRANCH_NAME} | grep -oP ${PREFIX_REGEX})

echo "Branch name: ${BRANCH_NAME}"
echo "Valid pull request prefix: ${VALID_PREFIX}"
echo "**********************************************"

# 40 characters - commit hash
GIT_MESSAGES=$(git log remotes/origin/master.. --no-merges --first-parent --pretty=format:"%H~%s")
ERR_COUNT=0

IFS=$'\n'       # make newlines the only separator
for MESSAGE in $GIT_MESSAGES
do
    COMMIT_REVISION_NUMBER=$(echo $MESSAGE | cut -c 1-8)
    COMMIT_MESSAGE=$(echo $MESSAGE | cut -c 42-)
    COMMIT_MESSAGE_PREFIX=$(echo $COMMIT_MESSAGE | grep -oP ${PREFIX_REGEX})

    if [[ $COMMIT_MESSAGE_PREFIX != $VALID_PREFIX ]]
    then
        printf "Commit message of '%s' should be started with: '%s', but it is started with '%s'\n" $COMMIT_REVISION_NUMBER $VALID_PREFIX $COMMIT_MESSAGE

        ERR_COUNT=$ERR_COUNT+1
    fi
done

if [[ $ERR_COUNT != 0 ]]
then
    printf "How you can edit your commit messages? https://github.com/ateli-development/shipgratis/wiki/How-to-Change-a-Git-Commit-Message\n"
fi
