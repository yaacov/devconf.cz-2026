#!/bin/bash
# Start the MCP server (streamable-http)
# Option A: Use the embedded Go MCP daemon
# Option B: Scan CLI and serve via cli2mcp

echo "=== Scan kubectl-mtv CLI ==="
cli2mcp scan kubectl-mtv -o mtv.tools.json
echo
echo "Generated mtv.tools.json:"
jq . mtv.tools.json
echo

echo "=== Serve as MCP server (streamable-http, port 8081) ==="
echo "(Press Ctrl+C to stop)"
cli2mcp serve mtv.tools.json -t streamable-http --port 8081
