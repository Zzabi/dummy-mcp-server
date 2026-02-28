# Dummy MCP Server and Installer

> This is a dummy test MCP server intended strictly for experimentation and validation. It is not production software.

This repository provides a reproducible installer for the Dummy MCP Server and automatic configuration of VS Code’s `mcp.json`.

The installer performs the following:

* Verifies required system dependencies
* Clones the repository into `~/.mcp_servers`
* Creates an isolated Python virtual environment
* Installs dependencies from `requirements.txt`
* Safely creates or merges VS Code `mcp.json`
* Registers the MCP server under `my-dummy-server`

---

## System Requirements

The following must be available in your system `PATH`:

* Python 3.8+
* git
* Visual Studio Code CLI (`code`)

Verify manually:

```
python3 --version
git --version
code --version
```

If any of these commands fail, installation will stop.

---

## What the Installer Does

On successful installation:

1. Creates:

   ```
   ~/.mcp_servers/
   ```

2. Clones:

   ```
   https://github.com/Zzabi/dummy-mcp-server.git
   ```

3. Creates a virtual environment (for testing purposes only — for real projects prefer tools like `uv`, `pipx`, etc.):

   ```
   ~/.mcp_servers/dummy-mcp-server/.venv
   ```

4. Installs dependencies from `requirements.txt`

5. Updates VS Code configuration:

   **Linux**

   ```
   ~/.config/Code/User/mcp.json
   ```

   **macOS**

   ```
   ~/Library/Application Support/Code/User/mcp.json
   ```

   **Windows**

   ```
   %APPDATA%\Code\User\mcp.json
   ```

The installer safely merges configuration. Existing MCP servers are preserved.

---

## Installation (macOS / Linux)

### Recommended (Secure Method)

Download and review before executing:

```
curl -fsSL https://raw.githubusercontent.com/<user>/<repo>/main/install_mcp.sh -o install_mcp.sh
chmod +x install_mcp.sh
./install_mcp.sh
```

### One-Line Install (Convenience Method)

```
curl -fsSL https://raw.githubusercontent.com/<user>/<repo>/main/install_mcp.sh | bash
```

---

## Installation (Windows)

Run:

```
install_mcp.bat
```

Ensure `python`, `git`, and `code` are accessible in PATH.

---

## Expected Outcome

After successful installation:

* The MCP server is registered under:

  ```
  my-dummy-server
  ```

* It uses the virtual environment interpreter:

  ```
  ~/.mcp_servers/dummy-mcp-server/.venv/bin/python3
  ```

* It launches:

  ```
  server.py
  ```

Restart VS Code if necessary.

---

## Failure Conditions

Installation will stop if:

* Python is missing
* Git is missing
* VS Code CLI is missing
* `server.py` is not found
* `mcp.json` contains invalid JSON
* Dependency installation fails

All errors are printed with explicit reasons.

---

## Manual Verification

Open:

```
mcp.json
```

You should see an entry similar to:

```
"my-dummy-server": {
  "type": "stdio",
  "command": "<path-to-venv-python>",
  "args": ["<path-to-server.py>"]
}
```

---

## Uninstall

1. Delete:

   ```
   ~/.mcp_servers/dummy-mcp-server
   ```

2. Remove the `my-dummy-server` entry from `mcp.json`

---

## Security Notice

Piping remote scripts directly into `bash` is convenient but not inherently safe. For controlled environments, download and inspect the script before executing.

---

## Architecture Notes

The installer uses:

* Python’s built-in `venv`
* JSON merge logic implemented in Python (no `jq` dependency)
* OS detection for VS Code configuration paths
* Idempotent directory creation
* Fail-fast shell execution (`set -euo pipefail`)

---

## Alternative Installation Strategies

For production-grade environments, consider:

* Publishing as a Python package and installing via `pipx`
* Using versioned GitHub releases instead of `main`
* Providing a cross-platform Python bootstrap installer
* Distributing via Homebrew or Scoop

---

## Support

If installation fails:

1. Verify required tools are available in `PATH`.
2. Confirm Python version ≥ 3.8.
3. Ensure VS Code CLI is installed (`code --install-extension` should work).
4. Re-run the installer with verbose logging if needed.
