{
  description = "Nixpkgs overlay carrying Frigate GenAI review's 'nothing noteworthy' response";

  inputs = {
    flake-lib.url = "github:jgus-org/flake-lib/v1";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      flake-lib,
      nixpkgs,
      ...
    }:
    {
      overlays.default = final: prev: {
        frigate = prev.frigate.overrideAttrs (
          finalAttrs: previousAttrs: {
            doCheck = false;
            doInstallCheck = false;
            patches = (previousAttrs.patches or [ ]) ++ [ ./nothing-to-report.patch ];
          }
        );
      };
    }
    // (flake-lib.lib.eachDefaultSystem (
      system:
      let
        orgFormatting = flake-lib.lib.mkFormatting {
          inherit self system;
        };
      in
      {
        checks =
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          in
          {
            inherit (pkgs) frigate;
            formatting = orgFormatting.check;
          };
        formatter = orgFormatting.formatter;
      }
    ));
}
