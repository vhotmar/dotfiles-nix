{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.lib.dag) entryAfter;

  passwordStorePath = config.services.pass-secret-service.storePath;
in {
  programs.password-store = {
    enable = true;
  };

  # services.password-store-sync = {
  #   enable = true;
  # };

  # home.activation.ensurePasswordStore = entryAfter ["reloadSystemd"] ''
  #   if [[ ! -d "${passwordStorePath}" ]]; then
  #     PATH=${lib.makeBinPath (with pkgs; [gnupg])} $DRY_RUN_CMD gpg-connect-agent updatestartuptty /bye
  #     PATH=${lib.makeBinPath (with pkgs; [gnupg git openssh])} \
  #       SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)" \
  #       $DRY_RUN_CMD git clone ${passwordStoreRemoteUrl} ${passwordStorePath}
  #   fi
  # '';


  home.mutableFile."password-store" = {
    url = "git+ssh://git@github.com/vhotmar/dotfiles-pass.git";
    type = "git";
  };

  # services.git-sync = {
  #   repositories = {
  #     password-store = {
  #       path = config.services.pass-secret-service.storePath;
  #       uri = "git+ssh://git@github.com:vhotmar/dotfiles-pass.git";
  #     };
  #   };
  # };
}
