{ pkgs, ... }:

{
  programs.virt-manager.enable = true;
  
  programs.ssh.askPassword = "${pkgs.x11_ssh_askpass}/bin/ssh-askpass";

  security.polkit.enable = true;
  
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  
  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    tigervnc
    x11_ssh_askpass
    polkit_gnome
  ];
}
