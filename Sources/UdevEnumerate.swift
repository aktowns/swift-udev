import CUdev

public class UdevEnumerate : SequenceType {
  private let handle: COpaquePointer
  private let udev: Udev

  init?(udev: Udev, handle: COpaquePointer) {
    if handle == nil {
      return nil
    }

    self.udev = udev
    self.handle = handle
  }

  deinit {
    udev_enumerate_unref(self.handle)
  }

  public static func from(udev: Udev, subsystem: String) -> UdevEnumerate? {
    let handle = udev_enumerate_new(udev.handle)
    return UdevEnumerate(udev: udev, handle: handle)
  }

  public func addMatch(subsystem: String) -> Void {
    udev_enumerate_add_match_subsystem(self.handle, subsystem)
  }

  public func scan() -> Void {
    udev_enumerate_scan_devices(self.handle)
  }

  public func generate() -> AnyGenerator<UdevDevice> {
    var currentDevice: COpaquePointer? = udev_enumerate_get_list_entry(self.handle)

    return AnyGenerator {
      let newDev = currentDevice
                      .flatMap(self.listEntryGetName)
                      .flatMap{self.udev.device(fromSyspath: $0)}

      currentDevice = currentDevice.flatMap(udev_list_entry_get_next)

      return newDev
    }
  }

  private func listEntryGetName(ptr: COpaquePointer) -> String? {
    let str = udev_list_entry_get_name(ptr)
    return String.fromCString(str)
  }
}
