{ pkgs, config, ... }: {
  imports = [
    ./bat.nix
    ./dotfiles.nix
    ./exa.nix
    ./emacs
    ./fish.nix
    ./fzf.nix
    ./git-sync.nix
    ./git.nix
    ./gpg.nix
    ./mosh.nix
    ./mutable-files.nix
    ./neovim
    ./pass.nix
    #./sops.nix
    ./system.nix
    ./systemd.nix
    ./tmux.nix
    ./vpn.nix
    ./vscode.nix
    ./work/dhl
  ];

  home = { stateVersion = "22.11"; };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfreePredicate = _: true;
}
