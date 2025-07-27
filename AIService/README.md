# OpenAI Integration Service

A Go service that demonstrates integration with OpenAI APIs using authorization headers. This service provides a REST API wrapper around OpenAI's chat completions and text generation endpoints.

## Features

- **Chat Completions**: Use OpenAI's chat models (GPT-3.5-turbo, GPT-4, etc.)
- **Text Generation**: Use OpenAI's completion models (text-davinci-003, etc.)
- **Recommendation System**: AI-powered recommendations for products, content, and personalized suggestions
- **Authorization**: Secure API key handling via Bearer token authentication
- **Health Check**: Service health monitoring endpoint
- **Configurable**: Environment-based configuration

## Prerequisites

- Go 1.21 or higher
- OpenAI API key

## Setup

1. **Clone or navigate to the service directory:**
   ```bash
   cd AIService
   ```

2. **Set your OpenAI API key as an environment variable:**
   ```bash
   export OPENAI_API_KEY="your-openai-api-key-here"
   ```

3. **Install dependencies:**
   ```bash
   go mod tidy
   ```

4. **Run the service:**
   ```bash
   go run main.go
   ```

The service will start on port 8080 by default. You can change this by setting the `PORT` environment variable.

## Configuration

The service uses the following environment variables:

- `OPENAI_API_KEY` (required): Your OpenAI API key
- `OPENAI_BASE_URL` (optional): OpenAI API base URL (defaults to `https://api.openai.com`)
- `PORT` (optional): Service port (defaults to `8080`)

## API Endpoints

### 1. Health Check
```http
GET /health
```

**Response:**
```json
{
  "status": "healthy",
  "service": "openai-integration-service"
}
```

### 2. Chat Completion
```http
POST /chat/completion
Content-Type: application/json

{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "user",
      "content": "Hello, how are you?"
    }
  ],
  "max_tokens": 1000,
  "temperature": 0.7
}
```

**Response:**
```json
{
  "id": "chatcmpl-123",
  "object": "chat.completion",
  "created": 1677652288,
  "model": "gpt-3.5-turbo",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Hello! I'm doing well, thank you for asking. How can I help you today?"
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 9,
    "completion_tokens": 12,
    "total_tokens": 21
  }
}
```

### 3. Text Generation
```http
POST /text/generation
Content-Type: application/json

{
  "model": "gpt-3.5-turbo",
  "prompt": "Write a short story about a robot learning to paint.",
  "max_tokens": 500,
  "temperature": 0.8
}
```

**Response:**
```json
{
  "id": "chatcmpl-123",
  "object": "text_completion",
  "created": 1677652288,
  "model": "gpt-3.5-turbo",
  "choices": [
    {
      "text": "Once upon a time, in a world where robots and humans coexisted...",
      "index": 0,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 10,
    "completion_tokens": 150,
    "total_tokens": 160
  }
}
```

### 4. Product Recommendations
```http
POST /recommendations/products
Content-Type: application/json

{
  "user_profile": {
    "user_id": "user123",
    "preferences": {
      "style": "modern",
      "color": "blue"
    },
    "history": ["laptop", "headphones", "smartphone"],
    "interests": ["technology", "gaming", "music"],
    "age": 28,
    "location": "San Francisco"
  },
  "category": "electronics",
  "max_results": 5,
  "budget": 500.0
}
```

**Response:**
```json
{
  "recommendations": [
    {
      "id": "rec_1",
      "title": "Wireless Gaming Headset",
      "description": "High-quality wireless gaming headset with noise cancellation",
      "category": "electronics",
      "score": 0.95,
      "metadata": {
        "price": "$299.99",
        "brand": "GamingPro",
        "rating": "4.8/5"
      }
    }
  ],
  "reasoning": "Based on your interest in gaming and technology, and your history of purchasing electronics, this gaming headset would be a great addition to your setup.",
  "confidence": 0.85,
  "user_id": "user123"
}
```

### 5. Content Recommendations
```http
POST /recommendations/content
Content-Type: application/json

{
  "user_profile": {
    "user_id": "user123",
    "preferences": {
      "genre": "sci-fi",
      "format": "ebook"
    },
    "history": ["Dune", "The Martian", "Ready Player One"],
    "interests": ["science fiction", "technology", "space"],
    "age": 28,
    "location": "San Francisco"
  },
  "content_type": "books",
  "max_results": 5,
  "mood": "adventurous"
}
```

**Response:**
```json
{
  "recommendations": [
    {
      "id": "rec_1",
      "title": "Project Hail Mary",
      "description": "A thrilling space adventure by Andy Weir",
      "category": "books",
      "score": 0.92,
      "metadata": {
        "author": "Andy Weir",
        "genre": "Science Fiction",
        "duration": "12 hours"
      }
    }
  ],
  "reasoning": "Given your love for space-themed sci-fi and your enjoyment of The Martian, this book would be perfect for you.",
  "confidence": 0.88,
  "user_id": "user123"
}
```

### 6. Personalized Recommendations
```http
POST /recommendations/personalized
Content-Type: application/json

{
  "user_profile": {
    "user_id": "user123",
    "preferences": {
      "difficulty": "intermediate",
      "duration": "30-60 minutes"
    },
    "history": ["yoga", "running", "weightlifting"],
    "interests": ["fitness", "health", "wellness"],
    "age": 28,
    "location": "San Francisco"
  },
  "context": "workout",
  "max_results": 5
}
```

**Response:**
```json
{
  "recommendations": [
    {
      "id": "rec_1",
      "title": "HIIT Circuit Training",
      "description": "High-intensity interval training circuit for intermediate fitness level",
      "category": "workout",
      "score": 0.89,
      "metadata": {
        "difficulty": "intermediate",
        "time_required": "45 minutes",
        "equipment": "minimal"
      }
    }
  ],
  "reasoning": "Based on your fitness history and preference for intermediate difficulty workouts, this HIIT circuit would be perfect for your fitness level.",
  "confidence": 0.87,
  "user_id": "user123"
}
```

## Example Usage

### Using curl

**Health Check:**
```bash
curl http://localhost:8080/health
```

**Chat Completion:**
```bash
curl -X POST http://localhost:8080/chat/completion \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "user",
        "content": "Explain quantum computing in simple terms"
      }
    ],
    "max_tokens": 300
  }'
```

**Text Generation:**
```bash
curl -X POST http://localhost:8080/text/generation \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-3.5-turbo",
    "prompt": "The future of artificial intelligence is",
    "max_tokens": 200,
    "temperature": 0.8
  }'
```

**Product Recommendations:**
```bash
curl -X POST http://localhost:8080/recommendations/products \
  -H "Content-Type: application/json" \
  -d '{
    "user_profile": {
      "user_id": "user123",
      "preferences": {"style": "modern"},
      "history": ["laptop", "headphones"],
      "interests": ["technology", "gaming"],
      "age": 28,
      "location": "San Francisco"
    },
    "category": "electronics",
    "max_results": 3,
    "budget": 500.0
  }'
```

**Content Recommendations:**
```bash
curl -X POST http://localhost:8080/recommendations/content \
  -H "Content-Type: application/json" \
  -d '{
    "user_profile": {
      "user_id": "user123",
      "preferences": {"genre": "sci-fi"},
      "history": ["Dune", "The Martian"],
      "interests": ["science fiction", "space"],
      "age": 28,
      "location": "San Francisco"
    },
    "content_type": "books",
    "max_results": 3,
    "mood": "adventurous"
  }'
```

**Personalized Recommendations:**
```bash
curl -X POST http://localhost:8080/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "user_profile": {
      "user_id": "user123",
      "preferences": {"difficulty": "intermediate"},
      "history": ["yoga", "running"],
      "interests": ["fitness", "health"],
      "age": 28,
      "location": "San Francisco"
    },
    "context": "workout",
    "max_results": 3
  }'
```

### Using JavaScript/Node.js

```javascript
// Chat completion
const response = await fetch('http://localhost:8080/chat/completion', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    model: 'gpt-3.5-turbo',
    messages: [
      {
        role: 'user',
        content: 'What is machine learning?'
      }
    ],
    max_tokens: 500
  })
});

const result = await response.json();
console.log(result.choices[0].message.content);
```

## Docker Support

You can also run this service using Docker:

1. **Build the Docker image:**
   ```bash
   docker build -t openai-integration-service .
   ```

2. **Run the container:**
   ```bash
   docker run -p 8080:8080 -e OPENAI_API_KEY="your-api-key" openai-integration-service
   ```

## Security Considerations

- **API Key Protection**: Never commit your OpenAI API key to version control
- **Environment Variables**: Use environment variables for sensitive configuration
- **HTTPS**: In production, always use HTTPS to protect API communications
- **Rate Limiting**: Consider implementing rate limiting for your endpoints
- **Input Validation**: The service includes basic input validation, but consider adding more robust validation for production use

## Error Handling

The service includes comprehensive error handling:

- Invalid API keys return appropriate error messages
- Network timeouts are handled gracefully
- Malformed requests return HTTP 400 errors
- OpenAI API errors are properly propagated

## Development

To run the service in development mode with hot reloading, you can use tools like `air`:

```bash
# Install air
go install github.com/cosmtrek/air@latest

# Run with air
air
```

## License

This project is open source and available under the MIT License. 