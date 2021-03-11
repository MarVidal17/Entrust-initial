package main

 

import (
    "log"
	"time"
)



func main() {
	dt := time.Now() 
	log.Println("Hello! ~ ", dt.String())
}
