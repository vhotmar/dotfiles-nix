{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  isLinux = pkgs.stdenvNoCC.isLinux;
  isDarwin = pkgs.stdenvNoCC.isDarwin;
  cfg = config.services.gpg-agent;
  gpgPkg = config.programs.gpg.package;
  homedir = config.programs.gpg.homedir;

  gpgSshSupportStr = ''
    ${gpgPkg}/bin/gpg-connect-agent updatestartuptty /bye > /dev/null
  '';

  gpgInitStr =
    ''
      GPG_TTY="$(tty)"
      export GPG_TTY
    ''
    + optionalString cfg.enableSshSupport gpgSshSupportStr;

  gpgFishInitStr =
    ''
      set -gx GPG_TTY (tty)
    ''
    + optionalString cfg.enableSshSupport gpgSshSupportStr;
in (mkMerge [
  {
    home.packages = with pkgs; [
      pinentry-curses
    ];

    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enableSshSupport = true;
      pinentryFlavor = "tty";
      sshKeys = ["F78B495E0E1223652DDDDAE7E8334CF77214C5E7"];
    };
  }

  # On linux just enable the GPG agent
  (mkIf isLinux {
    services.gpg-agent.enable = true;
  })

  # On Max we have to do most of the work manually (but it is just copied from home-manager)
  (mkIf isDarwin (mkMerge [
    {
      home.file."${homedir}/gpg-agent.conf".text =
        concatStringsSep "\n"
        (optional (cfg.enableSshSupport) "enable-ssh-support"
          ++ optional cfg.grabKeyboardAndMouse "grab"
          ++ optional (!cfg.enableScDaemon) "disable-scdaemon"
          ++ optional (cfg.defaultCacheTtl != null)
          "default-cache-ttl ${toString cfg.defaultCacheTtl}"
          ++ optional (cfg.defaultCacheTtlSsh != null)
          "default-cache-ttl-ssh ${toString cfg.defaultCacheTtlSsh}"
          ++ optional (cfg.maxCacheTtl != null)
          "max-cache-ttl ${toString cfg.maxCacheTtl}"
          ++ optional (cfg.maxCacheTtlSsh != null)
          "max-cache-ttl-ssh ${toString cfg.maxCacheTtlSsh}"
          ++ optional (cfg.pinentryFlavor != null)
          "pinentry-program ${pkgs.pinentry.${cfg.pinentryFlavor}}/bin/pinentry"
          ++ [cfg.extraConfig]);

      home.sessionVariablesExtra = optionalString cfg.enableSshSupport ''
        export SSH_AUTH_SOCK="$(${gpgPkg}/bin/gpgconf --list-dirs agent-ssh-socket)"
      '';

      programs.bash.initExtra = mkIf cfg.enableBashIntegration gpgInitStr;
      programs.zsh.initExtra = mkIf cfg.enableZshIntegration gpgInitStr;
      programs.fish.interactiveShellInit =
        mkIf cfg.enableFishIntegration gpgFishInitStr;
    }

    (mkIf (cfg.sshKeys != null) {
      # Trailing newlines are important
      home.file."${homedir}/sshcontrol".text =
        concatMapStrings (s: ''
          ${s}
        '')
        cfg.sshKeys;
    })
  ]))
])
