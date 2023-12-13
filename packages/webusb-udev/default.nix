{ pkgs }:

# for micro:bit

pkgs.writeTextFile {
  name = "webusb-rules";
  text = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", MODE="0664", GROUP="plugdev"
    '';
  destination = "/etc/udev/rules.d/50-webusb.rules";
}
