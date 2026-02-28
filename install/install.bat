@echo off
setlocal enabledelayedexpansion

echo Checking required tools...

where python >nul 2>nul || (
    echo ERROR: Python not found in PATH.
    exit /b 1
)

where git >nul 2>nul || (
    echo ERROR: Git not found in PATH.
    exit /b 1
)

where code >nul 2>nul || (
    echo ERROR: VS Code CLI not found in PATH.
    exit /b 1
)

echo All required tools found.

set REPO_URL=https://github.com/Zzabi/dummy-mcp-server.git
set BASE_DIR=%USERPROFILE%\.mcp_servers
set REPO_NAME=dummy-mcp-server
set CLONE_DIR=%BASE_DIR%\%REPO_NAME%
set VENV_DIR=%CLONE_DIR%\.venv
set VSCODE_CONFIG_DIR=%APPDATA%\Code\User
set MCP_CONFIG_FILE=%VSCODE_CONFIG_DIR%\mcp.json
set SERVER_KEY=my-dummy-server

if not exist "%BASE_DIR%" (
    echo Creating %BASE_DIR%
    mkdir "%BASE_DIR%" || exit /b 1
)

if not exist "%CLONE_DIR%" (
    echo Cloning repository...
    git clone %REPO_URL% "%CLONE_DIR%" || exit /b 1
) else (
    echo Repository already exists.
)

if not exist "%VENV_DIR%" (
    echo Creating virtual environment...
    python -m venv "%VENV_DIR%" || exit /b 1
)

call "%VENV_DIR%\Scripts\activate.bat" || exit /b 1

python -m pip install --upgrade pip || exit /b 1

if exist "%CLONE_DIR%\requirements.txt" (
    pip install -r "%CLONE_DIR%\requirements.txt" || exit /b 1
)

call deactivate

if not exist "%VSCODE_CONFIG_DIR%" (
    mkdir "%VSCODE_CONFIG_DIR%" || exit /b 1
)

set PYTHON_PATH=%VENV_DIR%\Scripts\python.exe
set SERVER_PATH=%CLONE_DIR%\server.py

python - <<EOF
import json
from pathlib import Path

config_path = Path(r"%MCP_CONFIG_FILE%")

server_entry = {
    "type": "stdio",
    "command": r"%PYTHON_PATH%",
    "args": [r"%SERVER_PATH%"]
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
data["servers"]["%SERVER_KEY%"] = server_entry

config_path.write_text(json.dumps(data, indent=2))
print("mcp.json updated successfully")
EOF

if errorlevel 1 exit /b 1

echo Setup completed successfully.
endlocal