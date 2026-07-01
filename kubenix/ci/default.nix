# SPDX-License-Identifier: MIT

{
  config,
  lib,
  ...
}:
let
  cfg = config.nixkube;
in
{
  config = {
    # GHCR packages are private (org policy), so CI creates a ghcr-pull
    # docker-registry secret before deploying.
    nixkube.imagePullSecrets = [ "ghcr-pull" ];
    nixkube.loggingConfig = {
      renderer = "json";
      loggers = {
        nixkube.level = "DEBUG";
        httpx.level = "WARNING";
      };
      root.level = "INFO";
    };
    # Substituters for CI (Kind cluster and NixOS test VM share this config).
    nixkube.node.nixConfig.settings.substituters = [
      "https://shuttleworth-nix-csi.cachix.org"
      "https://cache.nixos.org"
    ];
  };
}
