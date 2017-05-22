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
func generateCat1(patient *C.char, measures *C.char, valueSets *C.char, startDate C.long, endDate C.long, qrdaVersion *C.char, cmsCompatibleFlag C.int) *C.char {
	patientbytes := []byte(C.GoString(patient))
	measuresbytes := []byte(C.GoString(measures))
	valueSetsBytes := []byte(C.GoString(valueSets))
	qrdaVersionString := C.GoString(qrdaVersion)
	cmsCompatibility := int(cmsCompatibleFlag) != 0
	return C.CString(exporter.GenerateCat1(patientbytes, measuresbytes, valueSetsBytes, int64(startDate), int64(endDate), qrdaVersionString, cmsCompatibility))
}
