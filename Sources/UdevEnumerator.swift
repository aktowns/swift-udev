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
    var currentDevice: COpaquePointer = nil

    return AnyGenerator {
      if currentDevice == nil {
        currentDevice = udev_enumerate_get_list_entry(self.handle)
      } else {
        currentDevice = udev_list_entry_get_next(currentDevice)
      }

      if currentDevice == nil {
        return nil
      } else {
        let rawDevName = udev_list_entry_get_name(currentDevice)
        let devPath = String.fromCString(rawDevName)

        if devPath != nil {
          return self.udev.deviceFrom(devPath!)
        } else {
          return nil
        }
      }
    }
  }
}
