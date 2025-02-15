#!/usr/bin/env bash
#
# Export functionality for Perplexity CLI

# Export thread to markdown
export_thread_markdown() {
    local thread_id="$1"
    [[ -z "$thread_id" ]] && thread_id=$(get_current_thread)
    
    local thread_file="$PPLX_THREADS_DIR/$thread_id/thread.json"
    local export_file="$PPLX_THREADS_DIR/$thread_id/export.md"
    
    if [[ ! -f "$thread_file" ]]; then
        print_message "error" "Thread file not found"
        return 1
    fi
    
    {
        echo "# $(jq -r '.title' "$thread_file")"
        echo "Created: $(jq -r '.created_at' "$thread_file")"
        echo ""
        
        jq -r '.messages[] | "## " + (.role | ascii_upcase) + "\n" + .content + "\n"' "$thread_file"
        
        # Add images if they exist
        local image_dir="$PPLX_THREADS_DIR/$thread_id/images"
        if [[ -d "$image_dir" ]]; then
            echo "## IMAGES"
            find "$image_dir" -type f -name "*.png" | while read -r image; do
                echo "![$(basename "$image")]($image)"
            done
        fi
    } > "$export_file"
    
    print_message "success" "Thread exported to: $export_file"
    return 0
}

# Export thread to PDF
export_thread_pdf() {
    local thread_id="$1"
    [[ -z "$thread_id" ]] && thread_id=$(get_current_thread)
    
    local md_file="$PPLX_THREADS_DIR/$thread_id/export.md"
    local pdf_file="$PPLX_THREADS_DIR/$thread_id/export.pdf"
    
    export_thread_markdown "$thread_id"
    
    if pandoc -f markdown -t pdf "$md_file" -o "$pdf_file"; then
        print_message "success" "Thread exported to PDF: $pdf_file"
        return 0
    else
        print_message "error" "Failed to export PDF"
        return 1
    fi
}

# Handle export commands
handle_export_command() {
    case "$1" in
        "md"|"markdown")
            export_thread_markdown "$2"
            ;;
        "pdf")
            export_thread_pdf "$2"
            ;;
        *)
            print_message "error" "Unknown export format: $1"
            show_help
            return 1
            ;;
    esac
}

