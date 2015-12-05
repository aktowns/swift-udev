import CUdev

public class UdevHWDB {
  public enum Key: String {
    case Model        = "ID_MODEL_FROM_DATABASE"
    case Vendor       = "ID_VENDOR_FROM_DATABASE"
    case PCIClass     = "ID_PCI_CLASS_FROM_DATABASE"
    case PCISubclass  = "ID_PCI_SUBCLASS_FROM_DATABASE"
    case PCIInterface = "ID_PCI_INTERFACE_FROM_DATABASE"
    case USBClass     = "ID_USB_CLASS_FROM_DATABASE"
    case USBProtocol  = "ID_USB_PROTOCOL_FROM_DATABASE"
  }

  let handle: COpaquePointer

  init?(udev: Udev) {
    self.handle = udev_hwdb_new(udev.handle)

    if handle == nil {
      return nil
    }
  }

  deinit {
    udev_hwdb_unref(self.handle)
  }

  public func properties(forModAlias modalias: String, andFlags flags: UInt32 = 0) -> [Key: String] {
    var kvpairs = [Key: String]()

    var currentEntry: COpaquePointer = udev_hwdb_get_properties_list_entry(self.handle, modalias, flags)

    while currentEntry != nil {
      let name = String.fromCString(udev_list_entry_get_name(currentEntry))
      let value = String.fromCString(udev_list_entry_get_value(currentEntry))

      if name != nil && value != nil {
        guard let key = Key(rawValue: name!) else {
          print("Unknown key type \(name!)")
          return kvpairs
        }

        kvpairs[key] = value!
      }

      currentEntry = udev_list_entry_get_next(currentEntry)
    }

    return kvpairs
  }
}
