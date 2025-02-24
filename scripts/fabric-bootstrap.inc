# Loop through all files in the ~/.config/fabric/patterns directory
for pattern_file in $HOME/.config/fabric/patterns/*; do
    # Get the base name of the file (i.e., remove the directory path)
    pattern_name=$(basename "$pattern_file")

    # Create an alias in the form: alias pattern_name="fabric --pattern pattern_name"
    alias_command="alias $pattern_name='fabric --pattern $pattern_name'"

    # Evaluate the alias command to add it to the current shell
    eval "$alias_command"
done

yt() {
    local video_link="$1"
    fabric -y "$video_link" --transcript
}
