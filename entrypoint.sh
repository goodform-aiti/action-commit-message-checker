#!/bin/bash

IS_RELEASE_BRANCH==$( echo ${BRANCH_NAME} | grep -P "^(release|revert)/" | wc -l)

if [[ $IS_RELEASE_BRANCH == "1" ]]
then
  IS_BRANCH_NAME_VALID=$( echo ${BRANCH_NAME} | grep -P "^(bug|feature|hotfix|epic)/PZ-\d{4}" | wc -l)
else
  IS_BRANCH_NAME_VALID=$( echo ${BRANCH_NAME} | grep -P "^(release|revert)/\d+" | wc -l)
fi




VALID_COMMIT_MESSAGE_PREFIX=$(echo ${BRANCH_NAME} | grep -oP "PZ-\d{4}")


if [[ $IS_BRANCH_NAME_VALID != "1" ]]
then
  echo "The branch name( $BRANCH_NAME ) is not valid, for more information visit: https://github.com/ateli-development/shipgratis/wiki/Coding-standards"
  echo "Once you changed the Pull-request title, you should create a new commit and push it."
  exit 101
fi




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
