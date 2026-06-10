#!/bin/bash
# Full MCP flow: initialize → discover tools → call tool → compare with CLI

MCP="http://localhost:8081/mcp"
ACCEPT="Accept: application/json, text/event-stream"

# --- Step 1: Initialize and capture session ID ---
echo "=== Step 1: Initialize session ==="
SESSION=$(curl -s -D - -X POST "$MCP" \
  -H "Content-Type: application/json" \
  -H "$ACCEPT" \
  -d '{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2025-03-26",
    "clientInfo": {"name": "demo", "version": "1.0"},
    "capabilities": {}
  }
}' | grep -i "mcp-session-id" | tr -d '\r' | awk '{print $2}')

echo "Session: $SESSION"
echo

# --- Step 2: Send initialized notification ---
curl -s -X POST "$MCP" \
  -H "Content-Type: application/json" \
  -H "$ACCEPT" \
  -H "Mcp-Session-Id: $SESSION" \
  -d '{
  "jsonrpc": "2.0",
  "method": "notifications/initialized"
}' > /dev/null

# --- Step 3: Discover available tools ---
echo "=== Step 2: Discover tools ==="
curl -s -X POST "$MCP" \
  -H "Content-Type: application/json" \
  -H "$ACCEPT" \
  -H "Mcp-Session-Id: $SESSION" \
  -d '{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list",
  "params": {}
}' | grep "^data:" | sed 's/^data: //' | jq .
echo

# --- Step 4: Call a tool ---
echo "=== Step 3: Call tool via MCP ==="
curl -s -X POST "$MCP" \
  -H "Content-Type: application/json" \
  -H "$ACCEPT" \
  -H "Mcp-Session-Id: $SESSION" \
  -d '{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "mtv_read",
    "arguments": {"command": "get plan", "flags": {"all_namespaces": true}}
  }
}' | grep "^data:" | sed 's/^data: //' | jq .
echo

# --- Step 5: Compare with direct CLI ---
echo "=== Step 4: Same thing via CLI ==="
kubectl mtv get plan --all-namespaces
