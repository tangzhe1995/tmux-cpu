#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

gram_percentage_format="%3.1fG"

print_gram_percentage() {
  gram_percentage_format=$(get_tmux_option "@gram_percentage_format" "$gram_percentage_format")

  if command_exists "nvidia-smi"; then
    loads=$(nvidia-smi | sed -nr 's/.*\s([0-9]+)MiB\s*\/\s*([0-9]+)MiB.*/\1 \2/p')
  elif command_exists "cuda-smi"; then
    loads=$(cuda-smi | sed -nr 's/.*\s([0-9.]+) of ([0-9.]+) MB.*/\1 \2/p' | awk '{print $2-$1" "$2}')
  else
    echo "No GPU"
    return
  fi
  echo "$loads" | awk -v format_1="$gram_percentage_format " -v format_2="($gram_percentage_format)" '{printf format_1, $1/1024} END {printf format_2, $2/1024}'
}

main() {
  print_gram_percentage
}
main
