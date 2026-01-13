{
  pkgs,
  ...
}:

let
  customFonts = pkgs.stdenv.mkDerivation {
    name = "custom-fonts";
    src = ../../config/fonts;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      find $src -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} $out/share/fonts/truetype/ \;
    '';
  };
in
{
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  honkai-railway-grub-theme = {
    enable = true;
    theme = "Evernight";
  };

  networking.hostName = "mangowc-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    appimage-run = pkgs.appimage-run.override {
      extraPkgs = pkgs: [ pkgs.icu ];
    };
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        catppuccin-fcitx5
      ];
    };

  };

  console = {
    keyMap = "uk";
  };

  users.users.matercan = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    foot
    quickshell
    
    (appimage-run.override {
      extraPkgs = pkgs: [ pkgs.icu ];
    })

    eza
    fastfetch
    fuzzel
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-serif

    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-mono nerd-fonts.caskaydia-cove
    customFonts
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
