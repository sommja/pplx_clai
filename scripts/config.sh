#!/usr/bin/env bash
#
# Configuration management for Perplexity CLI

# Configuration paths
export PPLX_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pplx"
export PPLX_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pplx"
export PPLX_CONFIG_FILE="$PPLX_CONFIG_DIR/config.json"
export PPLX_THREADS_DIR="$PPLX_DATA_DIR/threads"
export PPLX_CURRENT_THREAD_FILE="$PPLX_CONFIG_DIR/current_thread"

# Initialize configuration
init_config() {
    mkdir -p "$PPLX_CONFIG_DIR" "$PPLX_DATA_DIR" "$PPLX_THREADS_DIR"
    
    if [[ ! -f "$PPLX_CONFIG_FILE" ]]; then
        echo '{
            "version": "1.0.0",
            "api_key": null,
            "default_model": "pplx-7b-online",
            "image_defaults": {
                "size": "1024x1024",
                "format": "png"
            }
        }' | jq '.' > "$PPLX_CONFIG_FILE"
    fi
    
    if [[ ! -f "$PPLX_CURRENT_THREAD_FILE" ]]; then
        echo "default" > "$PPLX_CURRENT_THREAD_FILE"
    fi
}

# Get configuration value
get_config() {
    local key="$1"
    jq -r ".$key" "$PPLX_CONFIG_FILE"
}

# Set configuration value
set_config() {
    local key="$1"
    local value="$2"
    local temp_file=$(mktemp)
    jq --arg key "$key" --arg value "$value" \
        '. + {($key): $value}' "$PPLX_CONFIG_FILE" > "$temp_file" && \
        mv "$temp_file" "$PPLX_CONFIG_FILE"
}

# Validate configuration
validate_config() {
    if [[ ! -f "$PPLX_CONFIG_FILE" ]]; then
        echo "Error: Configuration file not found"
        return 1
    fi
    
    if ! jq empty "$PPLX_CONFIG_FILE" 2>/dev/null; then
        echo "Error: Invalid configuration file format"
        return 1
    fi
    
    return 0
}

