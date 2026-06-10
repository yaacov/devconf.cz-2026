#!/bin/bash
# Slide 7: Conversational mode — empty tools array
curl -s http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
  "messages": [
    {"role": "user", "content": "Fetch migration plans inside the cluster"}
  ],
  "tools": [],
  "max_tokens": 128,
  "temperature": 0
}' | jq .
