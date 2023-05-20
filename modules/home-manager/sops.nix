{config, ...}: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    gnupg = {
      home = config.programs.gpg.homedir;
      sshKeyPaths = [];
    };
  };
}
