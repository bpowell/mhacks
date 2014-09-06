package mhacks

import (
	"net/http"
	"time"
	"fmt"
)

type Glucose struct {
	Date time.Time
	Level int
}

func init() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/chart", chartHandler)
	http.HandleFunc("/test", testHandler)
}

func handler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "test.html")
}

func chartHandler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "chart.html")
}

func testHandler(w http.ResponseWriter, r *http.Request) {
	var a [5] Glucose
	glucose := Glucose{time.Now(), 100}
	a[0] = glucose
	a[1] = glucose

	var js = fmt.Sprintf("[[\"Date\", \"Level\"],[\"new Date(%s)\",%d]]", glucose.Date, glucose.Level)

	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(js))
}
