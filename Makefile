
configure:
	obuild configure --enable-tests

configure-no-tests:
	obuild configure

test:
	obuild test

clean:
	obuild clean

build:
	obuild build

.PHONY: configure configure-no-tests test clean

