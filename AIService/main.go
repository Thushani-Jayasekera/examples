package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2/clientcredentials"
)

// const OpenAIAPIURL = "https://api.openai.com/v1/chat/completions"
const defaultModel = "gpt-4o"

// Request payload for chat completion
type ChatCompletionRequest struct {
	Model       string        `json:"model"`
	Messages    []ChatMessage `json:"messages"`
	MaxTokens   int           `json:"max_tokens,omitempty"`
	Temperature float64       `json:"temperature,omitempty"`
}

type ChatMessage struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

// Response payload from OpenAI

// CompletionChoice represents a single choice from the response
// It reuses ChatMessage for simplicity

type ChatCompletionResponse struct {
	Choices []struct {
		Message ChatMessage `json:"message"`
	} `json:"choices"`
}

func main() {
	r := gin.Default()

	r.POST("/chat", handleChatCompletion)
	r.POST("/recommend/product", handleProductRecommendations)
	r.POST("/recommend/content", handleContentRecommendations)
	r.POST("/recommend/personalized", handlePersonalizedRecommendations)

	r.Run(":8080")
}

func handleChatCompletion(c *gin.Context) {
	var request ChatCompletionRequest
	if err := c.BindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}
	if request.Model == "" {
		request.Model = defaultModel
	}

	var response ChatCompletionResponse
	err := makeRequest("/v1/chat/completions", request, &response)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if len(response.Choices) == 0 {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "No response from OpenAI"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reply": response.Choices[0].Message.Content})
}

// Recommendation requests reuse the chat endpoint
func handleProductRecommendations(c *gin.Context) {
	generateRecommendations(c, "Suggest 3 innovative product ideas for a tech startup.")
}

func handleContentRecommendations(c *gin.Context) {
	generateRecommendations(c, "Give me 5 blog post titles about AI in healthcare.")
}

func handlePersonalizedRecommendations(c *gin.Context) {
	generateRecommendations(c, "What would be good hobbies for someone who loves puzzles and history?")
}

func generateRecommendations(c *gin.Context, prompt string) {
	req := ChatCompletionRequest{
		Model: defaultModel,
		Messages: []ChatMessage{
			{Role: "user", Content: prompt},
		},
		MaxTokens:   100,
		Temperature: 0.7,
	}

	var response ChatCompletionResponse
	err := makeRequest("/v1/chat/completions", req, &response)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if len(response.Choices) == 0 {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "No response from OpenAI"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"recommendations": response.Choices[0].Message.Content})
}
	
func makeRequest(endpoint string, payload interface{}, result interface{}) error {
	consumerKey := os.Getenv("CHOREO_ORGLEVELCONNECTION_CONSUMERKEY")
	consumerSecret := os.Getenv("CHOREO_ORGLEVELCONNECTION_CONSUMERSECRET")
	serviceURL := os.Getenv("CHOREO_ORGLEVELCONNECTION_SERVICEURL")
	correctServiceURL := os.Getenv("CHOREO_SERVICEURL")
	tokenURL := os.Getenv("CHOREO_ORGLEVELCONNECTION_TOKENURL")
	correctTokenURL := os.Getenv("CHOREO_TOKENURL")
	choreoApiKey := os.Getenv("CHOREO_ORGLEVELCONNECTION_APIKEY")

	fmt.Println("consumerKey: ", consumerKey)
	fmt.Println("consumerSecret: ", consumerSecret)
	fmt.Println("serviceURL: ", serviceURL)
	fmt.Println("correctServiceURL: ", correctServiceURL)
	fmt.Println("tokenURL: ", tokenURL)
	fmt.Println("correctTokenURL: ", correctTokenURL)
	fmt.Println("choreoApiKey: ", choreoApiKey)

	// Create OAuth2 client with client ID, client secret and token URL
	var clientCredsConfig = clientcredentials.Config{
	ClientID:     consumerKey,
	ClientSecret: consumerSecret,
	TokenURL:     correctTokenURL,
	}

	client := clientCredsConfig.Client(context.Background())


	data, err := json.Marshal(payload)
	if err != nil {
		return err
	}

	req, err := http.NewRequest("POST", correctServiceURL+endpoint, bytes.NewBuffer(data))
	if err != nil {
		return err
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Add("Choreo-API-Key", choreoApiKey)

	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	if resp.StatusCode != http.StatusOK {
		log.Printf("OpenAI API error: %s", string(body))
		return fmt.Errorf("OpenAI API error: %s", string(body))
	}

	return json.Unmarshal(body, result)
}
