{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.gpg-agent;
  homedir = config.programs.gpg.homedir;
in {
  hm = {
    home.file."${homedir}/gpg-agent.conf".text = ''
      enable-ssh-support
      pinentry-program ${pkgs.pinentry.curses}/bin/pinentry"
    '';

    home.file."${homedir}/sshcontrol".text =
      concatMapStrings (s: ''
        ${s}
      '')
      cfg.sshKeys;
  };

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
