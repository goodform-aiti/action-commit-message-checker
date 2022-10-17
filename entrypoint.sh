#!/bin/bash

echo "Branch name: ${BRANCH_NAME}"
echo "Pull request title: ${PULL_REQUEST_TITLE}"
echo "**********************************************"

JIRA_PREFIX="GF"
VALID_COMMIT_MESSAGE_PREFIX=$(echo ${BRANCH_NAME} | grep -oP "$JIRA_PREFIX-\d+")


GIT_MESSAGES=$(git log remotes/origin/master.. --no-merges --first-parent --pretty=format:%H%s | grep -oP "^.{40}.{8}")
for message in $GIT_MESSAGES
do
  COMMIT_REVISION_NUMBER=$(echo $message | cut -c 1-8)
  COMMIT_MESSAGE_PREFIX=$(echo $message | cut -c 41-47)


  if [[ $VALID_COMMIT_MESSAGE_PREFIX != $COMMIT_MESSAGE_PREFIX ]]
  then
    printf "commit message with revision $COMMIT_REVISION_NUMBER should be started with: $VALID_COMMIT_MESSAGE_PREFIX , but it is started with $COMMIT_MESSAGE_PREFIX\n"
    printf "How you can edit your commit messages?: https://github.com/ateli-development/shipgratis/wiki/How-to-Change-a-Git-Commit-Message"
    exit 101
  fi
done
