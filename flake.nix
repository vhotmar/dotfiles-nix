{
  description = "My dotfiles configuration";

  outputs = inputs @ {
    self,
    devshell,
    treefmt-nix,
    flake-parts,
    nixpkgs,
    darwin,
    home-manager,
    sops-nix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
      imports = [
        treefmt-nix.flakeModule
        devshell.flakeModule
      ];

      debug = true;

      systems = ["x86_64-linux" "x86_64-darwin"];

      flake = let
        inherit (nixpkgs.lib) mkMerge platforms;
        inherit (darwin.lib) darwinSystem;
        inherit (home-manager.lib) homeManagerConfiguration;

        isDarwin = system: (builtins.elem system platforms.darwin);
        homePrefix = system:
          if isDarwin system
          then "/Users"
          else "/home";

        mkDarwinConfig = {
          arch ? "x86_64",
          baseModules ? [
            home-manager.darwinModules.home-manager
            ./modules/darwin
            # {home-manager.sharedModules = [sops-nix.homeManagerModule];}
          ],
          extraModules ? [],
          username,
        }: {
          darwinConfigurations.${username} = darwinSystem {
            system = "${arch}-darwin";
            modules = baseModules ++ extraModules;
          };
        };

        mkHomeConfig = {
          username,
          arch ? "x86_64",
          os ? "linux",
          baseModules ? [
            ./modules/home-manager
            # sops-nix.homeManagerModule
            {
              home = {
                inherit username;
                homeDirectory = "${homePrefix os}/${username}";
              };
            }
          ],
          extraModules ? [],
        }: let
          system = "${arch}-${os}";
          path = "${username}@${system}";
        in {
          homeConfigurations.${username} = withSystem system ({pkgs, ...}:
            homeManagerConfiguration {
              inherit pkgs;

              modules = baseModules ++ extraModules;
            });

          checks."${arch}-${system}"."${username}_home" =
            self.homeConfigurations.${username}.activationPackage;
        };
      in
        mkMerge [
          (mkDarwinConfig {
            username = "vhotmar";
            extraModules = [./profiles/vhotmar.nix];
          })
          (mkHomeConfig {
            username = "paperspace";
            os = "linux";
            extraModules = [./profiles/home-manager/paperspace.nix];
          })
          # (mkHomeConfig { username = "vhotmar"; system = "darwin"; extraModules = [./profiles/home-manager/vhotmar.nix]; })
        ];

      perSystem = {
        config,
        inputs',
        pkgs,
        system,
        ...
      }: {
        devshells.default = {
          name = "system";
          packages = with pkgs; [
            jo
          ];

          commands = [
            {package = pkgs.just;}
            {
              package = pkgs.sops;
              category = "secrets";
            }
            {
              package = pkgs.rage;
              category = "secrets";
            }
            {package = config.treefmt.build.wrapper;}
          ];
        };

        treefmt = {
          projectRootFile = ".git/config";
          programs.alejandra.enable = true;
          programs.prettier.enable = true;
          programs.stylua.enable = true;
          settings.formatter.fish = {
            command = "${pkgs.fish}/bin/fish_indent";
            options = ["--write"];
            includes = ["*.fish"];
          };
          settings.formatter.just = {
            command = pkgs.lib.getExe pkgs.just;
            options = ["--fmt" "--unstable" "-f"];
            includes = ["Justfile"];
          };
        };
      };
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
    devshell.url = "github:numtide/devshell";
  };
}
