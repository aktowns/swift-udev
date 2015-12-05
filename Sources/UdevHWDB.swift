import CUdev

public class UdevHWDB {
  public enum HWDBKey: String {
    case Model        = "ID_MODEL_FROM_DATABASE"
    case Vendor       = "ID_VENDOR_FROM_DATABASE"
    case PCIClass     = "ID_PCI_CLASS_FROM_DATABASE"
    case PCISubclass  = "ID_PCI_SUBCLASS_FROM_DATABASE"
    case PCIInterface = "ID_PCI_INTERFACE_FROM_DATABASE"
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

  public func properties(forModAlias modalias: String, andFlags flags: UInt32 = 0) -> [String: String] {
    var kvpairs = [String: String]()

    var currentEntry: COpaquePointer = udev_hwdb_get_properties_list_entry(self.handle, modalias, flags)

    while currentEntry != nil {
      let name = String.fromCString(udev_list_entry_get_name(currentEntry))
      let value = String.fromCString(udev_list_entry_get_value(currentEntry))

      if name != nil && value != nil {
        kvpairs[name!] = value!
      }

      currentEntry = udev_list_entry_get_next(currentEntry)
    }

    return kvpairs
  }
}
