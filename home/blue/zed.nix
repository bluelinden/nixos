{ config, pkgs, lib, username, ... }:

{
  # ...

  xdg.dataFile = let
    nodeVersion = "node-v18.15.0-linux-x64";
    nodePackage = pkgs.nodejs_18;
  in {
    # Adding different directories one by one, as Zed wants to write to the "./cache" dir
    "zed/node/${nodeVersion}/bin".source = "${nodePackage}/bin";
    "zed/node/${nodeVersion}/include".source = "${nodePackage}/include";
    "zed/node/${nodeVersion}/lib".source = "${nodePackage}/lib";
    "zed/node/${nodeVersion}/share".source = "${nodePackage}/share";
  };

  # ...
}