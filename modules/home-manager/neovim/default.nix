{pkgs, ...}: let
  inherit (builtins) readFile;

  readVimSection = file: readFile (./. + "/${file}.vim");
  pluginWithCfg = plugin: {
    inherit plugin;
    type = "viml";
    config = readVimSection "plugins/${plugin.pname}";
  };

  # For plugins configured with lua
  readLuaSection = file: readFile (./. + "/${file}.lua");
  pluginWithLua = plugin: {
    inherit plugin;
    type = "lua";
    config = readLuaSection "plugins/${plugin.pname}";
  };
in {
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      # Editor
      sensible # Sensible defaults
      repeat # Repeatable plugin actions
      # surround

      # Theme
      # catpuccin-nvim

      # Utilities
      plenary-nvim

      # Languages
      vim-nix # nix

      ## nav
      (pluginWithLua leap-nvim)

      ## git
      # neogit
    ];
  };
}
