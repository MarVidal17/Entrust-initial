package main

 

import (
    "fmt"
    "log"
    "net/http"
)

 


func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Hi, I'm Green")
	}

 

func main() {
		log.Println("Green server working!")
    http.HandleFunc("/", handler)
    if err := http.ListenAndServe(":8080", nil); err != nil {
        log.Fatalln(err)
    }
}
