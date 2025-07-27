#!/bin/bash

# Test script for OpenAI Integration Service
# Make sure the service is running on localhost:8080

echo "🧪 Testing OpenAI Integration Service"
echo "====================================="

# Check if service is running
echo ""
echo "🔍 Checking if service is running..."
if curl -s http://localhost:8080/health > /dev/null 2>&1; then
    echo "✅ Service is running on localhost:8080"
else
    echo "❌ Service is not running on localhost:8080"
    echo "Please start the service with: go run main.go"
    exit 1
fi

# Check if OpenAI API key is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "⚠️  OPENAI_API_KEY environment variable is not set"
    echo "Please set it with: export OPENAI_API_KEY='your-api-key'"
    echo "Continuing with tests, but they may fail..."
else
    echo "✅ OPENAI_API_KEY is set"
fi

echo ""


# Test /chat endpoint
echo ""
echo "2. Testing /chat endpoint..."
response=$(curl -s -X POST http://localhost:8080/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "user",
        "content": "Tell me a quick joke."
      }
    ]
  }')

echo "Raw response:"
echo "$response"
echo ""
echo "Formatted response:"
echo "$response" | jq . 2>/dev/null || echo "$response"

# Test /recommend/product
echo ""
echo "3. Testing /recommend/product endpoint..."
response=$(curl -s -X POST http://localhost:8080/recommend/product \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "preferences": {
      "style": "modern",
      "color": "blue"
    },
    "history": ["laptop", "headphones"],
    "interests": ["technology", "gaming"],
    "category": "electronics",
    "budget": 1000.0
  }')

echo "Raw response:"
echo "$response"
echo ""
echo "Formatted response:"
echo "$response" | jq . 2>/dev/null || echo "$response"

# Test /recommend/content
echo ""
echo "4. Testing /recommend/content endpoint..."
response=$(curl -s -X POST http://localhost:8080/recommend/content \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "preferences": {
      "genre": "sci-fi"
    },
    "history": ["Dune", "The Martian"],
    "interests": ["science fiction", "space"],
    "content_type": "books",
    "mood": "thoughtful"
  }')

echo "Raw response:"
echo "$response"
echo ""
echo "Formatted response:"
echo "$response" | jq . 2>/dev/null || echo "$response"

# Test /recommend/personalized
echo ""
echo "5. Testing /recommend/personalized endpoint..."
response=$(curl -s -X POST http://localhost:8080/recommend/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "preferences": {
      "difficulty": "beginner"
    },
    "history": ["running", "yoga"],
    "interests": ["fitness", "wellness"],
    "context": "workout"
  }')

echo "Raw response:"
echo "$response"
echo ""
echo "Formatted response:"
echo "$response" | jq . 2>/dev/null || echo "$response"

echo ""
echo "✅ All tests completed!"
