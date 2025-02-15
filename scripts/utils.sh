#!/usr/bin/env bash
#
# Utility functions for Perplexity CLI

# Check if all required dependencies are installed
check_dependencies() {
    local missing_deps=()
    local required_deps=(
        "jq"
        "curl"
        "pandoc"
        "fzf"
    )
    
    for dep in "${required_deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if ((${#missing_deps[@]} > 0)); then
        print_message "error" "Missing dependencies: ${missing_deps[*]}"
        cat << EOF

Please install the missing dependencies:

Ubuntu/Debian:
    sudo apt install ${missing_deps[*]}

macOS:
    brew install ${missing_deps[*]}

Fedora:
    sudo dnf install ${missing_deps[*]}
EOF
        return 1
    fi
    
    return 0
}

# Generate unique ID
generate_id() {
    echo "$(date +%Y%m%d_%H%M%S)_$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)"
}

# Sanitize string for filename
sanitize_filename() {
    echo "$1" | tr -dc '[:alnum:][:space:]' | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | cut -c1-50
}

# Check if string is valid JSON
is_valid_json() {
    if jq -e . >/dev/null 2>&1 <<<"$1"; then
        return 0
    else
        return 1
    fi
}

# Create temporary file with cleanup
create_temp_file() {
    local temp_file
    temp_file=$(mktemp)
    trap 'rm -f "$temp_file"' EXIT
    echo "$temp_file"
}

# Validate path is within allowed directories
validate_path() {
    local path="$1"
    if [[ "$path" != "$PPLX_DATA_DIR"* ]] && [[ "$path" != "$PPLX_CONFIG_DIR"* ]]; then
        print_message "error" "Invalid path: $path"
        return 1
    fi
    return 0
}

# Check if running in interactive mode
is_interactive() {
    [[ -t 0 ]]
}

# Version comparison
version_compare() {
    local v1="$1"
    local v2="$2"
    
    if [[ "$v1" == "$v2" ]]; then
        return 0
    fi
    
    local IFS=.
    local i ver1=($v1) ver2=($v2)
    
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

