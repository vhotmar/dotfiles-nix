{ pkgs, config, ... }:
let
  dotfilesAsStorePath = config.lib.file.mkOutOfStoreSymlink config.home.mutableFile."dotfiles".path;
  getDotfiles = path: "${dotfilesAsStorePath}/${path}";
in {
  xdg.configFile = {
    "spacemacs".source = getDotfiles "spacemacs";
  };

  home.mutableFile."dotfiles" = {
    url = "git+ssh://git@github.com/vhotmar/dotfiles";
    type = "git";
  };
}
