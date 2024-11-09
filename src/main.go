package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.GET("/ping", ping)

	if err := r.Run(); err != nil {
		log.Fatalf("server failed to start: %v", err)
	}
}

func ping(c *gin.Context) {
	c.String(http.StatusOK, "pong")
}
