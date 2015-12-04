# Udev

work in progress wrapper over [libudev](http://www.freedesktop.org/software/systemd/man/libudev.html) for swift.   
learning as i go, give me a yell if things are terribly wrong!

```swift
let udev = Udev()
let device = udev.deviceFrom("/sys/devices/pci0000:00/0000:00:01.0")
print(device.subsystem) // => Optional("pci")
print(device.driver)    // => Optional("pcieport")
// ..

let enumerator = UdevEnumerator(udev: udev, subsystem: "hidraw")
for device in enumerator {
  print("syspath=", terminator: "")
  print(device.syspath)
}

// =>
// syspath=Optional("/sys/devices/pci0000:00/0000:00:14.0/usb1/1-12/1-12:1.0/0003:05AC:0262.0001/hidraw/hidraw0")
// syspath=Optional("/sys/devices/pci0000:00/0000:00:14.0/usb1/1-12/1-12:1.1/0003:05AC:0262.0002/hidraw/hidraw1")
```
