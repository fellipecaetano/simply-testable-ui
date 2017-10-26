#!/usr/bin/env bash
git diff --staged --name-only | grep -e '\(.*\).swift$' | while read line; do
  swiftformat --disable hoistPatternLet,trailingCommas \
    --wraparguments beforefirst ${line}
  git add $line
done
