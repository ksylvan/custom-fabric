#!/bin/bash

# See if we have a CUSTOM_PATTERNS_DIRECTORY in the .env file
_custom_patterns_dir=$(grep -E '^CUSTOM_PATTERNS_DIRECTORY=' "$HOME/.config/fabric/.env" | cut -d '=' -f 2-)

# Loop through all files in the ~/.config/fabric/patterns directory
_dirs=("$HOME/.config/fabric/patterns"/*)
if [ -n "$_custom_patterns_dir" ] && [ -d "$_custom_patterns_dir" ]; then
    # If CUSTOM_PATTERNS_DIRECTORY is set and is a directory, add its contents to the array
    _dirs+=("$_custom_patterns_dir"/*)
fi

for pattern_file in "${_dirs[@]}"; do
    # skip anything that is not a directory
    if [ ! -d "$pattern_file" ]; then
        continue
    fi

    # Get the base name of the file (i.e., remove the directory path)
    pattern_name="$(basename "$pattern_file")"
    alias_name="${FABRIC_ALIAS_PREFIX:-}${pattern_name}"

    # Create an alias in the form: alias pattern_name="fabric --pattern pattern_name"
    alias_command="alias $alias_name='fabric --pattern $pattern_name'"

    # Evaluate the alias command to add it to the current shell
    eval "$alias_command"
done

yt() {
    if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
        echo "Usage: yt [-t | --timestamps] youtube-link"
        echo "Use the '-t' flag to get the transcript with timestamps."
        return 1
    fi

    transcript_flag="--transcript"
    if [ "$1" = "-t" ] || [ "$1" = "--timestamps" ]; then
        transcript_flag="--transcript-with-timestamps"
        shift
    fi
    local video_link="$1"
    fabric -y "$video_link" $transcript_flag
}

# Use fuzzy finder to search for patterns
if command -v fzf &>/dev/null; then
    alias fuzzy_fabric='fabric -p $(basename $(dirname $(fzf --walker-root="$HOME/.config/fabric/patterns" --preview "cat {}" --preview-window=up:50%:wrap)))'
fi

# fabric_pattern_summary function
fabric_pattern_summary() {
    args=("$@")
    instructions="
This is the directory structure of all the Fabric Patterns
I want you to examine all the system.md files and create an alphabetized list
that shows simply:

pattern_name - short and concise summary of its function

So the list might look something like this:

extract_wisdom -- Gets the most important points, quotes, etc. from a piece of text
improve_writing -- Fixes grammar and clarity issues
write_essay -- Converts writing to a simple, direct style (i.e. Paul Graham's style)"
    code_helper -ignore user.md "$HOME/.config/fabric/patterns" 'Generate a summary of the fabric patterns' |
        fabric "${args[@]}" "$instructions"
}

# Check if the model-defs.inc file exists in the ~/.config/fabric directory
model_defs_file="$HOME/.config/fabric/model-defs.inc"
if [ -f "$model_defs_file" ]; then
    # shellcheck source=/dev/null
    . "$model_defs_file"
fi
