import Glibc
import Udev

let udev = Udev()

guard let enumerate = udev.enumerate() else {
  print("Unable to setup device enumerator")
  exit(-1)
}

enumerate.addMatch(withSubsystem: .USB)
enumerate.scan()

for device in enumerate {
  let modalias = device.sysattr("modalias")

  if modalias != nil {
    let parent = device.parent(withSubsystem: .USB, andDevtype: .USBDevice)

    if parent != nil {
      let busNum = parent!.sysattr("busnum")!
      let devNum = parent!.sysattr("devnum")!
      print("Bus \(busNum) Device \(devNum): ", terminator: "")

      let vendorId = parent!.sysattr("idVendor")!
      let productId = parent!.sysattr("idProduct")!
      print("ID \(vendorId):\(productId) ", terminator:"")
    }

    let hwinfo = udev.hwdb(forModAlias: modalias!)

    let vendor = hwinfo[UdevHWDB.Key.Vendor] ?? ""
    let model = hwinfo[UdevHWDB.Key.Model] ?? ""
    print("\(vendor) \(model)")
  }
}
