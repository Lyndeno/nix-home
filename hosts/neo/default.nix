{ config, lib, pkgs, ...}:
{
    wayland.windowManager.sway.config = {
      keybindings = lib.mkOptionDefault {
        # TODO: Figure out how to make this conditional on host
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +2%";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
      };
    };
}
