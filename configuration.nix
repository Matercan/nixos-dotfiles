{ pkgs, honkai-railway-grub-theme,  ... }:

{
    imports =
    [
        ./pkgs/git.nix
        ./hardware-configuration.nix
        honkai-railway-grub-theme.nixosModules.x86_64-linux.default
    ];

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
        extraGroups = [ "wheel" ]; 
    };

    programs.firefox.enable = true;
    environment.systemPackages = with pkgs; [
        vim 
        wget
        foot
        kitty
        quickshell
        
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

        (pkgs.stdenv.mkDerivation {
            name = "iscript";
            src = ./config/fonts;
            installPhase = ''
                mkdir -p $out/share/fonts/truetype
                find . -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} $out/share/fonts/truetype/ \;
            '';
        })
    ];

    qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
    };


    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
}

