package main

import (
	"C"

	"github.com/projectcypress/cdatools/exporter"
	"github.com/projectcypress/cdatools/importer"
)

func main() {}

//export import_cat1
func import_cat1(rawPath *C.char) string {
	path := C.GoString(rawPath)
	return importer.Read_patient(path)
}

//export generateCat1
func generateCat1(patient *C.char, measures *C.char) string {
	patientbytes := []byte(C.GoString(patient))
	measuresbytes := []byte(C.GoString(measures))
	return exporter.GenerateCat1(patientbytes, measuresbytes)
}
