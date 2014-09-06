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

	req, _ := http.NewRequest("GET", "https://api.parse.com/1/classes/Glucose/", nil)
	req.Header.Add("X-Parse-Application-Id","5UjI5QS3DY6ilN8r78oZSh19lbVSH7u4RoFgRSEh")
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
	var glu []ParseObjectGlucose
	err = json.Unmarshal(result.Results, &glu)
	if err != nil {
		log.Println("error:", err)
	}
	log.Printf("%+v\n", glu)
	log.Printf("====================")


	var parseGlucose [] ParseGlucose
	for _, value := range glu {
		log.Printf("====================")
		var dateType ParseDateType
		err = json.Unmarshal(value.Date, &dateType)
		if err != nil {
			log.Println("error:", err)
		}
		log.Printf("%+v\n", dateType)

		var aclType ParseACLType
		err = json.Unmarshal(value.ACL, &aclType)
		if err != nil {
			log.Println("error:", err)
		}
		log.Printf("%+v\n", aclType)

		var glucose ParseGlucose
		glucose.Date = dateType
		glucose.Level = value.Level
		glucose.CreatedAt = value.CreatedAt
		glucose.UpdatedAt = value.UpdatedAt
		glucose.ObjectId = value.ObjectId
		glucose.ACL = aclType

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
