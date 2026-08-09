{ inputs, ... }:

{ config, lib, pkgs, ... }:

let
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
  };


in {
  home.stateVersion = "26.05";

  home.enableNixpkgsReleaseCheck = false;

  xdg.enable = true;

  # Packages
  home.packages = with pkgs; [
    adwaita-icon-theme
    foot
    kitty
    tmux
    imagemagick
    fastfetch
    gimp
    podman-compose
    zip
    unzip
    vlc
    qemu_kvm
    libvirt
    virt-manager
    kubernetes
    kubectl
    kompose
    cmatrix
    cliphist
    wl-clipboard
    pavucontrol
    brave
    librewolf
    ripgrep
    wireshark
    #noctalia
    #noctalia-greeter
    zathura
    starship
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    kdePackages.gwenview
    kdePackages.ark
    kdePackages.dolphin
    qt6.qtwayland
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  # home.sessionPath = [
  #   "${gopath}/bin"
  # ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim"; 
  };

  # home.file = {
  #   ".gdbinit".source = ./gdbinit;
  #   ".inputrc".source = ./inputrc;
  # };

  # xdg.configFile = {
  #   "i3/config".text = builtins.readFile ./i3;
  #   "nvim/init.lua".force = true;
  # };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = true;

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;
    shellAliases = shellAliases;
  };

  # programs.direnv= {
  #   enable = true;
  #
  #   config = {
  #     whitelist = {
  #       prefix= [
  #         "$HOME/code/go/src/github.com/amrahs"
  #       ];
  #
  #       exact = ["$HOME/.envrc"];
  #     };
  #   };
  # };

  programs.fish = {
    enable = true;
    shellAliases = shellAliases; 
  };

  # programs.git = {
  #   enable = true;
  #   settings = {
  #     user.name = "";
  #     user.email = "";
  #     branch.autosetuprebase = "always";
  #     color.ui = true;
  #     core.askPass = ""; # needs to be empty to use terminal for ask pass
  #     credential.helper = "store"; # want to make this more secure
  #     github.user = "amrahs";
  #     push.default = "tracking";
  #     init.defaultBranch = "main";
  #     aliases = {
  #       cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
  #       prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
  #       root = "rev-parse --show-toplevel";
  #     };
  #   };
  # };

  # programs.go = {
  #   enable = true;
  #   env = { 
  #     GOPATH = gopath;
  #     GOPRIVATE = [ "github.com/amrahs" ];
  #   };
  # };

  programs.jujutsu = {
    enable = true;
  };
 
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    withPython3 = true;
    withRuby = true;
    initLua = ''
      require("config.lazy")
    '';
  }; 
}
