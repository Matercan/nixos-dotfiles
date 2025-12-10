{ config, pkgs, ... }:

{
    users.users.git = {
        isSystemUser = true;
        group = "git";
        home = "/var/lib/git-server";
        createHome = true;
        shell = "${pkgs.git}/bin/git-shell";
        openssh.authorizedKeys.keys = [
           "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDoLVW2UXvdg/hDHL/uhSQfmyQBt4TXjTDnVW95hhEvZ matercan@mangowc-btw" 
        ];
    };

    users.groups.git = {};

    programs.git = {
        enable = true;
        
        config = {
            user = {
                name = "lieke";
                email = "matercan@proton.me";
            };

            core.editor = "nvim";
            init.defaultBranch = "main";
        };
    };
}
