{
  pkgs,
  lib,
  ...
}:
with lib;
  mkIf pkgs.stdenvNoCC.isLinux {
    systemd.user = {
      # Auto start all of the services
      startServices = "sd-switch";
    };
  }
