#!/bin/bash
# Start Hermes Agent with Pleato config for embedding in Carbon ERP
# Usage: bash pleato-config/start-hermes.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HERMES_DIR="$(dirname "$SCRIPT_DIR")/../../hermes-agent"

if [ ! -d "$HERMES_DIR" ]; then
  echo "Error: hermes-agent directory not found at $HERMES_DIR"
  echo "Please clone: git clone https://github.com/NousResearch/hermes-agent.git"
  exit 1
fi

echo "Starting 小折 (Pleato) AI Assistant..."
echo "  Hermes Agent: $HERMES_DIR"
echo "  Config: $SCRIPT_DIR/cli-config.yaml"
echo "  Dashboard: http://localhost:9119"
echo "  Chat: http://localhost:9119/chat"
echo ""

cd "$HERMES_DIR"
conda run -n pleato python -m hermes_cli.main dashboard \
  --tui \
  --no-open \
  --port 9119
