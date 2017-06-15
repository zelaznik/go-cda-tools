build:
ifeq ($(shell uname), Darwin)
	go build -a -buildmode=c-shared -o libgocda-mac.so bindings.go
else
	go build -a -buildmode=c-shared -o libgocda-linux.so bindings.go
endif

# fake out clean and install
clean:
install:

dependencies:
	go get -u github.com/jbowtie/gokogiri/xml github.com/pborman/uuid github.com/projectcypress/cdatools/...
	bundle install


.PHONY: build
