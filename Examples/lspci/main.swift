import Glibc
import Udev

let udev = Udev()

guard let enumerate = udev.enumerate() else {
  print("Unable to setup device enumerator")
  exit(-1)
}

enumerate.addMatch(withSubsystem: .PCI)
enumerate.scan()

for device in enumerate {
  let modalias = device.sysattr("modalias")

  let hwinfo = udev.hwdb(forModAlias: modalias!)

  let subclass = hwinfo[UdevHWDB.Key.PCISubclass]!
  let vendor = hwinfo[UdevHWDB.Key.Vendor]!
  let model = hwinfo[UdevHWDB.Key.Model]!
  print("\(device.sysname!) \(subclass): \(vendor) \(model)")
}
