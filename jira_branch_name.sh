#!/usr/bin/env bash

#
# Pre-commit hooks

# Check branch name
BRANCH_NAME_LENGTH=`git rev-parse --abbrev-ref HEAD | grep -E '^(master|SRE\-[0-9]+(\-|\_)[a-z0-9._-]+)$' | wc -c`

if [ ${BRANCH_NAME_LENGTH} -eq 0 ] ; then
  echo -e '\E[37;44m'"\033[1mERROR\033[0m in pre-commit hook: vim /export/web/.git/hooks/pre-commit"
  echo "Branch name should be like SRE-42 blabla"
  echo "edit regexp if you think something wrong"
  echo "Skip pre-commit hooks with --no-verify (not recommended)."
  exit 1
fi
