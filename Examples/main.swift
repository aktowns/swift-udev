import Glibc

let udev = Udev()
let device = udev.device(fromSyspath: "/sys/devices/pci0000:00/0000:00:01.0")!
// let device = udev.device(fromId: "0x8c31")

print("devnum=", terminator:"")
print(device.devnum)
print("initialized=", terminator:"")
print(device.initialized)
print("action=", terminator:"")
print(device.action)
print("driver=", terminator:"")
print(device.driver)
print("deviceLinks=", terminator:"")
print(device.deviceLinks)
print("devnode=", terminator:"")
print(device.devnode)
print("devpath=", terminator:"")
print(device.devpath)
print("devtype=", terminator:"")
print(device.devtype)
print("sysnum=", terminator:"")
print(device.sysnum)
print("syspath=", terminator:"")
print(device.syspath)
print("sysname=", terminator:"")
print(device.sysname)
print("subsystem=", terminator:"")
print(device.subsystem)
print("property(PCI_ID)=", terminator:"")
print(device.property("PCI_ID"))
print("property(PCI_SUBSYS_ID)=", terminator:"")
print(device.property("PCI_SUBSYS_ID"))
print("sysattr(subsystem_device)=", terminator:"")
print(device.sysattr("subsystem_device"))
print("sysattr(subsystem_vendor)=", terminator:"")
print(device.sysattr("subsystem_vendor"))

let enumerate = udev.enumerate(fromSubsystem: "hidraw")!

for device in enumerate {
  print("syspath=", terminator: "")
  print(device.syspath)
}
