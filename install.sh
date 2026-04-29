# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash
# Simple installation script for Assured Workloads & Audit Manager Gemini CLI Extension

set -e

echo "Installing Assured Workloads & Audit Manager Gemini CLI Extension..."
echo ""

# Check prerequisites
if ! command -v gemini &> /dev/null; then
    echo "❌ Gemini CLI not found. Install it first:"
    echo "   npm install -g @google/gemini-cli"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.11 or higher."
    exit 1
fi

echo "✓ Prerequisites found"

# Create extension directory
EXTENSION_DIR="$HOME/.gemini/extensions/assured-workloads-and-audit-manager"
mkdir -p "$EXTENSION_DIR"

# Create virtual environment (isolates dependencies from system Python)
echo "Creating virtual environment..."
python3 -m venv "$EXTENSION_DIR/.venv"

# Install dependencies using pip
echo "Installing dependencies..."
"$EXTENSION_DIR/.venv/bin/pip" install -q --upgrade pip

# Use requirements.txt if available, otherwise install directly
if [ -f "requirements.txt" ]; then
    "$EXTENSION_DIR/.venv/bin/pip" install -q --index-url https://pypi.org/simple/ -r requirements.txt
else
    "$EXTENSION_DIR/.venv/bin/pip" install -q --index-url https://pypi.org/simple/ \
        httpx>=0.28.1 \
        "mcp[cli]>=1.4.1" \
        python-dotenv>=1.0.0 \
        typing-extensions>=4.8.0 \
        aiohttp>=3.9.0 \
        google-cloud-cloudsecuritycompliance>=0.5.0 \
        google-cloud-auditmanager>=0.1.0
fi

# Copy files
echo "Copying extension files..."
cp assured_workloads_and_audit_manager_mcp.py "$EXTENSION_DIR/"
cp GEMINI.md "$EXTENSION_DIR/"

# Create run script
# MCP requires clean JSON on stdout - all logging goes to stderr and is suppressed
cat > "$EXTENSION_DIR/run_mcp.sh" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"

# Suppress all logging - MCP requires clean JSON on stdout
export GRPC_VERBOSITY=ERROR
export GLOG_minloglevel=3
export PYTHONUNBUFFERED=1

# Run MCP server
# Logging now goes to stderr (configured in assured_workloads_and_audit_manager_mcp.py)
# Redirect stderr to /dev/null to keep output clean for JSON-RPC
exec .venv/bin/python3 -W ignore assured_workloads_and_audit_manager_mcp.py 2> /tmp/mcpComp.log
EOF
chmod +x "$EXTENSION_DIR/run_mcp.sh"

# Create extension config
cat > "$EXTENSION_DIR/gemini-extension.json" << EOF
{
  "name": "assured-workloads-and-audit-manager",
  "version": "1.0.0",
  "description": "Google Cloud Assured Workloads and Audit Manager extension for Gemini CLI",
  "mcpServers": {
    "assured-workloads-and-audit-manager-mcp": {
      "command": "$EXTENSION_DIR/run_mcp.sh",
      "args": [],
      "env": {}
    }
  },
  "contextFileName": "GEMINI.md"
}
EOF

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Authenticate with Google Cloud:"
echo "   gcloud auth application-default login"
echo ""
echo "   refer: https://docs.cloud.google.com/sdk/docs/install-sdk if gcloud is not installed"
echo ""
echo "2. Set Quota Project:"
echo "   gcloud auth application-default set-quota-project PROJECT_ID"
echo ""
echo "3. Start Gemini CLI:"
echo "   gemini"
echo ""
echo "4. Test the extension:"
echo "   List all audit reports in organization YOUR_ORG_ID"
echo ""

