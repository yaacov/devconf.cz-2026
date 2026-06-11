from fastmcp import FastMCP
import subprocess

mcp = FastMCP("mtv")


@mcp.tool()
def get_plan(namespace: str = "default") -> str:
    """Get migration plans from the cluster"""
    return subprocess.run(
        ["kubectl", "mtv", "get", "plan", "-n", namespace],
        capture_output=True, text=True).stdout


if __name__ == "__main__":
    mcp.run(transport="streamable-http", host="0.0.0.0", port=8081)
