#!/bin/bash

echo "🧪 Test MCP Tools w lokalnym setupie"
echo "====================================="
echo ""

BASE_URL="http://localhost:3001"
AUTH_TOKEN="local-mcp-token"

# Kolory
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Database Statistics
echo -e "${BLUE}1. Database Statistics${NC}"
curl -s -X POST "${BASE_URL}/mcp" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "get_database_statistics",
      "arguments": {}
    },
    "id": 1
  }' | jq -r '.result.content[0].text' | head -20
echo ""

# Test 2: Search Templates (Slack)
echo -e "${BLUE}2. Search Templates - Slack Integration${NC}"
curl -s -X POST "${BASE_URL}/mcp" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "search_templates",
      "arguments": {
        "query": "slack notification",
        "limit": 5
      }
    },
    "id": 2
  }' | jq -r '.result.content[0].text' | head -30
echo ""

# Test 3: Top Templates
echo -e "${BLUE}3. List Templates - Most Popular${NC}"
curl -s -X POST "${BASE_URL}/mcp" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "list_templates",
      "arguments": {
        "limit": 5,
        "sortBy": "views"
      }
    },
    "id": 3
  }' | jq -r '.result.content[0].text' | head -35
echo ""

# Test 4: Templates for AI Automation
echo -e "${BLUE}4. Templates for AI Automation Task${NC}"
curl -s -X POST "${BASE_URL}/mcp" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "get_templates_for_task",
      "arguments": {
        "task": "ai_automation",
        "limit": 5
      }
    },
    "id": 4
  }' | jq -r '.result.content[0].text' | head -30
echo ""

# Test 5: Node Search with Examples
echo -e "${BLUE}5. Search Nodes with Template Examples${NC}"
curl -s -X POST "${BASE_URL}/mcp" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "search_nodes",
      "arguments": {
        "query": "slack",
        "includeExamples": true,
        "limit": 1
      }
    },
    "id": 5
  }' | jq -r '.result.content[0].text' | head -50
echo ""

# Test 6: Get Specific Template
echo -e "${BLUE}6. Get Specific Template (Top AI Video Template)${NC}"
curl -s -X POST "${BASE_URL}/mcp" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "get_template",
      "arguments": {
        "templateId": 5338,
        "mode": "nodes_only"
      }
    },
    "id": 6
  }' | jq -r '.result.content[0].text' | head -40
echo ""

# Test 7: Templates by Node Type
echo -e "${BLUE}7. Templates Using HTTP Request Node${NC}"
curl -s -X POST "${BASE_URL}/mcp" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "list_node_templates",
      "arguments": {
        "nodeTypes": ["n8n-nodes-base.httpRequest"],
        "limit": 5
      }
    },
    "id": 7
  }' | jq -r '.result.content[0].text' | head -30
echo ""

# Test 8: Search Templates by Metadata
echo -e "${BLUE}8. Search Templates by Metadata (Simple complexity)${NC}"
curl -s -X POST "${BASE_URL}/mcp" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "search_templates_by_metadata",
      "arguments": {
        "complexity": "simple",
        "maxSetupMinutes": 30,
        "limit": 5
      }
    },
    "id": 8
  }' | jq -r '.result.content[0].text' | head -30
echo ""

echo -e "${GREEN}✅ Testy zakończone!${NC}"
echo ""
echo "📊 Podsumowanie:"
echo "   - Lokalny serwer: $BASE_URL"
echo "   - Baza danych: local-setup/n8n-mcp-data/nodes.db (60MB)"
echo "   - Templates: 2,676"
echo "   - Nodes: 536"

