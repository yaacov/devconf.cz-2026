#!/bin/bash
# Slide 8: Tool Usage — the request, including a list of available tools
DESCRIPTION="Query MTV resources (read-only).

Commands:
  get plan - Get migration plans
  get provider - Get providers
  get mapping - Get mappings
  describe plan - Describe a migration plan
  describe provider - Describe a provider
  health - Check MTV system health

RULE: Always set namespace or all_namespaces flag.
Example: {command: \"get plan\", flags: {all_namespaces: true}}"

curl -s http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "$(cat <<EOF
{
  "messages": [
    {"role": "system", "content": "/no_think"},
    {"role": "user", "content": "Fetch migration plans inside the cluster"}
  ],
  "tools": [{
    "type": "function",
    "function": {
      "name": "mtv_read",
      "description": $(echo "$DESCRIPTION" | jq -Rs .),
      "parameters": {
        "type": "object",
        "properties": {
          "command": {
            "type": "string",
            "description": "Command path (e.g. get plan, describe provider)"
          },
          "flags": {
            "type": "object",
            "description": "Options: name, namespace, output (json|table), all_namespaces (bool)"
          }
        },
        "required": ["command"]
      }
    }
  }],
  "max_tokens": 128,
  "temperature": 0
}
EOF
)" | jq .
