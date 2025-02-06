#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <grep_string>"
  exit 1
fi

grep_string="$1"

echo -e "\033[33mFetching remote branches...\033[0m"

git fetch

echo -e "\n\033[32mDeleting remote branches...\033[0m"

git branch -r | grep "origin/$grep_string" | sed 's/origin\///' | xargs -I {} git push origin :{}

echo -e "\n Deleted remote branch matches $grep_string ✨"

