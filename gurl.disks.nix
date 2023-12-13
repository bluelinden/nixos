{ disks ? ["/dev/sda"], ... }: {
  disko.devices = {
  	disk = {
  	  sda = {
  	  	device = builtins.elemAt disks 0;
  	  	type = "disk";
  	  	content = {
  	  	  type = "gpt";
  	  	  partitions = {
  	  	  	EFI = {
  	  	  	  priority = 1;
  	  	  	  name = "ESP";
  	  	  	  start = "1M";
  	  	  	  end = "5000M";
  	  	  	  type = "EF00";
  	  	  	  content = {
  	  	  	  	type = "filesystem";
  	  	  	  	format = "vfat";
  	  	  	  	mountpoint = "/boot";
  	  	  	  };
  	  	  	  
  	  	  	};
  	  	  	gurl = {
  	  	  	  size = "100%";
  	  	  	  content = {
  	  	  	  	type = "btrfs";
  	  	  	  	extraArgs = [ "-f" ];
  	  	  	  	subvolumes = {
  	  	  	  	  "/store" = {
  	  	  	  	    name = "store";
  	  	  	  	    mountpoint = "/nix";
  	  	  	  	    mountOptions = ["noatime" "compress=zstd"];
  	  	  	  	  };
  	  	  	  	  "/home" = {
  	  	  	  	    name = "home";
  	  	  	  	    mountpoint = "/home";
  	  	  	  	    mountOptions = ["noatime" "compress=zstd"];
  	  	  	  	  };
  	  	  	  	  "/config" = {
  	  	  	  	  	name = "config";
  	  	  	  	  	mountpoint = "/cfg";
  	  	  	  	  	mountOptions = ["noatime" "compress=zstd"];
  	  	  	  	  };
  	  	  	  	  "/root" = {
  	  	  	  	  	name = "root";
  	  	  	  	  	mountpoint = "/";
  	  	  	  	  	mountOptions = ["noatime" "compress=zstd"];
  	  	  	  	  };
  	  	  	  	  "/swap" = {
  	  	  	  	  	name = "swap";
  	  	  	  	  	mountpoint = "/swap";
  	  	  	  	  	mountOptions = ["noatime" "compress=zstd"];
  	  	  	  	    swap.swapfile = {
  	  	  	  	      size = "20G";
  	  	  	  	      path = "swapfile";
  	  	  	  	    };
  	  	  	  	  };
  	  	  	  	};
  	  	  	  };
  	  	  	};
  	  	  };
  	  	};
  	  };
  	};
  };
}
