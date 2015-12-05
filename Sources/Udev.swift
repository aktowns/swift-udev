import CUdev

public enum DeviceNodeType: Int8 {
  case Char = 0
  case Block = 1
}

public enum Subsystem: String {
  case HIDRaw = "hidraw"
  case USB = "usb"
}

public enum DeviceType: String {
  case USBDevice = "usb_device"
}

public enum Netlink: String {
  case Udev = "udev"
}

public typealias DeviceNumber = CUnsignedLong

public class Udev {
  public typealias RawUdevHandle = COpaquePointer
  private let udev: RawUdevHandle

  var handle: RawUdevHandle {
    return self.udev
  }

  public init() {
    self.udev = udev_new()
  }

  deinit {
    udev_unref(self.udev)
  }

  public func device(fromSyspath path: String) -> UdevDevice? {
    return UdevDevice.from(self, syspath: path)
  }

  public func device(fromType type: DeviceNodeType, andDevnum devnum: DeviceNumber) -> UdevDevice? {
    return UdevDevice.from(self, type: type, devnum: devnum)
  }

  public func device(fromSubsystem subsystem: Subsystem, andSysname sysname: String) -> UdevDevice? {
    return UdevDevice.from(self, subsystem: subsystem, sysname: sysname)
  }

  public func device(fromId deviceId: String) -> UdevDevice? {
    return UdevDevice.from(self, deviceId: deviceId)
  }

  public func enumerate() -> UdevEnumerate? {
    return UdevEnumerate(udev: self)
  }

  public func monitor(fromNetlink netlink: Netlink) -> UdevMonitor? {
    return UdevMonitor.from(self, netlink: netlink)
  }

  public func hwdb(forModAlias modalias: String) -> [String: String] {
    guard let hwdb = UdevHWDB(udev: self) else {
      return [String: String]()
    }

    return hwdb.properties(forModAlias: modalias)
  }
}
