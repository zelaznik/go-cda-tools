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

//export generateCat1
func generateCat1(patient *C.char, startDate C.long, endDate C.long, qrdaVersion *C.char) *C.char {
	patientbytes := []byte(C.GoString(patient))
	qrdaVersionString := C.GoString(qrdaVersion)
	return C.CString(exporter.GenerateCat1(patientbytes, int64(startDate), int64(endDate), qrdaVersionString))
}

//export loadMeasuresAndValueSets
func loadMeasuresAndValueSets(measures *C.char, valueSets *C.char) {
	exporter.LoadMeasuresAndValueSets([]byte(C.GoString(measures)), []byte(C.GoString(valueSets)))
}
