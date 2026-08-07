{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

# nullcopy's home environment, applied with standalone home-manager.
# Per-machine knobs are the `my.*` options, set per entry in ../flake.nix.
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./aliases.nix
    ./neovim.nix
    ./opencode.nix
    ./niri.nix
    ./desktop.nix
  ];

  ## ----- per-machine options ---------------------------------------------------
  options.my = {
    desktop.enable = lib.mkEnableOption "graphical desktop config (niri, noctalia, alacritty, GUI apps)";

    repoPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.dotfiles";
      description = ''
        Absolute path to this repo's checkout on this machine. Apps that
        rewrite their own config files (noctalia) get an out-of-store symlink
        into this checkout, so in-app changes land as unstaged git diffs here
        — commit them to persist.
      '';
    };
  };

  # NOTE: because this module declares `options`, everything else must sit
  # under `config` (a module can't mix top-level settings with options).
  config = {
    home.username = lib.mkDefault "nullcopy";
    home.homeDirectory = lib.mkDefault "/home/nullcopy";

    # Let home-manager manage itself, so the `home-manager` CLI stays
    # available after the first `nix run home-manager -- switch`.
    programs.home-manager.enable = true;

    ## ----- packages ------------------------------------------------------------
    # CLI-only here; GUI packages live in desktop.nix.
    home.packages = with pkgs; [
      fzf
      tldr
      ripgrep
      rage
    ];

    ## ----- programs ------------------------------------------------------------
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      initContent = ''
        export PATH="$HOME/.cargo/bin:$PATH"
      '';
      history = {
        path = "${config.home.homeDirectory}/.zsh_history";
        size = 100000;
        save = 100000;
        share = true;
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
      };
      historySubstringSearch = {
        enable = true;
        # Bind both cursor-mode (^[[A) and application-mode (^[OA) escapes:
        searchUpKey = [
          "^[[A"
          "^[OA"
        ]; # Up arrow
        searchDownKey = [
          "^[[B"
          "^[OB"
        ]; # Down arrow
      };
    };

    programs.starship = {
      enable = true;
      presets = [ "gruvbox-rainbow" ];
    };

    programs.gpg.enable = true;

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "nullcopy";
          email = "john@coldnoise.net";
        };
        core.editor = "vim";
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    };
  };
}
