switch-darwin: fmt
    darwin-rebuild --flake . switch

switch-home: fmt
    home-manager --flake . switch

fmt:
    treefmt
