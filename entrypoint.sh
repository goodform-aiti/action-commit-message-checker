#!/bin/bash

IS_BRANCH_NAME_VALID=$( echo ${BRANCH_NAME} | grep -P "^(bug|feature|hotfix|epic|release|revert)/PZ-\d{4}" | wc -l)
VALID_COMMIT_MESSAGE_PREFIX=$(echo ${BRANCH_NAME} | grep -oP "PZ-\d{4}"):


if [[ $IS_BRANCH_NAME_VALID != "1" ]]
then
  echo "The branch name( $BRANCH_NAME ) is not valid, for more information visit: https://github.com/ateli-development/shipgratis/wiki/Coding-standards"
  echo "Once you changed the Pull-request title, you should create a new commit and push it."
  exit 101
fi




GIT_MESSAGES=$(git log remotes/origin/master.. --no-merges --first-parent --pretty=format:%H%s | grep -oP "^.{40}.{8}")
for message in $GIT_MESSAGES
do
  COMMIT_REVISION_NUMBER=$(echo $message | cut -c 1-40)
  COMMIT_MESSAGE_PREFIX=$(echo $message | cut -c 41-48)


  if [[ $VALID_COMMIT_MESSAGE_PREFIX != $COMMIT_MESSAGE_PREFIX ]]
  then
    printf "commit message with revision $COMMIT_REVISION_NUMBER should be started with: $VALID_COMMIT_MESSAGE_PREFIX , but it is started with $COMMIT_MESSAGE_PREFIX\n"
    printf "How you can edit your commit messages?: https://"
    exit 101
  fi
done
