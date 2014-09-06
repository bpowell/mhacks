package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
	"fmt"
)

func glucoseGraph(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "glucosegraph.html")
}

func glucoseJson(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	user := login("andrew", "andrew")
	w.Write([]byte(getGlucoseFromParse(user).toJson()))
}

func getGlucoseFromParse(user User) ParseGlucoseSlice{
	client := &http.Client{
	}

	request, _ := http.NewRequest("GET", "https://api.parse.com/1/classes/Glucose/", nil)
	request.Header.Add("X-Parse-Application-Id","5UjI5QS3DY6ilN8r78oZSh19lbVSH7u4RoFgRSEh")
	request.Header.Add("X-Parse-REST-API-Key", "U90G1oAVgsLUN2ntGaDFPBIR9SWFIwtsUB8OwgGC")
	request.Header.Add("X-Parse-Session-Token", user.SessionToken)
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


	var parseGlucose [] ParseGlucose
	for _, value := range glu {
		log.Printf("====================")
		var date ParseDateType
		err = json.Unmarshal(value.Date, &date)
		if err != nil {
			log.Printf("error: %s", err.Error())
		}
		log.Printf("%+v\n", date)

		var acl ParseACLType
		err = json.Unmarshal(value.ACL, &acl)
		if err != nil {
			log.Printf("error: %s\n", err.Error())
		}
		log.Printf("%+v\n", acl)

		var glucose ParseGlucose
		glucose.Date = date
		glucose.Level = value.Level
		glucose.CreatedAt = value.CreatedAt
		glucose.UpdatedAt = value.UpdatedAt
		glucose.ObjectId = value.ObjectId
		glucose.ACL = acl

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
