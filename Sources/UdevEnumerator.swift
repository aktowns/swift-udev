import CUdev

public class UdevEnumerator : SequenceType {
  private let handle: COpaquePointer
  private let udev: Udev

  init(udev: Udev, subsystem: String) {
    self.udev = udev
    self.handle = udev_enumerate_new(udev.handle)
    udev_enumerate_add_match_subsystem(self.handle, subsystem)
    udev_enumerate_scan_devices(self.handle)
  }

  public func generate() -> AnyGenerator<UdevDevice> {
    var currentDevice: Optional<COpaquePointer> = wrapCFunc(udev_enumerate_get_list_entry)(self.handle)

    return AnyGenerator {
      let newDev = currentDevice
                      .flatMap(self.listEntryGetName)
                      .map(self.udev.deviceFrom)

      currentDevice = currentDevice.flatMap(self.wrapCFunc(udev_list_entry_get_next))

      return newDev
    }
  }

  private func listEntryGetName(ptr: COpaquePointer) -> Optional<String> {
    let str = udev_list_entry_get_name(ptr)
    return String.fromCString(str)
  }

  private func wrapCFunc(f: (COpaquePointer) -> COpaquePointer) -> ((COpaquePointer) -> Optional<COpaquePointer>) {
    func inner(p: COpaquePointer) -> Optional<COpaquePointer> {
      let val = f(p)
      if val != nil {
        return Optional.Some(val)
      } else {
        return Optional.None
      }
    }
    return inner
  }
}
