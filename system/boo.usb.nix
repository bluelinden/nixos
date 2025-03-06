
{...}: {
  services.usbguard = {
    enable = true;
    dbus.enable = true;
    implicitPolicyTarget = "block";
    IPCAllowedGroups = [ "usbguard" ];
    rules = 
      ''
        allow id 1d6b:0002 serial "0000:00:14.0" name "xHCI Host Controller" with-interface 09:00:00 with-connect-type "" label "usb2"
        allow id 1d6b:0003 serial "0000:00:14.0" name "xHCI Host Controller" with-interface 09:00:00 with-connect-type "" label "usb3"
        allow id 1bcf:2b96 serial "" name "Integrated_Webcam_HD" via-port "1-5" with-interface { 0e:01:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 } with-connect-type "hardwired" label "webcam"
        allow id 8087:0032 serial "" name "" via-port "1-7" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "hardwired" label "bluetooth"
      '';
  };
}
