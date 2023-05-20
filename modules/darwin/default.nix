{pkgs, ...}: {
  imports = [
    ../common.nix
    #    ./gpg.nix
  ];

  environment = {
    loginShell = pkgs.fish;
  };

  services.nix-daemon.enable = true;

  programs.fish = {
    enable = true;
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;

    loginShellInit = ''for p in (string split " " $NIX_PROFILES); fish_add_path --prepend --move $p/bin; end'';
  };
}
