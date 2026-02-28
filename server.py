from fastmcp import FastMCP
import subprocess
from franchise import franchises


mcp = FastMCP(name="MyServer")

# to test normal tool
@mcp.tool
def get_user_data(name: str) -> dict:
    """Get data about user"""
    data = {
        "Thor":{
            "name": "Thor",
            "age": 1234,
            "race": "Asgardian",
            "fanchise": "Marvel"
        },
        "Golum":{
            "name": "Golum",
            "age": 233,
            "race": "Dwarf",
            "franchise": "LOTR"
        }
    }
    return data.get(name)

# to test subprocess calls to later check with java, node gcc etc
@mcp.tool
def get_number_of_characters(filename: str) -> str:
    """Get data about user"""
    process = subprocess.run(["python3","$HOME/Documents/LEARNING/dummy-mcp-server/any_python_file.py",filename], capture_output=True)
    count = process.stdout.decode("utf-8")
    return count

# to check imported data (should check with @mcp.resource)
@mcp.tool
def get_characters(franchise: str) -> list:
    """Returns a list of characters in a given franchise"""
    characters = franchises.get(franchise)
    return characters

# pending
# @mcp.prompt
# context - from fastmcp import FastMCP, Context
    # from fastmcp.dependencies import CurrentContext
    # from fastmcp.server.context import Context

if __name__ == "__main__":
    # Defaults to STDIO transport
    mcp.run()

    # Or use HTTP transport
    # mcp.run(transport="http", host="127.0.0.1", port=9000)
