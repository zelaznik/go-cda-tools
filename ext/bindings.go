package main

import (
	"C"

	"github.com/projectcypress/cdatools/exporter"
	"github.com/projectcypress/cdatools/importer"
)

func main() {}

//export import_cat1
func import_cat1(rawPath *C.char) *C.char {
	path := C.GoString(rawPath)
	return C.CString(importer.Read_patient(path))
}

//GenerateCat1(patient []byte, measures []byte, valueSets []byte, startDate int64, endDate int64) string {

//export generateCat1
func generateCat1(patient *C.char, measures *C.char,valueSets *C.char, startDate int64, endDate int64) *C.char {
	patientbytes := []byte(C.GoString(patient))
	measuresbytes := []byte(C.GoString(measures))
	valueSetBytes := []byte(C.GoString(valueSets))
	return C.CString(exporter.GenerateCat1(patientbytes, measuresbytes, valueSetBytes, startDate,endDate))
}
