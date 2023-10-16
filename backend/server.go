package main

import (
	"log"
	"net/http"
)

const containerPort = "4000"

func main() {
	http.ListenAndServe(":4000", nil)
	log.Printf("connect to http://localhost:%s/ for GraphQL playground", "4000")
}
