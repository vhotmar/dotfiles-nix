{ config, pkgs, ... }: {
  home.packages = with pkgs; [ emacs ];

  home.mutableFile."${config.xdg.configHome}/emacs" = {
    url = "https://github.com/syl20bnr/spacemacs";
    type = "git";
  };

  home.sessionVariables = {
    SPACEMACSDIR = "${config.xdg.configHome}/spacemacs";
  };
}
