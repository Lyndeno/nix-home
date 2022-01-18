{ config, lib, pkgs, ...}:
{
    wayland.windowManager.sway.config = {
        output = {
            DP-1 = {
                adaptive_sync = "on";
                pos = "1920 0";
                mode = "2560x1440@144.000000Hz";
            };
            DP-2 = {
                pos = "0 300";
            };
        };

        workspaceOutputAssign = [
            { workspace = "1"; output = "DP-1"; }
            { workspace = "2"; output = "DP-1"; }
            { workspace = "3"; output = "DP-1"; }
            { workspace = "4"; output = "DP-1"; }
            { workspace = "5"; output = "DP-1"; }
            { workspace = "6"; output = "DP-2"; }
            { workspace = "7"; output = "DP-2"; }
            { workspace = "8"; output = "DP-2"; }
            { workspace = "9"; output = "DP-2"; }
        ];
    };
}