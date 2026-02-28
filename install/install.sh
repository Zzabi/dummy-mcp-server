#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/Zzabi/dummy-mcp-server.git"
BASE_DIR="$HOME/.mcp_servers"
REPO_NAME="dummy-mcp-server"
CLONE_DIR="$BASE_DIR/$REPO_NAME"
VENV_DIR="$CLONE_DIR/.venv"
SERVER_KEY="my-dummy-server"

OS="$(uname)"

if [[ "$OS" == "Darwin" ]]; then
    VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
else
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
fi

MCP_CONFIG_FILE="$VSCODE_CONFIG_DIR/mcp.json"

error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

check_command() {
    command -v "$1" >/dev/null 2>&1 || error_exit "'$1' not found."
}

echo "Checking required tools..."
check_command python3
check_command git
check_command code

mkdir -p "$BASE_DIR"

if [ ! -d "$CLONE_DIR" ]; then
    echo "Cloning repository..."
    git clone "$REPO_URL" "$CLONE_DIR"
fi

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"
pip install --upgrade pip >/dev/null 2>&1

if [ -f "$CLONE_DIR/requirements.txt" ]; then
    pip install -r "$CLONE_DIR/requirements.txt"
fi

deactivate

mkdir -p "$VSCODE_CONFIG_DIR"

PYTHON_PATH="$VENV_DIR/bin/python3"
SERVER_PATH="$CLONE_DIR/server.py"

python3 <<EOF
import json
from pathlib import Path

config_path = Path("$MCP_CONFIG_FILE")

server_entry = {
    "type": "stdio",
    "command": "$PYTHON_PATH",
    "args": ["$SERVER_PATH"]
}

if config_path.exists():
    try:
        data = json.loads(config_path.read_text())
    except Exception as e:
        raise SystemExit(f"Invalid existing mcp.json: {e}")
else:
    data = {}

data.setdefault("servers", {})
data.setdefault("inputs", [])
data["servers"]["$SERVER_KEY"] = server_entry

config_path.write_text(json.dumps(data, indent=2))
print("mcp.json updated successfully")
EOF

echo "Setup completed successfully."