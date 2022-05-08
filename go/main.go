package main

import (
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	nats "github.com/nats-io/nats.go"
)

var (
	natsServerURl string
	listenAddr    = "0.0.0.0:8080"
)

func index(w http.ResponseWriter, r *http.Request) {
	rd := rand.New(rand.NewSource(time.Now().UnixNano()))
	fmt.Fprintf(w, "Hello, world, %v!", rd.Int())
}

func main() {
	mux := http.NewServeMux()
	mux.Handle("/", http.HandlerFunc(index))

	go func() {
		log.Printf("start to listen on %s", listenAddr)
		if err := http.ListenAndServe(listenAddr, mux); err != nil {
			log.Fatalf("failed to listen on %s, error: %v", listenAddr, err)
		}
	}()

	go func() {
		natsServerURl = os.Getenv("NATS_SERVER_URL")
		if natsServerURl == "" {
			natsServerURl = nats.DefaultURL
		}

		nc, err := nats.Connect(natsServerURl)
		if err != nil {
			log.Printf("failed to connect to nats server, error: %v", err)
			return
		}
		// Simple Publisher
		err = nc.Publish("foo", []byte("Hello World"))
		if err != nil {
			log.Printf("failed to publish: %v", err)
			return
		}
		log.Println("publish done")
	}()

	chQuit := make(chan os.Signal, 1)
	signal.Notify(chQuit, syscall.SIGINT, syscall.SIGTERM)
	select {
	case sig := <-chQuit:
		log.Printf("exiting with signal: %v", sig)
	}
}
