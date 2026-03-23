{ pkgs, ...}: {
  services.ratbagd = {
    enable = true;
    package = pkgs.libratbag;
  };
}
