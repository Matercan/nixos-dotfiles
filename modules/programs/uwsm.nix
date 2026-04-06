{
  pkgs,
  ...
}:
{
  programs.uwsm = {
    enable = true;
    waylandCompositors.mango = {
      prettyName = "MangoWC";
      comment = "Mango compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/mango";
    };
  };
}
