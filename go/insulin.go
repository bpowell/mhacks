package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"time"
	"strings"
	"fmt"
)

type Acting int

const (
	rapid Acting = iota
	long
)

func insulinJson(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	user := login("andrew", "andrew")
	w.Write([]byte(getInsulinFromParse(user).toJson()))
}

func insulinGraph(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "insulingraph.html")
}

type ParseObjectInsulin struct {
	Date json.RawMessage
	Dose json.RawMessage
	Type json.RawMessage
	// unused:
	CreatedAt time.Time
	UpdatedAt time.Time
	ObjectId  string
	ACL       json.RawMessage
}

type ParseInsulin struct {
	Date ParseDateType
	Dose float32
	Type Acting
}

func getInsulinFromParse(user User) ParseInsulinSlice {
	client := &http.Client{}

	req, _ := http.NewRequest("GET", "https://api.parse.com/1/classes/Insulin/", nil)
	req.Header.Add("X-Parse-Application-Id", "5UjI5QS3DY6ilN8r78oZSh19lbVSH7u4RoFgRSEh")
	req.Header.Add("X-Parse-REST-API-Key", "U90G1oAVgsLUN2ntGaDFPBIR9SWFIwtsUB8OwgGC")
	req.Header.Add("X-Parse-Session-Token", user.SessionToken)
	resp, _ := client.Do(req)
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)

	var result Results
	err := json.Unmarshal(body, &result)
	if err != nil {
		log.Println("error:", err)
	}
	log.Printf("%+v\n", result)
	log.Printf("%s\n", string(result.Results))
	log.Printf("====================")
	var ins []ParseObjectInsulin
	err = json.Unmarshal(result.Results, &ins)
	if err != nil {
		log.Println("error:", err)
	}
	log.Printf("%+v\n", ins)
	log.Printf("====================")

	var parseInsulin []ParseInsulin
	for _, value := range ins {
		log.Printf("====================")
		var dateType ParseDateType
		err = json.Unmarshal(value.Date, &dateType)
		if err != nil {
			log.Println("error:", err)
		}
		log.Printf("%+v\n", dateType)

		var actingType Acting
		err = json.Unmarshal(value.Type, &actingType)
		if err != nil {
			log.Println("error:", err)
		}

		var dose float32
		err = json.Unmarshal(value.Dose, &dose)
		if err != nil {
			log.Println("error:", err)
		}

		var insulin ParseInsulin
		insulin.Date = dateType
		insulin.Type = actingType
		insulin.Dose = dose

		parseInsulin = append(parseInsulin, insulin)

		log.Printf("====================")
	}

	log.Printf("====================")
	log.Printf("====================")
	log.Printf("%+v\n", parseInsulin)
	log.Printf("====================")
	log.Printf("====================")

	return parseInsulin
}

type ParseInsulinSlice []ParseInsulin

func (g ParseInsulinSlice) toJson() string {
	var q []string
	q = append(q, "[[\"Date\", \"Dose\"]")
	for _, value := range g {
		q = append(q, ",")
		q = append(q, value.toArray())
	}
	q = append(q, "]")

	return strings.Join(q, "")
}

func (g ParseInsulin) toArray() string {
	const layout = "Jan 2, 2006 at 3:04pm (MST)"
	return fmt.Sprintf("[\"%s\", %f]", g.Date.Iso.Format(layout), g.Dose)
}
