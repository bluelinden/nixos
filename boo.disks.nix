{ disks ? ["/dev/nvme0n1"], ... }: {
  disko.devices = {
  	disk = {
  	  nvme0n1 = {
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
  	  	  	boocrypt = {
  	  	  	  size = "100%";
  	  	  	  content = {
  	  	  	    type = "luks";
  	  	  	    name = "boocrypt";
  	  	  	    extraOpenArgs = [
  	  	  	      "--allow-discards"
  	  	  	      "--perf-no_read_workqueue"
  	  	  	      "--perf-no_write_workqueue"
  	  	  	    ];
  	  	  	    settings = { crypttabExtraOpts = [ "tpm2-device=auto" "discard" ]; };
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
    	  	  	  	  "/userdata" = {
  	  	  	  	  	  name = "user";
  	  	  	  	    	mountpoint = "/userdata";
  	  	  	  	    	mountOptions = ["noatime" "compress=zstd"];
  	  	  	    	  };
                    "/sysdata" = {
  	  	  	  	  	  name = "system";
  	  	  	  	    	mountpoint = "/sysdata";
  	  	  	  	    	mountOptions = ["noatime" "compress=zstd"];
  	  	  	    	  };
  	  	  	    	  "/swap" = {
  	  	    	  	  	name = "swap";
  	  	    	  	  	mountpoint = "/swap";
  	    	  	  	  	mountOptions = ["noatime" "compress=zstd"];
  	    	  	  	    swap.swapfile = {
    	  	  	  	      size = "34G";
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
  };
}
