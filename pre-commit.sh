#!/usr/bin/env bash
git diff --staged --name-only | grep -e '\(.*\).swift$' | while read line; do
  swiftformat ${line}
  git add $line
done
