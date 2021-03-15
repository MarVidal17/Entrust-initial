package main

import (
	"fmt"
	"log"
	"net/http"
)


func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hi, I'm a Go server listening on port 80")
}

func main() {
	http.HandleFunc("/", handler)
	if err := http.ListenAndServe(":80", nil); err != nil {
		log.Fatalln(err)
	}
}
