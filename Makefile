default:
	go build -buildmode=c-shared -o libgoimport.so ext/go-import.go

.PHONY: default
