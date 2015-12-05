swift=swiftc
udev_build=$(shell pwd)/.build/debug
linkerflags=-Xlinker $(shell pwd)/.build/debug/Udev.a -ludev
includes=-I $(shell pwd)/.build/debug/ -I $(shell pwd)/Packages/swift-udev-binding-1.0.1

all: UdevExample UdevSanityTest

UdevExample: .build/debug/Udev.a
	swiftc $(linkerflags) $(includes) Examples/UdevExample/main.swift -o UdevExample

UdevSanityTest: .build/debug/Udev.a
	swiftc $(linkerflags) $(includes) Examples/UdevSanityTest/main.swift -o UdevSanityTest

.build/debug/Udev.a: Sources/*.swift
	swift build
