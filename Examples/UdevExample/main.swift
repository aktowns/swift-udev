/*
 libudev example.

 This example prints out properties of each of the hidraw devices. It then creates a monitor
 which will report when hidraw devices are connected or removed from the system.

 This code is meant to be a teaching resource. It can be used for anyone for any reason,
 including embedding into a commercial product.

 The document describing this file, and updated versions can be found at:
 http://www.signal11.us/oss/udev/

 Alan Ott
 Signal 11 Software
 2010-05-22 - Initial Revision
 2010-05-27 - Monitoring initializaion
              moved to before enumeration.
 2015-12-05 - Ported to swift by Ashley Towns <mail@ashleytowns.id.au>
*/

import Glibc
import Udev

let udev = Udev()

/*
  This section sets up a monitor which will report events when devices attached to the system
  change.  Events include "add", "remove", "change", "online", and "offline".

  This section sets up and starts the monitoring. Events are polled for (and delivered) later
  in the file.

  It is important that the monitor be set up before the call to udev_enumerate_scan_devices()
  so that events (and devices) are not missed.  For example, if enumeration happened first,
  there would be no event generated for a device which was attached after enumeration but
  before monitoring began.

  Note that a filter is added so that we only get events for "hidraw" devices.
*/
guard let mon = udev.monitor(fromNetlink: .Udev) else {
  print("Unable to setup monitor")
  exit(-1)
}

mon.addFilter(bySubsystem: .HIDRaw)
mon.enableReceiving()

guard let enumerate = udev.enumerate() else {
  print("Unable to setup device enumerator")
  exit(-1)
}

enumerate.addMatch(withSubsystem: .HIDRaw)
enumerate.scan()

for device in enumerate {
  // device.devnode returns the path to the device node itself in /dev.
  print("Device Node Path: \(device.devnode)")
  /*
    The device pointed to by dev contains information about the hidraw device. In order to get
    information about the USB device, get the parent device with the subsystem/devtype pair of
    "usb"/"usb_device". This will be several levels up the tree, but the function will find it.
  */
  guard let dev = device.parent(withSubsystem: .USB, andDevtype: .USBDevice) else {
    print("Unable to find parent usb device.")
    exit(-1)
  }

  /*
    From here, we can call sysattr() for each file in the device's /sys entry. The strings passed
    into these functions (idProduct, idVendor, serial, etc.) correspond directly to the files in
    the /sys directory which represents the USB device. Note that USB strings are Unicode, UCS2
    encoded, but the strings returned from device.sysattr() are UTF-8 encoded.
  */
  print("  VID/PID: \(dev.sysattr("idVendor")) \(dev.sysattr("idProduct"))")
  print("  \(dev.sysattr("manufacturer"))")
  print("  \(dev.sysattr("product"))")
  print("  serial: \(dev.sysattr("serial"))")
}

/*
  Begin polling for udev events. Events occur when devices attached to the system are added,
  removed, or change state. mon.receive_device() will return a device object representing the
  device which changed and what type of change occured.

  The select() system call is used to ensure that the call to mon.receive_device() will not block.

  The monitor was set up earler in this file, and monitoring is already underway.
*/
mon.receiveDevices() { device in
  print("Got Device");
  print("   Node: \(device.devnode)")
  print("   Subsystem: \(device.subsystem)")
  print("   Devtype: \(device.devtype)")
  print("   Action: \(device.action)")

  return true // keep looping
}
