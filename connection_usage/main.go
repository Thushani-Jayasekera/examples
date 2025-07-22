package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
)

func getEnv(key string) string {
	value := os.Getenv(key)
	if value == "" {
		fmt.Printf("Environment variable %s not set\n", key)
		os.Exit(1)
	}
	return value
}

func getToken(tokenURL, consumerKey, consumerSecret string) (string, error) {
	data := []byte("grant_type=client_credentials")

	req, err := http.NewRequest("POST", tokenURL, bytes.NewBuffer(data))
	if err != nil {
		return "", err
	}

	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth(consumerKey, consumerSecret)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("token request failed: %s", string(body))
	}

	var result map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return "", err
	}

	accessToken, ok := result["access_token"].(string)
	if !ok {
		return "", fmt.Errorf("access_token not found in response")
	}

	return accessToken, nil
}

func callService(serviceURL, token string) error {
	req, err := http.NewRequest("GET", serviceURL, nil)
	if err != nil {
		return err
	}

	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	fmt.Printf("Response from service (%s):\n", serviceURL)
	body, _ := io.ReadAll(resp.Body)
	fmt.Println(string(body))

	return nil
}

func main() {
	serviceURL := getEnv("CHOREO_BIJIRAPOPENAICON_SERVICEURL")
	consumerKey := getEnv("CHOREO_BIJIRAPOPENAICON_CONSUMERKEY")
	consumerSecret := getEnv("CHOREO_BIJIRAPOPENAICON_CONSUMERSECRET")
	tokenURL := getEnv("CHOREO_BIJIRAPOPENAICON_TOKENURL")

	fmt.Println("Environment variables:")
	fmt.Println("ServiceURL:", serviceURL)
	fmt.Println("ConsumerKey:", consumerKey)
	fmt.Println("ConsumerSecret:", "[REDACTED]")
	fmt.Println("TokenURL:", tokenURL)

	token, err := getToken(tokenURL, consumerKey, consumerSecret)
	if err != nil {
		fmt.Println("Error getting token:", err)
		return
	}

	fmt.Println("Access Token:", token)

	if err := callService(serviceURL, token); err != nil {
		fmt.Println("Error calling service:", err)
	}
}
