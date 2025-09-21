#!/bin/bash

# cipher3.sh - Substitution + Transposition Cipher in Bash
# Author: Javier Fernandez Ramos

# Default values
shift_amount=${2:-3}
key=${3:-"123"}

# Validate key: must be a permutation of 1..n
validate_key() {
    local k="$1"
    local len=${#k}
    local sorted=$(echo "$k" | grep -o . | sort | tr -d '\n')
    local expected=$(seq -s '' 1 $len)
    if [[ "$sorted" != "$expected" ]]; then
        echo "Error: Key must be a permutation of 1..n (e.g., '213', '3214')" >&2
        exit 1
    fi
}

validate_key "$key"

message="$1"
if [[ -z "$message" ]]; then
    echo "Usage: $0 \"message\" [shift] [key]"
    exit 1
fi

echo "Original: $message"

# Step 1: Substitution (Caesar Cipher) — FIXED VERSION
substitute() {
    local msg="$1"
    local shift="$2"
    local result=""
    local char

    for ((i=0; i<${#msg}; i++)); do
        char="${msg:$i:1}"
        case "$char" in
            [A-Z])
                # Convert char to ASCII, shift, wrap, convert back
                ascii=$(printf "%d" "'$char")
                shifted=$(( (ascii - 65 + shift) % 26 + 65 ))
                result+=$(printf "\\$(printf "%03o" $shifted)")
                ;;
            [a-z])
                ascii=$(printf "%d" "'$char")
                shifted=$(( (ascii - 97 + shift) % 26 + 97 ))
                result+=$(printf "\\$(printf "%03o" $shifted)")
                ;;
            *)
                # Keep non-alphabetic characters unchanged
                result+="$char"
                ;;
        esac
    done
    echo "$result"
}

substituted=$(substitute "$message" "$shift_amount")
echo "Substituted: $substituted"

# Step 2: Transposition Cipher (Columnar)
transpose() {
    local text="$1"
    local k="$2"
    local cols=${#k}
    
    # Remove spaces for grid building (but keep original for display)
    text_no_space=$(echo "$text" | tr -d ' ')
    len=${#text_no_space}
    rows=$(( (len + cols - 1) / cols ))

    # Pad with 'X' to fill grid
    while [[ ${#text_no_space} -lt $((rows * cols)) ]]; do
        text_no_space+="X"
    done

    # Build grid as array of rows
    grid=()
    for ((i=0; i<rows; i++)); do
        start=$((i * cols))
        grid+=("${text_no_space:$start:$cols}")
    done

    # Read columns in key order
    result=""
    for ((i=0; i<cols; i++)); do
        col_index=$(( ${k:$i:1} - 1 ))  # Convert '1' to 0, '2' to 1, etc.
        for ((r=0; r<rows; r++)); do
            char="${grid[r]:$col_index:1}"
            result+="$char"
        done
        result+=" "  # Add space between columns for readability
    done

    # Trim trailing space
    echo "$result" | sed 's/ $//'
}

transposed=$(transpose "$substituted" "$key")
echo "Transposed: $transposed"
echo "Final Cipher: $transposed"
