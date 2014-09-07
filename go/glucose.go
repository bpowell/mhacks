package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
	"time"
	"text/template"
)

type ParseObjectGlucose struct {
	Date  json.RawMessage
	Level int
	// unused:
	CreatedAt time.Time
	UpdatedAt time.Time
	ObjectId  string
	ACL       json.RawMessage
}

type ParseGlucose struct {
	Date  ParseDateType
	Level int
}

func glucoseGraph(w http.ResponseWriter, r *http.Request) {
	log.Printf("%s\n", r.Method)
	if r.Method != "POST" {
		http.Error(w, "Error lol", http.StatusInternalServerError)
	}

	err := r.ParseForm()
	if err != nil {
		log.Printf("bad %s\n", err.Error())
	}

	s := r.FormValue("sessiontoken")
	json := getGlucoseFromParse(s).toJson()
	page := GraphPage{"Glucose", json, "Glucode Level (mg/dL)"}
	log.Printf("%s\n", json)

	template.Must(template.ParseFiles("graph.html")).ExecuteTemplate(w, "graph.html", &page)
}

func statsGraph(w http.ResponseWriter, r *http.Request) {
	log.Printf("%s\n", r.Method)
	if r.Method != "POST" {
		http.Error(w, "Error lol", http.StatusInternalServerError)
	}

	err := r.ParseForm()
	if err != nil {
		log.Printf("bad %s\n", err.Error())
	}

	s := r.FormValue("sessiontoken")
	glucose := getGlucoseFromParse(s)
	var levels []int
	for _, value := range glucose {
		levels = append(levels, value.Level)
	}
	median := Median(levels)
	avg := average(levels)
	std := online_variance(levels)
	var json string = fmt.Sprintf("[[\"Stat\", \"Value\"],[\"Median\", %d],[\"Average\", %f], [\"Std Dev\", %f]]", median, avg, std)
	log.Printf("%s\n", json)

	page := GraphPage{"Stats", json, "Basic Stats"}

	template.Must(template.ParseFiles("barchart.html")).ExecuteTemplate(w, "barchart.html", &page)
}

func getGlucoseFromParse(token string) ParseGlucoseSlice {
	client := &http.Client{}

	request, _ := http.NewRequest("GET", "https://api.parse.com/1/classes/Glucose/", nil)
	request.Header.Add("X-Parse-Application-Id", "5UjI5QS3DY6ilN8r78oZSh19lbVSH7u4RoFgRSEh")
	request.Header.Add("X-Parse-REST-API-Key", "U90G1oAVgsLUN2ntGaDFPBIR9SWFIwtsUB8OwgGC")
	request.Header.Add("X-Parse-Session-Token", token)
	response, _ := client.Do(request)
	defer response.Body.Close()
	body, _ := ioutil.ReadAll(response.Body)

	var result Results
	err := json.Unmarshal(body, &result)
	if err != nil {
		log.Printf("error: %s", err.Error())
	}
	log.Printf("%+v\n", result)
	log.Printf("%s\n", string(result.Results))

	log.Printf("====================")
	var glu []ParseObjectGlucose
	err = json.Unmarshal(result.Results, &glu)
	if err != nil {
		log.Printf("error: %s\n", err.Error())
	}
	log.Printf("%+v\n", glu)
	log.Printf("====================")

	var parseGlucose []ParseGlucose
	for _, value := range glu {
		log.Printf("====================")
		var date ParseDateType
		err = json.Unmarshal(value.Date, &date)
		if err != nil {
			log.Printf("error: %s", err.Error())
		}
		log.Printf("%+v\n", date)

		var glucose ParseGlucose
		glucose.Date = date
		glucose.Level = value.Level

		parseGlucose = append(parseGlucose, glucose)

		log.Printf("====================")
	}

	log.Printf("====================")
	log.Printf("====================")
	log.Printf("%+v\n", parseGlucose)
	log.Printf("====================")
	log.Printf("====================")

	return parseGlucose
}

type ParseGlucoseSlice []ParseGlucose

func (g ParseGlucoseSlice) toJson() string {
	var q []string
	q = append(q, "[[\"Date\", \"Level\"]")
	for _, value := range g {
		q = append(q, ",")
		q = append(q, value.toArray())
	}
	q = append(q, "]")

	return strings.Join(q, "")
}

func (g ParseGlucose) toArray() string {
	const layout = "Jan 2, 2006 at 3:04pm (MST)"
	return fmt.Sprintf("[\"%s\", %d]", g.Date.Iso.Format(layout), g.Level)
}
