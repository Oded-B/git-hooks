#!/usr/bin/env bash


# Uncomment below if you want the commit messages to start [refs: jira-123] or you'll just get [jira-123]
#PREAMBLE="refs: "

SED=sed

# If you're on mac and you don't have gnu sed installed, heaven help you.
if uname | grep "Darwin" 2>&1 > /dev/null; then
  SED=gsed
fi

if ! which $SED | grep sed > /dev/null 2>&1; then
  echo "It looks like you don't have gnu sed and you're on OS/X, install it with"
  echo " brew install gnu-sed "
  echo "For other scripts that use sed, you might want to default to it with"
  echo " ln -s /usr/local/bin/gsed /usr/local/bin/sed"
  echo "after it's installed"
  exit 0
fi

BRANCH=$(git symbolic-ref HEAD)
ORIGCOMMITMSG=$(cat $1)
BRANCH_SANS_HEADS_FEATURES_ETC=$(echo $BRANCH | $SED -e 's/^refs\/heads\/\([a-z]*\/\)\?//gm')
JIRAREF=$(echo $BRANCH_SANS_HEADS_FEATURES_ETC | $SED -r -e 's/^([A-Za-z]+-[0-9]+)?(.*)/\1/gm')

echo -n "Maybe ticket is "
echo $JIRAREF
echo "Orig commit message : ${ORIGCOMMITMSG}"

if echo $ORIGCOMMITMSG | grep '^\[' > /dev/null 2>&1; then
  echo "Commit message already starts with squarebracket, making no changes."
  NEWCOMMITMSG=$ORIGCOMMITMSG
  exit 0
fi

if [ "$JIRAREF" = "" ]; then
  echo "Couldn't work out branch... not messing with commit message"
  NEWCOMMITMSG=$ORIGCOMMITMSG
  exit 0
fi

NEWCOMMITMSG="[${PREAMBLE}${JIRAREF}] $ORIGCOMMITMSG"
echo "New commit message : ${NEWCOMMITMSG}"
echo -n "${NEWCOMMITMSG}" > $1
