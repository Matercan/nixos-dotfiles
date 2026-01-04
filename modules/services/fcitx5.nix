pkgs: {
  services.fcitx5 = {
    enable = true;
    addons = with pkgs; [ fcitx5-mozc ];
  };
}
