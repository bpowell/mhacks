package main

import (
	"net/http"
	"time"
	"fmt"
	"strings"
	"io/ioutil"
)

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/chart", chartHandler)
	http.HandleFunc("/test", testHandler)
	http.HandleFunc("/test2", test2)
        http.ListenAndServe(":8080", nil)
}

type Glucose struct {
	Date time.Time
	Level int
}

func (g Glucose) ToArray() string {
	const layout = "Jan 2, 2006 at 3:04pm (MST)"
	return fmt.Sprintf("[\"%s\", %d]", g.Date.Format(layout), g.Level)
}

type GlucoseSlice []Glucose
func (g GlucoseSlice) ToJson() string {
	var q [] string
	q = append(q, "[[\"Date\", \"Level\"]")
	for _, value := range g {
		q = append(q, ",")
		q = append(q, value.ToArray())
	}
	q = append(q, "]")

	return strings.Join(q, "")
}

func handler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "test.html")
}

func chartHandler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "chart.html")
}

func testHandler(w http.ResponseWriter, r *http.Request) {
	a := make(GlucoseSlice, 5)
	glucose := Glucose{time.Now(), 100}
	a[0] = glucose
	a[1] = glucose

	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(a.ToJson()))
}

func test2(w http.ResponseWriter, r *http.Request) {
	client := &http.Client{
	}

	//resp, _ := client.Get("https://api.parse.com/1/login?username=andrew&password=andrew")
	req, _ := http.NewRequest("GET", "https://api.parse.com/1/login?username=andrew&password=andrew", nil)
	req.Header.Add("X-Parse-Application-Id","5UjI5QS3DY6ilN8r78oZSh19lbVSH7u4RoFgRSEh")
	req.Header.Add("X-Parse-REST-API-Key", "U90G1oAVgsLUN2ntGaDFPBIR9SWFIwtsUB8OwgGC")
	resp, _ := client.Do(req)
	w.Header().Set("Content-Type", "application/json")
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	w.Write([]byte(body))
}
