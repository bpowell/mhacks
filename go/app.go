package main

import (
	"net/http"
	"time"
	"fmt"
	"strings"
	"io/ioutil"
	"encoding/json"
	"log"
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

type User struct {
	CreatedAt time.Time
	ObjectId string
	SessionToken string
	UpdatedAt time.Time
	Username string
}

type Results struct {
	Results json.RawMessage
}

type ParseObjectGlucose struct {
	Date json.RawMessage
	Level int
	CreatedAt time.Time
	UpdatedAt time.Time
	ObjectId string
	ACL json.RawMessage
}

type ParseDateType struct {
	Type string
	Iso time.Time
}

type ParseACLType struct {
	Read bool
	Write bool
}

type ParseGlucose struct {
	Date ParseDateType
	Level int
	CreatedAt time.Time
	UpdatedAt time.Time
	ObjectId string
	ACL ParseACLType
}

func getstuff(user User) []byte{
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

	return ([]byte(body))
}

func test2(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Write(getstuff(login("andrew", "andrew")))
}

func login(username string, password string) User {
	client := &http.Client{
	}

	req, _ := http.NewRequest("GET", "https://api.parse.com/1/login?username="+username+"&password="+password, nil)
	req.Header.Add("X-Parse-Application-Id","5UjI5QS3DY6ilN8r78oZSh19lbVSH7u4RoFgRSEh")
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
