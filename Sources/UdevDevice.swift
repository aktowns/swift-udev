import CUdev

public class UdevDevice {
  public typealias RawUdevDeviceHandle = COpaquePointer

  private let device: RawUdevDeviceHandle

  var handle: RawUdevDeviceHandle {
    return self.device
  }

  init(udev: Udev, syspath: String) {
    self.device = udev_device_new_from_syspath(udev.handle, syspath)
  }

  init(udev: Udev, type: DeviceType, devnum: DeviceNumber) {
    self.device = udev_device_new_from_devnum(udev.handle, type.rawValue, devnum)
  }

  init(udev: Udev, subsystem: String, sysname: String) {
    self.device = udev_device_new_from_subsystem_sysname(udev.handle, subsystem, sysname)
  }

  init(udev: Udev, deviceId: String) {
    self.device = udev_device_new_from_device_id(udev.handle, deviceId)
  }

  func hasTag(tag: String) -> Bool {
    let hastag = udev_device_has_tag(self.device, tag)
    return (hastag == 1)
  }

  func property(key: String) -> Optional<String> {
    let maybeValue = udev_device_get_property_value(self.device, key)
    return String.fromCString(maybeValue)
  }

  func sysattr(sysattr: String) -> Optional<String> {
    let maybeValue = udev_device_get_sysattr_value(self.device, sysattr)
    return String.fromCString(maybeValue)
  }

  var devnum: DeviceNumber {
    return udev_device_get_devnum(self.device)
  }

  var initialized: Bool {
    let initialized = udev_device_get_is_initialized(self.device)
    return (initialized == 1)
  }

  var action: Optional<String> {
    return udevDeviceMethodToString(udev_device_get_action)
  }

  var driver: Optional<String> {
    return udevDeviceMethodToString(udev_device_get_driver)
  }

  var deviceLinks: Optional<Array<UdevDevice>> {
    // TODO: struct udev_list_entry *udev_device_get_devlinks_list_entry(struct udev_device *udev_device);
    return Optional.None
  }
  var devnode: Optional<String> {
    return udevDeviceMethodToString(udev_device_get_devnode)
  }

  var devpath: Optional<String> {
    return udevDeviceMethodToString(udev_device_get_devpath)
  }

  var devtype: Optional<String> {
    return udevDeviceMethodToString(udev_device_get_devtype)
  }

  var sysnum: Optional<String> {
    return udevDeviceMethodToString(udev_device_get_sysnum)
  }

  var sysname: Optional<String> {
    return udevDeviceMethodToString(udev_device_get_sysname)
  }

  var subsystem: Optional<String> {
    return udevDeviceMethodToString(udev_device_get_subsystem)
  }

  var syspath: Optional<String> {
    return udevDeviceMethodToString(udev_device_get_syspath)
  }

  private func udevDeviceMethodToString(f: (RawUdevDeviceHandle) -> UnsafePointer<Int8>) -> Optional<String> {
    let val = f(self.device)
    return String.fromCString(val)
  }
}
