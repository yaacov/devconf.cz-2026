#!/bin/bash
# Call the get_plan tool on the MCP server (streamable-http transport)
MCP="http://localhost:8081/mcp"
ACCEPT="Accept: application/json, text/event-stream"

# Step 1: Initialize and capture session ID
SESSION=$(curl -s -D - -X POST "$MCP" \
  -H "Content-Type: application/json" \
  -H "$ACCEPT" \
  -d '{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2025-03-26",
    "clientInfo": {"name": "curl-demo", "version": "1.0"},
    "capabilities": {}
  }
}' | grep -i "mcp-session-id" | tr -d '\r' | awk '{print $2}')

echo "Session: $SESSION"
echo "---"

# Step 2: Send initialized notification
curl -s -X POST "$MCP" \
  -H "Content-Type: application/json" \
  -H "$ACCEPT" \
  -H "Mcp-Session-Id: $SESSION" \
  -d '{
  "jsonrpc": "2.0",
  "method": "notifications/initialized"
}' > /dev/null

# Step 3: Call get_plan tool
curl -s -X POST "$MCP" \
  -H "Content-Type: application/json" \
  -H "$ACCEPT" \
  -H "Mcp-Session-Id: $SESSION" \
  -d '{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/call",
  "params": {
    "name": "get_plan",
    "arguments": {
      "namespace": "openshift-mtv"
    }
  }
}' | grep "^data:" | sed 's/^data: //' | jq .

# Direct CLI call:
# oc mtv get plans -n openshift-mtv