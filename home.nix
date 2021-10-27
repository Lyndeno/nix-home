{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lsanche";
  home.homeDirectory = "/home/lsanche";

  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  fonts.fontconfig.enable = true;

  programs.vim = {
    enable = true;
    settings = {
      tabstop = 2;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = {
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_factor = "0.2";
        };
      };
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

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  programs.git = {
    enable = true;
    userName = "Lyndon Sanche";
    userEmail = "lsanche@lyndeno.ca";
    signing.key = "6F8E82F60C799B18";
    signing.signByDefault = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gtk2";
  };

  nixpkgs.config.allowUnfree = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = (with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-vscode.cpptools
      coenraads.bracket-pair-colorizer-2
      usernamehw.errorlens
      yzhang.markdown-all-in-one
      pkief.material-icon-theme
      ibm.output-colorizer
      #christian-kohler.path-intellisense
      mechatroner.rainbow-csv
      #rust-lang.rust
      #wayou.vscode-todo-highlight
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "rust";
      publisher = "rust-lang";
      version = "0.7.8";
      sha256 = "637dda81234c5666950907587799b3c2388ae494d94edcd39264864d0ad2360d";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "1.0.7";
      sha256 = "0e76885c9dbb6dca4eac8a75866ec372b948cc64a3a3845327d7c3ef6ba42a57";
    }
    ];
  };

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
  home.stateVersion = "21.05";
}
