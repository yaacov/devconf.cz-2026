#!/bin/bash
# Live agent session — traces the full loop:
#   user request → tool schema → LLM inference → tool call → response
# Enables LLM dump to capture HTTP round-trips

DUMP_DIR="./dumps"

# Initialize config if needed
mtv-agent init 2>/dev/null || true

echo "=== Starting mtv-agent (debug mode) ==="
echo "Ask a question like: 'Show me all migration plans'"
echo ""
echo "LLM request/response dumps saved to: $DUMP_DIR"
echo "Watch them live in another terminal:"
echo "  ls $DUMP_DIR"
echo "  cat $DUMP_DIR/<latest>.json | jq ."
echo ""
echo "Press Ctrl+C to stop"
echo

# Run the agent with debug tracing
mtv-agent run --dump-http-dir "$DUMP_DIR"