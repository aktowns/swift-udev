swift=swiftc
udev_build=$(shell pwd)/.build/debug
linkerflags=-Xlinker $(shell pwd)/.build/debug/Udev.a -ludev
includes=-I $(shell pwd)/.build/debug/ -I $(shell pwd)/Packages/swift-udev-binding-1.0.1

all: UdevExample UdevSanityTest lspci

UdevExample: .build/debug/Udev.a Examples/UdevExample/main.swift
	swiftc $(linkerflags) $(includes) Examples/UdevExample/main.swift -o UdevExample

UdevSanityTest: .build/debug/Udev.a Examples/UdevSanityTest/main.swift
	swiftc $(linkerflags) $(includes) Examples/UdevSanityTest/main.swift -o UdevSanityTest

lspci: .build/debug/Udev.a Examples/lspci/main.swift
	swiftc $(linkerflags) $(includes) -g Examples/lspci/main.swift -o lspci

.build/debug/Udev.a: Sources/*.swift
	swift build
