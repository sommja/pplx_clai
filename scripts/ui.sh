#!/usr/bin/env bash
#
# UI elements and formatting for Perplexity CLI

# Color definitions
declare -g RED='\033[0;31m'
declare -g GREEN='\033[0;32m'
declare -g BLUE='\033[0;34m'
declare -g YELLOW='\033[1;33m'
declare -g NC='\033[0m' # No Color
declare -g BOLD='\033[1m'

# Print formatted message
print_message() {
    local type="$1"
    local message="$2"
    
    case "$type" in
        "error")
            echo -e "${RED}Error: ${message}${NC}" >&2
            ;;
        "success")
            echo -e "${GREEN}${message}${NC}"
            ;;
        "info")
            echo -e "${BLUE}${message}${NC}"
            ;;
        "warning")
            echo -e "${YELLOW}${message}${NC}"
            ;;
        *)
            echo "$message"
            ;;
    esac
}

# Show spinner while running command
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while ps -p $pid > /dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Progress bar
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    
    printf "\r["
    printf "%${completed}s" | tr ' ' '='
    printf "%${remaining}s" | tr ' ' ' '
    printf "] %d%%" $percentage
}

# Show help message
show_help() {
    cat << EOF
Perplexity CLI Client

Usage: pplx [command] [options]

Commands:
    init        Initialize or update configuration
    thread      Thread management commands
    image       Generate images
    ask         Ask a single question
    export      Export thread content
    help        Show this help message
    version     Show version information

Thread Commands:
    thread list             List all threads
    thread switch <id>      Switch to specified thread
    thread export <id>      Export thread content

Image Commands:
    image generate <prompt> Generate image from prompt
    
Export Commands:
    export md              Export current thread to markdown
    export pdf             Export current thread to PDF

Options:
    -h, --help     Show this help message
    -v, --version  Show version information

For more information, see the man page: man pplx
EOF
}

# Interactive mode prompt
show_prompt() {
    local current_thread=$(get_current_thread)
    echo -e "${YELLOW}pplx ${BLUE}[${current_thread}]${YELLOW}>${NC} "
}

# Format markdown for terminal output
format_markdown() {
    local input="$1"
    echo "$input" | pandoc -f markdown -t terminal
}

