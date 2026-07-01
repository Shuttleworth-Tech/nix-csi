# SPDX-License-Identifier: MIT

{
  config,
  lib,
  ...
}:
let
  cfg = config.nixkube;
  namespace = cfg.namespace;
in
{
  config = lib.mkIf cfg.enable {
    kubernetes.resources.none.Namespace.${namespace} = {
      metadata.labels = cfg.labels // {
        # CSI drivers require privileged access: hostPath volumes, privileged
        # containers, host networking. Without these labels, PodSecurity
        # admission controllers will block the nix-node DaemonSet.
        "pod-security.kubernetes.io/enforce" = "privileged";
        "pod-security.kubernetes.io/audit" = "privileged";
        "pod-security.kubernetes.io/warn" = "privileged";
      };
    };
  };
}
