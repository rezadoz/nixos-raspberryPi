# packages.nix — install with:
#   nix-env -iA nixpkgs.<name>          (imperative, per-user)
#   nix profile install nixpkgs#<name>  (flake-style, per-user)
#
# Or drop the `environment.systemPackages` block into /etc/nixos/configuration.nix
# if you're on NixOS.  On plain Raspbian with nix-daemon, use home-manager
# (see the home.nix snippet at the bottom of this file).
#
# Target: Raspberry Pi (aarch64-linux) / Raspbian + Nix
# ──────────────────────────────────────────────────────

{ pkgs ? import <nixpkgs> { system = "aarch64-linux"; } }:

pkgs.buildEnv {
  name = "rpi-qol-packages";
  paths = with pkgs; [

    # ── Shell & terminal experience ─────────────────────────────
    zsh                   # better interactive shell
    oh-my-zsh             # zsh framework / plugins
    starship              # fast cross-shell prompt
    tmux                  # terminal multiplexer
    zoxide                # smarter `cd` (z/zi commands)
    fzf                   # fuzzy finder (ctrl-r, ctrl-t)
    direnv                # auto-load .envrc when entering dirs
    nix-direnv            # faster direnv integration for Nix

    # ── Modern UNIX replacements ────────────────────────────────
    bat                   # cat with syntax highlighting
    eza                   # ls replacement (colours, icons, tree)
    fd                    # find replacement
    ripgrep               # grep replacement (rg)
    sd                    # sed replacement
    delta                 # better git/diff pager
    bottom                # htop replacement (btm)
    dust                  # du replacement — visual disk usage
    duf                   # df replacement — prettier disk free
    procs                 # ps replacement

    # ── File & archive management ───────────────────────────────
    unzip
    p7zip
    tree
    ranger                # terminal file manager
    rsync

    # ── Networking & diagnostics ────────────────────────────────
    curl
    wget
    httpie                # curl with a nicer UX (http/https)
    nmap
    iperf3                # network bandwidth benchmarking
    netcat-openbsd
    dig                   # DNS lookup (part of bind-tools)
    mtr                   # traceroute + ping combined

    # ── Nix tooling ─────────────────────────────────────────────
    nix-tree              # visualise the dependency graph
    nix-du                # find what's eating /nix/store
    nixfmt-rfc-style      # official Nix formatter
    home-manager          # per-user package & dotfile management

    # ── Development essentials ──────────────────────────────────
    git
    git-lfs
    gh                    # GitHub CLI
    gnumake
    gcc
    pkg-config
    python3
    nodejs_20

    # ── System monitoring ───────────────────────────────────────
    htop
    lm_sensors            # read CPU/GPU temperature (`sensors`)
    smartmontools         # disk health (smartctl)
    lsof
    strace

    # ── Editors ─────────────────────────────────────────────────
    neovim
    helix                 # modal editor, LSP built-in

    # ── Utilities ───────────────────────────────────────────────
    jq                    # JSON processor
    yq-go                 # YAML/TOML processor
    just                  # command runner (Makefile alternative)
    hyperfine             # command-line benchmarking
    parallel              # GNU parallel
    pv                    # pipe viewer (progress on pipes)
    man-pages
  ];
}

# ══════════════════════════════════════════════════════════════
#  home-manager snippet  (~/.config/home-manager/home.nix)
#  Run `home-manager switch` after editing.
# ══════════════════════════════════════════════════════════════
#
# { config, pkgs, ... }: {
#   home.username = "pi";
#   home.homeDirectory = "/home/pi";
#   home.stateVersion = "24.05";
#
#   home.packages = with pkgs; [
#     bat eza fd ripgrep fzf zoxide tmux starship
#     nix-tree nixfmt-rfc-style jq yq-go just
#     bottom dust duf delta procs httpie
#     ranger git gh neovim helix
#   ];
#
#   programs.zsh.enable  = true;
#   programs.starship.enable = true;
#   programs.zoxide.enable   = true;
#   programs.direnv.enable   = true;
#   programs.direnv.nix-direnv.enable = true;
#   programs.fzf.enable  = true;
#   programs.git = {
#     enable    = true;
#     userName  = "Your Name";
#     userEmail = "you@example.com";
#     delta.enable = true;
#   };
# }

