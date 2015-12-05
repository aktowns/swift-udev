import CUdev

public enum DeviceType: Int8 {
  case Char = 0
  case Block = 1
}

public typealias DeviceNumber = CUnsignedLong

public class Udev {
  public typealias RawUdevHandle = COpaquePointer
  private let udev: RawUdevHandle

  var handle: RawUdevHandle {
    return self.udev
  }

  init() {
    self.udev = udev_new()
  }

  deinit {
    udev_unref(self.udev)
  }

  public func device(fromSyspath path: String) -> UdevDevice? {
    return UdevDevice.from(self, syspath: path)
  }

  public func device(fromType type: DeviceType, andDevnum devnum: DeviceNumber) -> UdevDevice? {
    return UdevDevice.from(self, type: type, devnum: devnum)
  }

  public func device(fromSubsystem subsystem: String, andSysname sysname: String) -> UdevDevice? {
    return UdevDevice.from(self, subsystem: subsystem, sysname: sysname)
  }

  public func device(fromId deviceId: String) -> UdevDevice? {
    return UdevDevice.from(self, deviceId: deviceId)
  }

  public func enumerate(fromSubsystem subsystem: String) -> UdevEnumerate? {
    return UdevEnumerate.from(self, subsystem: subsystem)
  }

  public func monitor(fromNetlink netlink: String) -> UdevMonitor? {
    return UdevMonitor.from(self, netlink: netlink)
  }
}
