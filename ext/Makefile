build:
	go build -a -buildmode=c-shared -o libgocda.so bindings.go

# fake out clean and install
clean:
install:

dependencies:
	go get github.com/jbowtie/gokogiri/xml github.com/pborman/uuid
	bundle install


.PHONY: build
