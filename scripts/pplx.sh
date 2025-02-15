#!/usr/bin/env bash
#
# Main Perplexity CLI script
# Version: 1.0.0

# Ensure script is sourced, not executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: This script must be sourced, not executed."
    echo "Usage: source ${BASH_SOURCE[0]}"
    exit 1
fi

# Define base paths
export PPLX_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pplx"
export PPLX_SCRIPTS="$PPLX_ROOT/scripts"

# Source all component scripts
declare -a COMPONENTS=(
    "config.sh"
    "ui.sh"
    "utils.sh"
    "api.sh"
    "thread.sh"
    "image.sh"
    "export.sh"
)

for component in "${COMPONENTS[@]}"; do
    if [[ -f "$PPLX_SCRIPTS/$component" ]]; then
        source "$PPLX_SCRIPTS/$component"
    else
        echo "Error: Required component $component not found in $PPLX_SCRIPTS"
        return 1
    fi
done

# Main function
pplx() {
    check_dependencies || return 1
    init_config || return 1

    case "$1" in
        "init")
            setup_api_key
            ;;
        "thread")
            handle_thread_command "${@:2}"
            ;;
        "image")
            handle_image_command "${@:2}"
            ;;
        "ask")
            handle_ask_command "${@:2}"
            ;;
        "export")
            handle_export_command "${@:2}"
            ;;
        "version")
            echo "pplx version 1.0.0"
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            interactive_mode
            ;;
        *)
            echo "Unknown command: $1"
            show_help
            return 1
            ;;
    esac
}

# Initialize completion
if [[ -f "$PPLX_ROOT/completions/pplx.bash" ]]; then
    source "$PPLX_ROOT/completions/pplx.bash"
fi
#!/usr/bin/env bash
#
# Main Perplexity CLI script
# Version: 1.0.0

# Ensure script is sourced, not executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: This script must be sourced, not executed."
    echo "Usage: source ${BASH_SOURCE[0]}"
    exit 1
fi

# Define base paths
export PPLX_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pplx"
export PPLX_SCRIPTS="$PPLX_ROOT/scripts"

# Source all component scripts
declare -a COMPONENTS=(
    "config.sh"
    "ui.sh"
    "utils.sh"
    "api.sh"
    "thread.sh"
    "image.sh"
    "export.sh"
)

for component in "${COMPONENTS[@]}"; do
    if [[ -f "$PPLX_SCRIPTS/$component" ]]; then
        source "$PPLX_SCRIPTS/$component"
    else
        echo "Error: Required component $component not found in $PPLX_SCRIPTS"
        return 1
    fi
done

# Main function
pplx() {
    check_dependencies || return 1
    init_config || return 1

    case "$1" in
        "init")
            setup_api_key
            ;;
        "thread")
            handle_thread_command "${@:2}"
            ;;
        "image")
            handle_image_command "${@:2}"
            ;;
        "ask")
            handle_ask_command "${@:2}"
            ;;
        "export")
            handle_export_command "${@:2}"
            ;;
        "version")
            echo "pplx version 1.0.0"
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            interactive_mode
            ;;
        *)
            echo "Unknown command: $1"
            show_help
            return 1
            ;;
    esac
}

# Initialize completion
if [[ -f "$PPLX_ROOT/completions/pplx.bash" ]]; then
    source "$PPLX_ROOT/completions/pplx.bash"
fi

