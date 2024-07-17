#!/bin/bash

get_random_line() {
  local file="$1"
  local line_count=$(wc -l < "$file")
  local random_line_number=$((RANDOM % line_count + 1))
  sed -n "${random_line_number}p" "$file"
}

random_line_a=$(get_random_line "a")
random_line_b=$(get_random_line "b")
random_line_c=$(get_random_line "c")

echo "${random_line_a} ${random_line_b} ${random_line_c}"

