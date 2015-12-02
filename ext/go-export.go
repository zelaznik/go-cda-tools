package main

import (
	"C"
	"bytes"
	"encoding/json"
)

//export generate_cat1
func generate_cat1(patient *C.char) string {
	pat := []byte(C.GoString(patient))

	p := &Record{}

	json.Unmarshal(pat, p)

	var buf bytes.Buffer
	err := Cat1Tmpl(&buf, p)

	if err != nil {
		panic(err)
	} else {
		// b, _ := json.Marshal(p)
		// return string(b)
		return buf.String()
	}
}
