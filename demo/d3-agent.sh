#!/bin/bash
# Live agent session — traces the full loop:
#   user request → tool schema → LLM inference → tool call → response
# Enables LLM dump to capture HTTP round-trips

DUMP_DIR="$HOME/.mtv-agent/dumps"

# Initialize config if needed
mtv-agent init 2>/dev/null || true

# Enable debug dumps in config
#if [ -f "$CONFIG_DIR/config.json" ]; then
#  tmp=$(mktemp)
#  jq '.debug.dumpLlm = true' "$CONFIG_DIR/config.json" > "$tmp" && mv "$tmp" "$CONFIG_DIR/config.json"
#fi

echo "=== Starting mtv-agent (debug mode) ==="
echo "Ask a question like: 'Show me all migration plans'"
echo ""
echo "HTTP/LLM dumps saved to: $DUMP_DIR"
echo "Watch them live in another terminal:"
echo "  ls $DUMP_DIR"
echo "  cat $DUMP_DIR/<latest>.json | jq ."
echo ""
echo "Press Ctrl+C to stop"
echo

mtv-agent run

# cursor ~/.mtv-agent/dumps/