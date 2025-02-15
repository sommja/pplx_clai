#!/usr/bin/env bash
#
# Installation script for Perplexity CLI

set -e

# Configuration
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pplx"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pplx"
SCRIPTS_DIR="$INSTALL_DIR/scripts"
COMPLETIONS_DIR="$INSTALL_DIR/completions"
BIN_DIR="$HOME/.local/bin"

# Create directories
mkdir -p "$INSTALL_DIR"/{scripts,completions} "$CONFIG_DIR" "$BIN_DIR"

# Copy files
cp scripts/*.sh "$SCRIPTS_DIR/"
cp completions/pplx.bash "$COMPLETIONS_DIR/"

# Create main executable
cat > "$BIN_DIR/pplx" << 'EOF'
#!/usr/bin/env bash
source "${XDG_DATA_HOME:-$HOME/.local/share}/pplx/scripts/pplx.sh"
pplx "$@"
EOF

chmod +x "$BIN_DIR/pplx"

# Add completion to bashrc if not already present
if ! grep -q "source.*pplx.bash" "$HOME/.bashrc"; then
    echo "source \"$COMPLETIONS_DIR/pplx.bash\"" >> "$HOME/.bashrc"
fi

# Set permissions
chmod -R 755 "$SCRIPTS_DIR"
chmod 644 "$COMPLETIONS_DIR/pplx.bash"

print_message() {
    local green='\033[0;32m'
    local nc='\033[0m'
    echo -e "${green}$1${nc}"
}

print_message "Installation complete!"
print_message "Please run: source ~/.bashrc"
print_message "Then initialize with: pplx init"

