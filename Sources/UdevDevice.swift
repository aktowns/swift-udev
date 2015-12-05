import CUdev

public class UdevDevice {
  public typealias RawUdevDeviceHandle = COpaquePointer

  private let device: RawUdevDeviceHandle

  var handle: RawUdevDeviceHandle {
    return self.device
  }

  init?(handle: RawUdevDeviceHandle) {
    if handle == nil {
      return nil
    }

    self.device = handle
  }

  deinit {
    udev_device_unref(self.device)
  }

  public static func from(udev: Udev, syspath path: String) -> UdevDevice? {
    let handle = udev_device_new_from_syspath(udev.handle, path)
    return UdevDevice(handle: handle)
  }

  public static func from(udev: Udev, type: DeviceType, devnum: DeviceNumber) -> UdevDevice? {
    let handle = udev_device_new_from_devnum(udev.handle, type.rawValue, devnum)
    return UdevDevice(handle: handle)
  }

  public static func from(udev: Udev, subsystem: String, sysname: String) -> UdevDevice? {
    let handle = udev_device_new_from_subsystem_sysname(udev.handle, subsystem, sysname)
    return UdevDevice(handle: handle)
  }

  public static func from(udev: Udev, deviceId: String) -> UdevDevice? {
    let handle = udev_device_new_from_device_id(udev.handle, deviceId)
    return UdevDevice(handle: handle)
  }

  func hasTag(tag: String) -> Bool {
    let hastag = udev_device_has_tag(self.device, tag)
    return (hastag == 1)
  }

  func property(key: String) -> String? {
    let maybeValue = udev_device_get_property_value(self.device, key)
    return String.fromCString(maybeValue)
  }

  func sysattr(sysattr: String) -> String? {
    let maybeValue = udev_device_get_sysattr_value(self.device, sysattr)
    return String.fromCString(maybeValue)
  }

  func parent(withSubsystem subsystem: String, andDevtype devtype: String) -> UdevDevice? {
    let devHandle = udev_device_get_parent_with_subsystem_devtype(self.device, subsystem, devtype)
    return UdevDevice(handle: devHandle)
  }

  var devnum: DeviceNumber {
    return udev_device_get_devnum(self.device)
  }

  var initialized: Bool {
    let initialized = udev_device_get_is_initialized(self.device)
    return (initialized == 1)
  }

  var action: String? {
    return udevDeviceMethodToString(udev_device_get_action)
  }

  var driver: String? {
    return udevDeviceMethodToString(udev_device_get_driver)
  }

  var deviceLinks: Array<UdevDevice>? {
    // TODO: struct udev_list_entry *udev_device_get_devlinks_list_entry(struct udev_device *udev_device);
    return Optional.None
  }

  var devnode: String? {
    return udevDeviceMethodToString(udev_device_get_devnode)
  }

  var devpath: String? {
    return udevDeviceMethodToString(udev_device_get_devpath)
  }

  var devtype: String? {
    return udevDeviceMethodToString(udev_device_get_devtype)
  }

  var sysnum: String? {
    return udevDeviceMethodToString(udev_device_get_sysnum)
  }

  var sysname: String? {
    return udevDeviceMethodToString(udev_device_get_sysname)
  }

  var subsystem: String? {
    return udevDeviceMethodToString(udev_device_get_subsystem)
  }

  var syspath: String? {
    return udevDeviceMethodToString(udev_device_get_syspath)
  }

  private func udevDeviceMethodToString(f: (RawUdevDeviceHandle) -> UnsafePointer<Int8>) -> String? {
    let val = f(self.device)
    return String.fromCString(val)
  }
}
