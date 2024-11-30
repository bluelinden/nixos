{ config, pkgs, lib, username, ... }:

{
  # ...

  xdg.dataFile = let
    node18Version = "node-v18.15.0-linux-x64";
    node22Version = "node-v22.5.1-linux-x64";
    node18Package = pkgs.nodejs_18;
    node22Package = pkgs.nodejs_22;
  in {
    # Adding different directories one by one, as Zed wants to write to the "./cache" dir
    "zed/node/${node18Version}/bin".source = "${node18Package}/bin";
    "zed/node/${node18Version}/include".source = "${node18Package}/include";
    "zed/node/${node18Version}/lib".source = "${node18Package}/lib";
    "zed/node/${node18Version}/share".source = "${node18Package}/share";
    "zed/node/${node22Version}/bin".source = "${node22Package}/bin";
    "zed/node/${node22Version}/include".source = "${node22Package}/include";
    "zed/node/${node22Version}/lib".source = "${node22Package}/lib";
    "zed/node/${node22Version}/share".source = "${node22Package}/share";
  };

  # ...
}
