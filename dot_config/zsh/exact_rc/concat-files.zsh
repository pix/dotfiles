#!/usr/bin/env zsh

# doc:function:concat-files:shell:Concatenate all files in the current directory using fd.\n  Uses .dockerignore and .openaiignore to exclude files.
concat-files() {
    local output="${1:-/dev/stdout}"
    local files
    
    if ! command -v fd &>/dev/null; then
        echo "fd is not installed"
        return 1
    fi
    
    files=$(fd --hidden --ignore-file=.dockerignore --ignore-file=.openaiignore --type file)
    
    for file in ${(f)files}; do
        echo "----- FILE: $file -----" >> "$output"
        cat "$file" >> "$output"
        echo "" >> "$output"
    done
}
