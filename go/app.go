package mhacks

import (
	"net/http"
	"time"
	"fmt"
	"strings"
)

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
	a := make(GlucoseSlice, 5)
	glucose := Glucose{time.Now(), 100}
	a[0] = glucose
	a[1] = glucose

	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(a.ToJson()))
}
