build: template_compile
	go build -buildmode=c-shared -o libgocda.so go-import.go go-export.go models.go cat1_templates.go

template_compile:
	ego -o cat1_templates.go -package main templates
	
# fake out clean and install
clean:
install:

.PHONY: build
