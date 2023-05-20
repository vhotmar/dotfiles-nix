{pkgs, ...}: {
  home.packages = with pkgs; [
    exa
  ];

  programs.fish.shellAbbrs = {
    l = "exa -al";
    ls = "exa -l";
    la = "exa -al";
    ll = "exa -l";
    lL = "exa -algiSH --git";
    lt = "exa -lT";
  };
}
