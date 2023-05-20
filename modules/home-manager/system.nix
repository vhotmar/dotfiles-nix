{pkgs, ...}: {
  home.packages = with pkgs; [
    nixfmt
    # Top utility
    btop

    # Search in files tool
    silver-searcher

    # Coloring
    grc

    # Unzip
    unzip
    wget
    mc
    tmux
    jq
    exa
  ];
}
