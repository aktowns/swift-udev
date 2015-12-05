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

  public func deviceFrom(syspath: String) -> UdevDevice {
    return UdevDevice(udev: self, syspath: syspath)
  }

  public func deviceFrom(type: DeviceType, devnum: DeviceNumber) -> UdevDevice {
    return UdevDevice(udev: self, type: type, devnum: devnum)
  }

  public func deviceFrom(subsystem: String, sysname: String) -> UdevDevice {
    return UdevDevice(udev: self, subsystem: subsystem, sysname: sysname)
  }

  public func deviceFromId(deviceId: String) -> UdevDevice {
    return UdevDevice(udev: self, deviceId: deviceId)
  }
}
