{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs
  ];

  programs.vscode.enable = true;
}
