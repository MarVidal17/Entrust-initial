package main

 

import (
    "fmt"
    "log"
    "net/http"
	"os"
    "bufio"
    "strconv"
    "strings"
)

 


func handler(w http.ResponseWriter, r *http.Request) {
	filename := "../data/counter.txt"
    var f *os.File
 
    counter := 0
    _, err := os.Stat(filename)
    if !os.IsNotExist(err) {
        f, _ = os.Open(filename)
        reader := bufio.NewReader(f)
        var counter_str string
        counter_str, err := reader.ReadString('\n')
        if err != nil {
            fmt.Println("error")
            fmt.Println(err)
            os.Exit(1)
        }
        counter_str = strings.TrimSuffix(counter_str, "\n")
        counter, err = strconv.Atoi(counter_str)
        if err != nil {
            fmt.Println("error")
            fmt.Println(err)
            os.Exit(1)
        }
    }
 
    counter++
 
    f, err = os.Create(filename)
    if err == nil {
        f.WriteString(fmt.Sprintf("%d\n", counter))
        f.Close()
    }
    fmt.Fprintln(w, "Counter incremented: ", counter)
}

 

func main() {
		log.Println("Counter working!")
    http.HandleFunc("/", handler)
    if err := http.ListenAndServe(":8080", nil); err != nil {
        log.Fatalln(err)
    }
}
