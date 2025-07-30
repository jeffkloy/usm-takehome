package main

import (
    "encoding/json"
    "log"
    "net/http"
    "os"
    "time"
)

type Response struct {
    Message   string    `json:"message"`
    Timestamp time.Time `json:"timestamp"`
    Hostname  string    `json:"hostname,omitempty"`
}

type HealthResponse struct {
    Status    string    `json:"status"`
    Timestamp time.Time `json:"timestamp"`
}

func main() {
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    http.HandleFunc("/", helloHandler)
    http.HandleFunc("/health", healthHandler)
    http.HandleFunc("/ready", readyHandler)

    log.Printf("Server starting on port %s", port)
    if err := http.ListenAndServe(":"+port, nil); err != nil {
        log.Fatal(err)
    }
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
    hostname, _ := os.Hostname()
    
    response := Response{
        Message:   "Hello World",
        Timestamp: time.Now(),
        Hostname:  hostname,
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    response := HealthResponse{
        Status:    "healthy",
        Timestamp: time.Now(),
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}

func readyHandler(w http.ResponseWriter, r *http.Request) {
    // Add readiness checks here (DB connections, etc.)
    response := HealthResponse{
        Status:    "ready",
        Timestamp: time.Now(),
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}
