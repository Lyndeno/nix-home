{ config, pkgs, lib, ... }:

let
  lockCommand = "${pkgs.swaylock-effects}/bin/swaylock";
in
{
  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lsanche";
  home.homeDirectory = "/home/lsanche";

  home.enableNixpkgsReleaseCheck = true;

  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    #neofetch
    #starship
    exa
    jq
    #bottom
    spotify
    zathura
    #pavucontrol
    signal-desktop
    #gnupg
    #gnome.seahorse
    #gnome.nautilus
    fzf
    neofetch
    bottom
    exa
    bat
    zathura
    spotify
    discord
    libreoffice-fresh
  ];

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = false;
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    theme.package = pkgs.gnome.gnome_themes_standard;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  #fonts.fontconfig.enable = true;

  services.gammastep = {
    enable = true;
    latitude = 53.6;
    longitude = -113.3;
    tray = true;
  };

  # TODO: This module will be in next hm release
  #services.swayidle = {
  #  enable = true;
  #  events = [
  #    { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock"; }
  #  ];
  #  timeouts = [
  #    { timeout = 30; command = "if pgrep swaylock; then swaymsg 'output * dpms off'"; }
  #  ];
  #};

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
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      ls = "${pkgs.exa}/bin/exa --icons --group-directories-first -B";
    };
    initExtra = ''
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
      typeset -A ZSH_HIGHLIGHT_PATTERNS
      ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
      bindkey '^ ' autosuggest-accept
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down
    '';
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      # TODO: Will be in the next release of home-manager
      #target = "sway-session.target";
    };
    # in next release will allow specifying the path to a css file
    style = lib.readFile ./style.css;
    settings = [{
      position = "bottom";
      height = 10;
      modules-left = ["sway/workspaces" "sway/window"];
      modules-right = ["disk#root" "cpu" "memory" "network" "battery" "backlight" "clock" "pulseaudio" "idle_inhibitor" "tray" ];
      gtk-layer-shell = true;
      modules = {
        "disk#root" = {
          interval = 30;
          format = " {percentage_free}%";
          path = "/";
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

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%-I:%M %p}";
          format-alt = "{:%Y-%m-%d}";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            "activated" = "";
            "deactivated" = "";
          };
        };

        "tray" = {
          icon-size = 12;
          spacing = 3;
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = true;
          interval = 3;
        };

        "memory" = {
          format = " {used:0.1f}G ({percentage}%)";
          interval = 3;
        };

        "backlight" = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" "" "" ];
        };

        "network" = {
          format-wifi = "";
          format-ethernet = "  {bandwidthDownBits}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname} = {ipaddr}/{cidr}   {bandwidthDownBits}  {bandwidthUpBits}";
          tooltip-format-wifi = "SSID = {essid}\nAddress = {ipaddr}\nBand {frequency} MHz\nUp = {bandwidthUpBits}\nDown = {bandwidthDownBits}\nStrength = {signalStrength}%";
          interval = 2;
        };

        "pulseaudio" = {
          # "scroll-step": 1, // %, can be a float
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% {format_source} ";
          format-bluetooth-muted = "婢 {icon} {format_source}";
          format-muted = "婢";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["奄" "奔" "墳"];
          };
          on-click = "pavucontrol";
        };
};
}];
  };

  xdg.configFile."swaylock/config".source = ./swaylock.conf;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = null;
    config = {
      startup = [
        { command = "dbus-update-activation-environment WAYLAND_DISPLAY"; }
        { command = "${pkgs.discord}/bin/discord --start-minimized --disable-frame-rate-limit"; }
      ];
      output."*" = { bg = "~/.config/wallpaper fill"; };
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        menu = config.wayland.windowManager.sway.config.menu;
        setMute = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@";
        setVolume = "${pkgs.pulseaudio}/bin/pactl -- set-sink-volume @DEFAULT_SINK@";
      in lib.mkOptionDefault {
        "${modifier}+l" = "exec ${lockCommand}";
        "${modifier}+grave" = "exec ${menu}";

        #TODO: Implement --locked
        "XF86AudioRaiseVolume" = "exec ${setMute} off && ${setVolume} +2%";
        "XF86AudioLowerVolume" = "exec ${setMute} off && ${setVolume} -2%";
        "XF86AudioMute" = "exec ${setMute} toggle";

        "print" = "exec --no-startup-id ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy && ${pkgs.wl-clipboard}/bin/wl-paste > ~/Pictures/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')";

        "${modifier}+equal" = "gaps inner all plus 10";
        "${modifier}+minus" = "gaps inner all minus 10";
        "${modifier}+Shift+minus" = "gaps inner all set ${toString config.wayland.windowManager.sway.config.gaps.inner}";
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
      window.border = 3;
      terminal = "alacritty";
      modifier = "Mod4";
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_factor = "0.2";
        };
      };
      gaps = {
        inner = 20;
        smartGaps = true;
        smartBorders = "on";
      };
      workspaceAutoBackAndForth = true;
      bars = [];
    };
    extraConfig = ''
      exec swayidle -w \
         timeout 300 ${lockCommand} \
         timeout 310 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
         timeout 900 'if [ $(${pkgs.acpi}/bin/acpi -a | cut -d" " -f3 | cut -d- -f1) = "off" ]; then systemctl suspend-then-hibernate; fi' \
          timeout 30 'if pgrep swaylock; then swaymsg "output * dpms off"; fi' resume 'swaymsg "output * dpms on"'\
         before-sleep '${lockCommand}'
     '';
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
    extraConfig = {
      pull.rebase = false;
    };
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
