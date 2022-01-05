{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  #home.username = "lsanche";
  #home.homeDirectory = "/home/lsanche";

  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    #neofetch
    starship
    exa
    bat
    jq
    #bottom
    spotify
    zathura
    #pavucontrol
    #signal-desktop
    #gnupg
    #gnome.seahorse
    #gnome.nautilus
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  #fonts.fontconfig.enable = true;

  programs.vim = {
    enable = true;
    settings = {
      tabstop = 2;
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true; # seems this is a new addition
    history = {
      path = "$HOME/.cache/zsh/histfile";
    };
  };

  programs.waybar = {
    enable = true;
    # in next release will allow specifying the path to a css file
    style = lib.readFile ./style.css;
    settings = [{
      position = "bottom";
      height = 10;
      modules-left = ["sway/workspaces" "sway/window"];
      modules-right = ["disk#nix" "cpu" "memory" "network" "battery" "backlight" "clock" "pulseaudio" "idle_inhibitor" "tray" ];
      gtk-layer-shell = true;
      modules = {
        "disk#nix" = {
          interval = 30;
          format = " {percentage_free}%";
          path = "/nix";
          states = {
            "warning" = 80;
            "high" =  90;
            "critical" = 95;
          };
        };

        "battery" = {
          interval = 5;
          states = {
            "warning" = 30;
            "critical" = 15;
          };
          format-discharging = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-full = " Full";
          format-icons = ["" "" "" "" "" "" "" "" "" ""];
        };
      };
    }];
  };

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = false;
    wrapperFeatures.gtk = true;
    package = null;
    config = {
      startup = [
        #{ command = "pkill waybar; ${pkgs.waybar}/bin/waybar"; always = true;}
        { command = "dbus-update-activation-environment WAYLAND_DISPLAY"; }
      ];
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        menu = config.wayland.windowManager.sway.config.menu;
      in lib.mkOptionDefault {
        "${modifier}+l" = "exec ${pkgs.swaylock}/bin/swaylock";
        "${modifier}+grave" = "exec ${menu}";
        # TODO: Figure out how to make this conditional on host
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +2%";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
      };
      menu = "${pkgs.wofi}/bin/wofi --show drun --allow-images --no-actions";
      window.titlebar = false;
      window.commands = [
        {
          criteria = {
            title = "^Picture-in-Picture$";
            app_id = "firefox";
          };
          command = "floating enable, move position 877 450, sticky enable";
        }
        {
          criteria = {
            title = "Firefox — Sharing Indicator";
            app_id = "firefox";
          };
          command = "floating enable, move position 877 450";
        }
      ];
      terminal = "alacritty";
      modifier = "Mod4";
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_factor = "0.2";
        };
      };
      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];
    };
  };

  programs.mako = {
    enable = true;
    anchor = "bottom-right";
    backgroundColor = "#191919F3";
    borderColor = "#aa1111ff";
    borderRadius = 5;
    borderSize = 2;
    defaultTimeout = 10000;
    font = "CaskcaydiaCove Nerd Font 12";
    groupBy = "summary";
    layer = "overlay";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 11;
        normal = {
          family = "CaskaydiaCove Nerd Font Mono";
          style = "Regular";
        };
      };
      window = {
        padding = {
          x = 12;
          y = 12;
        };
        dynamic_padding = true;
      };
      background_opacity = 0.95;
      mouse.hide_when_typing = true;
      colors = {
        primary = {
          foreground = "#ffffff";
          background = "#191919";
        };
        normal = {
          black = "#171421";
          red =   "#c01c28";
          green = "#26a269";
          yellow = "#e3d44b";
          blue =  "#12488b";
          magenta = "#a347ba";
          cyan =  "#2aa1b3";
          white = "#d0cfcc";
        };
        bright = {
          black = "#5e5c64";
          red =   "#f66151";
          green = "#33d17a";
          yellow = "#e9ad0c";
          blue =  "#2a7bde";
          magenta = "#c061cb";
          cyan =  "#33c7de";
          white = "#ffffff";
        };
      };
    };
  };

  #programs.firefox = {
  #  enable = true;
  #  package = pkgs.firefox-wayland;
  #};

  programs.git = {
    enable = true;
    userName = "Lyndon Sanche";
    userEmail = "lsanche@lyndeno.ca";
    signing.key = "6F8E82F60C799B18";
    signing.signByDefault = true;
  };

  #services.gpg-agent = {
  #  enable = true;
  #  #enableSshSupport = true;
  #  pinentryFlavor = "gnome3";
  #};
  #services.gnome-keyring = {
  #  enable = true;
  #  components = [ "secrets" "ssh" ];
  #};

  nixpkgs.config.allowUnfree = true;
  #programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode;
  #  extensions = (with pkgs.vscode-extensions; [
  #    vscodevim.vim
  #    ms-vscode.cpptools
  #    coenraads.bracket-pair-colorizer-2
  #    usernamehw.errorlens
  #    yzhang.markdown-all-in-one
  #    pkief.material-icon-theme
  #    ibm.output-colorizer
  #    #christian-kohler.path-intellisense
  #    mechatroner.rainbow-csv
  #    #rust-lang.rust
  #    #wayou.vscode-todo-highlight
  #    jnoortheen.nix-ide
  #  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
  #    name = "rust";
  #    publisher = "rust-lang";
  #    version = "0.7.8";
  #    sha256 = "637dda81234c5666950907587799b3c2388ae494d94edcd39264864d0ad2360d";
  #  }
  #  {
  #    name = "nix-env-selector";
  #    publisher = "arrterian";
  #    version = "1.0.7";
  #    sha256 = "0e76885c9dbb6dca4eac8a75866ec372b948cc64a3a3845327d7c3ef6ba42a57";
  #  }
  #  ];
  #  userSettings = {
  #    "editor.cursorSmoothCaretAnimation" = true;
  #    "editor.smoothScrolling" = true;
  #    "editor.cursorBlinking" = "phase";
  #    "git.autofetch" = true;
  #    "git.confirmSync" = false;
  #    "git.enableSmartCommit" = true;
  #    "workbench.iconTheme" = "material-icon-theme";
  #    "editor.fontLigatures" = true;
  #    "editor.fontFamily" = "'CaskaydiaCove Nerd Font'";
  #    "terminal.integrated.fontFamily" = "'CaskaydiaCove Nerd Font'";
  #    "window.menuBarVisibility" = "toggle";
  #    "workbench.editor.decorations.badges" = true;
  #    "workbench.editor.decorations.colors" = true;
  #    "workbench.editor.wrapTabs" = true;
  #    "diffEditor.renderSideBySide" = true;
  #  };
  #};

  programs.starship = {
    enable = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  #home.stateVersion = "21.11";
}
