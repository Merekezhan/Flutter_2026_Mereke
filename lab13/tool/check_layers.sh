#!/usr/bin/env bash
set -eu
# Only violations are printed; exit 1 when a violation is found.
violations="$(grep -rl 'package:http' lib/ | grep -v -e '^lib/core/api/' -e '_repository.dart$' || true)"
violations2="$(grep -rl 'package:flutter/material' lib/ | grep -e '_model.dart$' -e '_repository.dart$' -e '^lib/core/api/' || true)"
if [ -n "$violations" ] || [ -n "$violations2" ]; then
  [ -z "$violations" ] || printf '%s\n' "$violations"
  [ -z "$violations2" ] || printf '%s\n' "$violations2"
  exit 1
fi
