#!/usr/bin/env bash
#
# Image generation functions for Perplexity CLI

# Generate image
generate_image() {
    local prompt="$1"
    local thread_id
    thread_id=$(get_current_thread)
    local image_dir="$PPLX_THREADS_DIR/$thread_id/images"
    mkdir -p "$image_dir"
    
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local image_path="$image_dir/${timestamp}_image.png"
    
    print_message "info" "Generating image from prompt: $prompt"
    
    local image_url
    image_url=$(generate_image_api "$prompt")
    
    if [[ $? -eq 0 && -n "$image_url" ]]; then
        if curl -s "$image_url" -o "$image_path"; then
            print_message "success" "Image generated and saved to: $image_path"
            add_message_to_thread "system" "Generated image: $image_path"
            return 0
        else
            print_message "error" "Failed to download image"
            return 1
        fi
    else
        print_message "error" "Failed to generate image"
        return 1
    fi
}

# List images in current thread
list_images() {
    local thread_id
    thread_id=$(get_current_thread)
    local image_dir="$PPLX_THREADS_DIR/$thread_id/images"
    
    if [[ -d "$image_dir" ]]; then
        print_message "info" "Images in current thread:"
        find "$image_dir" -type f -name "*.png" | while read -r image; do
            echo "- $(basename "$image")"
        done
    else
        print_message "info" "No images found in current thread"
    fi
}

# Handle image commands
handle_image_command() {
    case "$1" in
        "generate")
            shift
            generate_image "$*"
            ;;
        "list")
            list_images
            ;;
        *)
            print_message "error" "Unknown image command: $1"
            show_help
            return 1
            ;;
    esac
}

