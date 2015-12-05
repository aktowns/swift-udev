swift=swiftc
udev_build=$(shell pwd)/.build/debug
linkerflags=-Xlinker $(shell pwd)/.build/debug/Udev.a -ludev
includes=-I $(shell pwd)/.build/debug/ -I $(shell pwd)/Packages/swift-udev-binding-1.0.1

all: bin/UdevExample bin/UdevSanityTest bin/lspci bin/lsusb

bin:
	mkdir -p ./bin

bin/UdevExample: bin .build/debug/Udev.a Examples/UdevExample/main.swift
	swiftc $(linkerflags) $(includes) Examples/UdevExample/main.swift -o ./bin/UdevExample

bin/UdevSanityTest: bin .build/debug/Udev.a Examples/UdevSanityTest/main.swift
	swiftc $(linkerflags) $(includes) Examples/UdevSanityTest/main.swift -o ./bin/UdevSanityTest

bin/lspci: bin .build/debug/Udev.a Examples/lspci/main.swift
	swiftc $(linkerflags) $(includes) -g Examples/lspci/main.swift -o ./bin/lspci

bin/lsusb: bin .build/debug/Udev.a Examples/lsusb/main.swift
	swiftc $(linkerflags) $(includes) -g Examples/lsusb/main.swift -o ./bin/lsusb

.build/debug/Udev.a: Sources/*.swift
	swift build
