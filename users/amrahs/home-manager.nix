{ inputs, ... }:

{ config, lib, pkgs, ... }:

let
  nixConfigPath = "${config.home.homeDirectory}/nixos-config";

  shellAliases = {
    ga = "git add";
    gc = "git commit";
    gco = "git checkout";
    gcp = "git cherry-pick";
    gdiff = "git diff";
    gl = "git prettylog";
    gp = "git push";
    gs = "git status";
    gt = "git tag";

    jd = "jj desc";
    jf = "jj git fetch";
    jn = "jj new";
    jp = "jj git push";
    js = "jj st";

    nixos-switch = "sudo nixos-rebuild switch --flake ${nixConfigPath}#host";
    nixos-test = "sudo nixos-rebuild test --flake ${nixConfigPath}#host";
    nixos-boot = "sudo nixos-rebuild boot --flake ${nixConfigPath}#host";
    switch-vm = "sudo nixos-rebuild switch --flake ${nixConfigPath}#vm";
    test-vm = "sudo nixos-rebuild test --flake ${nixConfigPath}#vm";
    boot-vm = "sudo nixos-rebuild boot --flake ${nixConfigPath}#vm";
    cleanup = "sudo nix-collect-garbage -d";
  };


in {
  home.stateVersion = "26.05";

  home.enableNixpkgsReleaseCheck = false;

  xdg.enable = true;

  # Packages
  home.packages = with pkgs; [
    papirus-icon-theme
    foot
    tmux
    imagemagick
    fastfetch
    gimp
    podman-compose
    zip
    unzip
    vlc
    cmatrix
    cliphist
    wl-clipboard
    pavucontrol
    playerctl
    mako
    waybar
    fuzzel
    brave
    librewolf
    ripgrep
    wireshark
    zathura
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    kdePackages.gwenview
    qt6.qtwayland
    brightnessctl
    bibata-cursors
    curl
    gcc
    gnumake
    pkg-config
    tree-sitter
  ];

  # Env vars and dotfiles

  home.sessionPath = [];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim"; 
  };

  home.file = {
    ".gdbinit".source = ./gdbinit;
  };

  xdg.configFile = {
    "starship.toml".source = ./starship;
    "hypr".source = ./hypr;
    "nvim".source = ./nvim;
    "fastfetch/config.jsonc".source = ./fastfetch;
    "foot/foot.ini".source = ./foot;
    "fuzzel/fuzzel.ini".source = ./fuzzel;
    "mako/config".source = ./mako;
    "waybar".source = ./waybar;
    "tmux/tmux.conf".source = ./tmux;
    "zathura/zathurarc".source = ./zathurarc;
  };

  xdg.desktopEntries.neovim = {
    name = "Neovim";
    genericName = "Text Editor";
    comment = "Edit files";
    exec = "footclient nvim %F";
    terminal = false;
    type = "Application"; 
    icon = "nvim";
    categories = [ "Development" "TextEditor" ];
    mimeType = [
      "text/plain"
      "text/x-c"
      "text/x-c++"
      "text/x-python"
    ];
  };

  # Programs

  programs.gpg.enable = true;

  programs.starship = {
    enable = true;

    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    shellAliases = shellAliases;
  };

  programs.direnv= {
    enable = true;

    config = {
      whitelist = {
        prefix= [
          "${config.home.homeDirectory}/code"
        ];

        exact = ["${config.home.homeDirectory}/.envrc"];
      };
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = shellAliases;
    interactiveShellInit = ''
      if status is-interactive
        fastfetch
      end
    '';
    functions = {
      fish_greeting = {
        body = "";
      };
      hl = {
        body = ''
          start-hyprland $argv
        '';
      };
      nixos-check = {
        body = ''
          nix flake check "$HOME/nixos-config" --all-systems --no-build; or return 1

          nix eval --raw \
            "$HOME/nixos-config#nixosConfigurations.host.config.system.build.toplevel.drvPath" \
            >/dev/null; or return 1

          nix eval --raw \
            "$HOME/nixos-config#nixosConfigurations.vm.config.system.build.toplevel.drvPath" \
            >/dev/null; or return 1

          echo "NixOS configurations are valid."
        '';
      };
    }; 
  };

  programs.git = {
    enable = true;
    signing = {
      key = "E16C803AD20A5A22";
      signByDefault = true;
    };
    settings = {
      user.name = "thestaccato";
      user.email = "296458454+thestaccato@users.noreply.github.com";
    };
  }; 

  programs.jujutsu = {
    enable = true;
  };
  
  programs.neovim = {
    enable = true;
    initLua = ''
      require("config.lazy")
    '';
  }; 
}
