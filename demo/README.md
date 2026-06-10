# Demo Scripts

Live demos for the "From CLI to MCP in 20 Minutes" talk.
Files are prefixed `a1-`, `b1-`, `d1-` … matching the presentation sections.

## Setup

```bash
pip install transformers torch accelerate hf_transfer fastmcp cli2mcp
export HF_HUB_ENABLE_HF_TRANSFER=1
```

Start a local inference server (e.g. LM Studio, vLLM, Ollama) with
Qwen 3.6 on port 1234 for the Section B demos.

---

## Section A — Language Models

| File | Description |
|------|-------------|
| `a1-base-model.py` | Load Granite 4.1 8B Base and show raw text completion |
| `a2-instruct-model.py` | Load Granite 4.1 8B Instruct with chat template |

```bash
python a1-base-model.py
python a2-instruct-model.py
```

## Section B — Inference Servers

| File | Description |
|------|-------------|
| `b1-curl-empty-tools.sh` | Chat completion with empty tools array (conversational mode) |
| `b2-curl-with-tools.sh` | Chat completion with an `mtv_read` tool schema |
| `b3-fastmcp-server.py` | Minimal MCP server using FastMCP |
| `b4-mcp-list-tools.sh` | Initialize MCP session and list available tools |
| `b5-mcp-call-tool.sh` | Initialize MCP session and call `get_plan` |

```bash
bash b1-curl-empty-tools.sh
bash b2-curl-with-tools.sh

python b3-fastmcp-server.py        # start server, then in another terminal:
bash b4-mcp-list-tools.sh
bash b5-mcp-call-tool.sh
```

## Section C — Skills or Tools

Conceptual slides — no runnable demos. To view the CLI help live:

```bash
oc mtv help
oc mtv help --machine | jq .            # full command schema as JSON (for MCP servers / automation)
oc mtv help --machine --short | jq .    # condensed schema without descriptions or examples

oc mtv mcp-server --http --host 127.0.0.1 --port 8081
```

## Section D — From CLI to MCP

| File | Description |
|------|-------------|
| `d1-cli2mcp.sh` | Scan `kubectl-mtv` help and serve as MCP server |
| `d2-mcp-flow.sh` | Full MCP protocol flow: init → discover → call → compare with CLI |
| `d3-agent.sh` | Live `mtv-agent` session with debug tracing |

```bash
bash d1-cli2mcp.sh                  # start server, then in another terminal:
bash d2-mcp-flow.sh

bash d3-agent.sh                    # putting it all together, how a complete agent work
```
