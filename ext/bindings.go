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

//export generate_cat1
func generate_cat1(patient *C.char) string {
	patientbytes := []byte(C.GoString(patient))
	return exporter.Generate_cat1(patientbytes)
}
