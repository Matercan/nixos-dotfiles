{
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
}
