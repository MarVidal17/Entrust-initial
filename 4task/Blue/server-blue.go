package main

 

import (
    "fmt"
    "log"
    "net/http"
)

 


func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Hi, I'm Blue")
}

 

func main() {
		log.Println("Blue server working!")
    http.HandleFunc("/", handler)
    if err := http.ListenAndServe(":8080", nil); err != nil {
        log.Fatalln(err)
    }
}
