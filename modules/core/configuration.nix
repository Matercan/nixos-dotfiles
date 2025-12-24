{
  pkgs,
  config,
  ...
}:

let
  customFonts = (
    pkgs.stdenv.mkDerivation {
      name = "fonts";
      src = ../config/fonts;
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        find . -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} $out/share/fonts/truetype/ \;
      '';
    }
  );
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

  services.getty.autologinUser = "matercan";
  programs.zsh.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/matercan/nixos-dotfiles";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    fuse
    icu
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  networking.hostName = "mangowc-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    keyMap = "uk";
  };

  services.xserver.xkb.layout = "gb";
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
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
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    roboto

    customFonts
  ];

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "kvantum";
  };

  
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    extraConfig = ''
      Match user git
          allowTcpForwarding no
          AllowAgentForwarding no
          PasswordAuthentication no
          X11Forwarding no
    '';
  };
  system.stateVersion = "25.11";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

}
