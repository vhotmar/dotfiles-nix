{
  pkgs,
  config,
  inputs,
  ...
}: let
  homeDirectory = "${
    if pkgs.stdenvNoCC.isDarwin
    then "/Users"
    else "/home"
  }/${config.user.name}";
in {
  imports = [
    ./primaryUser.nix
  ];

  programs.fish = {
    enable = true;
  };

  user = {
    description = "Vojtech Hotmar";
    home = homeDirectory;
    shell = pkgs.fish;
  };

  hm = {
    imports = [
      ./home-manager
    ];

    home = {
      inherit homeDirectory;
    };
  };

  home-manager = {
    # useUserPackages = true;
    backupFileExtension = "backup";
  };

  environment = {
    etc = {
      # home-manager.source = "${inputs.home-manager}";
      # nixpkgs.source = "${inputs.nixpkgs}";
    };

    shells = with pkgs; [bash zsh fish];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [jetbrains-mono];
  };
}
