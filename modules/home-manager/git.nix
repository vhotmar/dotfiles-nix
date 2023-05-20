{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Vojtech Hotmar";
    userEmail = "vojtech.hotmar@gmail.com";

    aliases = {
      a = "add";
      d = "diff";
      dc = "diff --cached";
      s = "status --short";
      st = "status";
      co = "checkout";
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";
    };

    difftastic.enable = true;
  };
}
