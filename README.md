# Udev

work in progress wrapper over [libudev](http://www.freedesktop.org/software/systemd/man/libudev.html) for swift.   
learning as i go, give me a yell if things are terribly wrong!

```swift
let udev = Udev()
let device = udev.device(fromSyspath: "/sys/devices/pci0000:00/0000:00:01.0")
print(device!.subsystem) // => Optional("pci")
print(device!.driver)    // => Optional("pcieport")
// ..

let enumerator = udev.enumerate(fromSubsystem: .HIDRaw)
for device in enumerator {
  print("syspath=", terminator: "")
  print(device.syspath)
}

// =>
// syspath=Optional("/sys/devices/pci0000:00/0000:00:14.0/usb1/1-12/1-12:1.0/0003:05AC:0262.0001/hidraw/hidraw0")
// syspath=Optional("/sys/devices/pci0000:00/0000:00:14.0/usb1/1-12/1-12:1.1/0003:05AC:0262.0002/hidraw/hidraw1")
```

## Examples
### lsusb
produces a lsusb-like output

    λ Udev git master → bin/lsusb
    Bus 1 Device 1: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 1 Device 3: ID 05ac:0262 Apple, Inc.
    Bus 1 Device 6: ID 05ac:8289 Apple, Inc.
    Bus 1 Device 2: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub (part of BCM2046 Bluetooth)
    Bus 2 Device 1: ID 1d6b:0003 Linux Foundation 3.0 root hub

### lspci
produces lspci like output

    λ Udev git master → bin/lspci
    0000:00:00.0 Host bridge: Intel Corporation Crystal Well DRAM Controller
    0000:00:01.0 PCI bridge: Intel Corporation Crystal Well PCI Express x16 Controller
    0000:01:00.0 VGA compatible controller: NVIDIA Corporation GK107M [GeForce GT 750M Mac Edition]
    0000:01:00.1 Audio device: NVIDIA Corporation GK107 HDMI Audio Controller
    0000:00:01.1 PCI bridge: Intel Corporation Crystal Well PCI Express x8 Controller
    0000:06:00.0 PCI bridge: Intel Corporation DSL5520 Thunderbolt [Falcon Ridge]
    0000:07:00.0 PCI bridge: Intel Corporation DSL5520 Thunderbolt [Falcon Ridge]
    0000:08:00.0 System peripheral: Intel Corporation DSL5520 Thunderbolt [Falcon Ridge]
    0000:07:03.0 PCI bridge: Intel Corporation DSL5520 Thunderbolt [Falcon Ridge]
    0000:07:04.0 PCI bridge: Intel Corporation DSL5520 Thunderbolt [Falcon Ridge]
    0000:07:05.0 PCI bridge: Intel Corporation DSL5520 Thunderbolt [Falcon Ridge]
    0000:07:06.0 PCI bridge: Intel Corporation DSL5520 Thunderbolt [Falcon Ridge]
    0000:00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family USB xHCI
    0000:00:16.0 Communication controller: Intel Corporation 8 Series/C220 Series Chipset Family MEI Controller
    0000:00:1b.0 Audio device: Intel Corporation 8 Series/C220 Series Chipset High Definition Audio Controller
    0000:00:1c.0 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port
    0000:00:1c.2 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port
    0000:03:00.0 Network controller: Broadcom Corporation BCM4360 802.11ac Wireless Network Adapter
    0000:00:1c.3 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port
    0000:04:00.0 Multimedia controller: Broadcom Corporation 720p FaceTime HD Camera
    0000:00:1c.4 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port
    0000:05:00.0 SATA controller: Samsung Electronics Co Ltd Apple PCIe SSD
    0000:00:1f.0 ISA bridge: Intel Corporation HM87 Express LPC Controller
    0000:00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family SMBus Controller

### UdevExample
sets up and monitors hidraw devices, ported from the C code at [http://www.signal11.us/oss/udev/udev_example.c](http://www.signal11.us/oss/udev/udev_example.c)
