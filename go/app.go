package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"time"
)

type GraphPage struct {
	PageTitle string
	Json string
	ChartTitle string
}

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/glucoseGraph", glucoseGraph)
	http.HandleFunc("/insulinGraph", insulinGraph)
	http.ListenAndServe(":8080", nil)
}

func handler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "test.html")
}

type User struct {
	CreatedAt    time.Time
	ObjectId     string
	SessionToken string
	UpdatedAt    time.Time
	Username     string
}

type Results struct {
	Results json.RawMessage
}
type ParseDateType struct {
	Type string
	Iso  time.Time
}

type ParseACLType struct {
	Read  bool
	Write bool
}

func login(username string, password string) User {
	client := &http.Client{}

	req, _ := http.NewRequest("GET", "https://api.parse.com/1/login?username="+username+"&password="+password, nil)
	req.Header.Add("X-Parse-Application-Id", "5UjI5QS3DY6ilN8r78oZSh19lbVSH7u4RoFgRSEh")
	req.Header.Add("X-Parse-REST-API-Key", "U90G1oAVgsLUN2ntGaDFPBIR9SWFIwtsUB8OwgGC")
	resp, _ := client.Do(req)
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)

	var user User
	err := json.Unmarshal(body, &user)
	if err != nil {
		log.Printf("error: %s\n", err.Error())
	}

	log.Printf("User information: %+v\n", user)

	return user
}
