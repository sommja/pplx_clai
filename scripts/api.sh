#!/usr/bin/env bash
#
# API interaction functions for Perplexity CLI

# API endpoints
declare -g API_BASE_URL="https://api.perplexity.ai"
declare -g API_CHAT_ENDPOINT="/chat/completions"
declare -g API_IMAGE_ENDPOINT="/images/generations"

# Get API key from config
get_api_key() {
    local api_key
    api_key=$(get_config "api_key")
    
    if [[ -z "$api_key" || "$api_key" == "null" ]]; then
        setup_api_key
        api_key=$(get_config "api_key")
    fi
    
    echo "$api_key"
}

# Setup API key
setup_api_key() {
    print_message "info" "Perplexity AI API Setup"
    print_message "info" "Please enter your API key (visit https://perplexity.ai/settings to get one):"
    read -r api_key
    
    if [[ -n "$api_key" ]]; then
        set_config "api_key" "$api_key"
        print_message "success" "API key saved successfully!"
    else
        print_message "error" "API key cannot be empty"
        return 1
    fi
}

# Make API request
make_api_request() {
    local endpoint="$1"
    local data="$2"
    local api_key
    api_key=$(get_api_key)
    
    local response
    response=$(curl -s -X POST \
        -H "Authorization: Bearer $api_key" \
        -H "Content-Type: application/json" \
        -d "$data" \
        "${API_BASE_URL}${endpoint}")
    
    if is_valid_json "$response"; then
        echo "$response"
        return 0
    else
        print_message "error" "Invalid API response"
        return 1
    fi
}

# Send chat message
send_chat_message() {
    local prompt="$1"
    local model
    model=$(get_config "default_model")
    
    local data="{
        \"model\": \"$model\",
        \"messages\": [{
            \"role\": \"user\",
            \"content\": \"$prompt\"
        }]
    }"
    
    local response
    response=$(make_api_request "$API_CHAT_ENDPOINT" "$data")
    
    if [[ $? -eq 0 ]]; then
        echo "$response" | jq -r '.choices[0].message.content'
        return 0
    else
        return 1
    fi
}

# Generate image
generate_image_api() {
    local prompt="$1"
    local data="{\"prompt\": \"$prompt\"}"
    
    local response
    response=$(make_api_request "$API_IMAGE_ENDPOINT" "$data")
    
    if [[ $? -eq 0 ]]; then
        echo "$response" | jq -r '.url'
        return 0
    else
        return 1
    fi
}

# Validate API key
validate_api_key() {
    local api_key
    api_key=$(get_api_key)
    
    local test_data="{
        \"model\": \"pplx-7b-online\",
        \"messages\": [{
            \"role\": \"user\",
            \"content\": \"test\"
        }]
    }"
    
    if make_api_request "$API_CHAT_ENDPOINT" "$test_data" &>/dev/null; then
        return 0
    else
        print_message "error" "Invalid API key"
        return 1
    fi
}

