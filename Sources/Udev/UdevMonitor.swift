import Glibc
import CUdev

public class UdevMonitor {
  private let handle: COpaquePointer

  init?(withUdev: Udev, andHandle handle: COpaquePointer) {
    self.handle = handle
  }

  public static func from(udev: Udev, netlink: Netlink) -> UdevMonitor? {
    let handle = udev_monitor_new_from_netlink(udev.handle, netlink.rawValue)
    return UdevMonitor(withUdev: udev, andHandle: handle)
  }

  public func addFilter(bySubsystem subsystem: Subsystem, devtype: DeviceType? = nil) -> Void {
    if devtype != nil {
      udev_monitor_filter_add_match_subsystem_devtype(self.handle, subsystem.rawValue, devtype!.rawValue)
    } else {
      udev_monitor_filter_add_match_subsystem_devtype(self.handle, subsystem.rawValue, nil)
    }
  }

  public func enableReceiving() -> Void {
    udev_monitor_enable_receiving(self.handle)
  }

  public func receiveDevice() -> UdevDevice? {
    let dev = udev_monitor_receive_device(self.handle)
    return UdevDevice(handle: dev)
  }

  public func receiveDevices(f: (UdevDevice) -> Bool) -> Void {
    while true {
      if let dev = receiveDevice() {
        if f(dev) == false {
          break
        }
      }

      sleep(1)
    }
  }
}
