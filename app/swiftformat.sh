#!/usr/bin/env bash
swiftformat \
  --disable trailingCommas,unusedArguments \
  --wraparguments beforefirst $1
