package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
)

type Request struct {
	Name string `json:"name"`
}

type Response struct {
	Message string `json:"message"`
	Status  int    `json:"status"`
}

func handler(ctx context.Context, req Request) (Response, error) {
	log.Printf("Received request: %+v", req)

	message := fmt.Sprintf("Hello %s! This is a test Lambda function.", req.Name)
	if req.Name == "" {
		message = "Hello World! This is a test Lambda function."
	}

	return Response{
		Message: message,
		Status:  200,
	}, nil
}

func main() {
	lambda.Start(handler)
}
