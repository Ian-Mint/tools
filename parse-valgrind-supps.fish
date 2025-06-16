#!/usr/bin/fish

# A simple script to clean up Valgrind's generated suppression files.
# This is most useful for logs created with `--gen-suppressions=all`.
#
# It performs two main actions:
# 1. Removes all Valgrind log prefixes (lines starting with "==").
# 2. Replaces the placeholder suppression name with a unique, generated name.
#
# Usage:
#   ./cleanup_supps.fish <input_valgrind_log> > my_app.supp

# --- Script Start ---

# Check if an input file was provided. In fish, command-line arguments
# are in the $argv list. We check if the first argument exists.
if not test -n "$argv[1]"
    echo "Error: No input file specified." >&2
    echo "Usage: $0 <input_valgrind_log>" >&2
    exit 1
end

# Check if the input file exists.
if not test -f "$argv[1]"
    echo "Error: File not found: '$argv[1]'" >&2
    exit 1
end

# In fish, variables are set with the `set` command.
set INPUT_FILE $argv[1]

# The core logic is a pipeline of two commands: 'grep' and 'awk'.
# This part is identical to the bash version as these are standard
# command-line tools that work across different shells.
#
# 1. `grep -v '^==' "$INPUT_FILE"`
#    - Reads the input file and filters out lines starting with '=='.
#
# 2. `awk '...'`
#    - Processes the output from `grep`, finds the placeholder suppression
#      name, and replaces it with a unique, auto-incrementing name.

grep -v '^==' "$INPUT_FILE" | awk '
/<\insert_a_suppression_name_here>/ {
    supp_count++;
    sub(/<insert_a_suppression_name_here>/, "auto_supp_" supp_count);
}
{ print }
'
