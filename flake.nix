# SPDX-License-Identifier: MIT

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compatish = {
      # pinned; mirror at Shuttleworth-Tech/flake-compatish
      url = "github:lillecarl/flake-compatish/d8c944d4df613d47a3dc7b800c7531c33323c845";
      flake = false;
    };
    easykubenix = {
      # pinned; mirror at Shuttleworth-Tech/easykubenix
      url = "github:lillecarl/easykubenix/88a025fc04889f25b702f79030c6220c3ec48f9b";
      flake = false;
    };
    dinix = {
      # pinned; mirror at Shuttleworth-Tech/dinix
      url = "github:lillecarl/dinix/383d944448f629813a691707b8b45ba78f4d2f6b";
      flake = false;
    };
  };
  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      gen = func: lib.genAttrs [ "aarch64-linux" "x86_64-linux" ] func;
    in
    {
      packages = gen (
        system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
        in
        {
          inherit (pkgs) hello;
          helloEnv = pkgs.buildEnv {
            name = "helloEnv";
            paths = [
              pkgs.hello
            ];
          };
        }
      );
    };
}
