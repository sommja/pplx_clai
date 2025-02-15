#!/usr/bin/env bash
#
# Thread management functions for Perplexity CLI

# Create new thread
create_thread() {
    local first_message="$1"
    local thread_title
    thread_title=$(sanitize_filename "$first_message")
    local thread_id
    thread_id=$(generate_id)
    local thread_dir="$PPLX_THREADS_DIR/$thread_id"
    
    mkdir -p "$thread_dir"
    
    echo "{
        \"id\": \"$thread_id\",
        \"title\": \"$first_message\",
        \"created_at\": \"$(date -Iseconds)\",
        \"messages\": []
    }" | jq '.' > "$thread_dir/thread.json"
    
    echo "$thread_id" > "$PPLX_CURRENT_THREAD_FILE"
    print_message "success" "Created new thread: $thread_id"
    return 0
}

# List all threads
list_threads() {
    print_message "info" "Available Threads:"
    
    find "$PPLX_THREADS_DIR" -type f -name "thread.json" | while read -r thread_file; do
        local id
        local title
        local created
        
        id=$(jq -r '.id' "$thread_file")
        title=$(jq -r '.title' "$thread_file")
        created=$(jq -r '.created_at' "$thread_file")
        
        echo -e "${BOLD}ID:${NC} $id"
        echo -e "${BOLD}Title:${NC} $title"
        echo -e "${BOLD}Created:${NC} $created\n"
    done
}

# Switch to thread
switch_thread() {
    local target="$1"
    
    if [[ -z "$target" ]]; then
        target=$(find "$PPLX_THREADS_DIR" -type d -mindepth 1 -maxdepth 1 | \
            xargs -I {} basename {} | \
            fzf --preview "jq -r '.title' \"$PPLX_THREADS_DIR/{}/thread.json\"")
    fi
    
    if [[ -d "$PPLX_THREADS_DIR/$target" ]]; then
        echo "$target" > "$PPLX_CURRENT_THREAD_FILE"
        print_message "success" "Switched to thread: $target"
        return 0
    else
        print_message "error" "Thread not found: $target"
        return 1
    fi
}

# Get current thread
get_current_thread() {
    cat "$PPLX_CURRENT_THREAD_FILE"
}

# Add message to thread
add_message_to_thread() {
    local thread_id
    thread_id=$(get_current_thread)
    local role="$1"
    local content="$2"
    local thread_file="$PPLX_THREADS_DIR/$thread_id/thread.json"
    
    local temp_file
    temp_file=$(create_temp_file)
    
    jq --arg role "$role" \
       --arg content "$content" \
       --arg timestamp "$(date -Iseconds)" \
       '.messages += [{
           "role": $role,
           "content": $content,
           "timestamp": $timestamp
       }]' "$thread_file" > "$temp_file" && mv "$temp_file" "$thread_file"
}

# Handle thread commands
handle_thread_command() {
    case "$1" in
        "list")
            list_threads
            ;;
        "switch")
            switch_thread "$2"
            ;;
        "new")
            shift
            create_thread "$*"
            ;;
        *)
            print_message "error" "Unknown thread command: $1"
            show_help
            return 1
            ;;
    esac
}

