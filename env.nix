{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "user-environment";
  paths = with pkgs; [
    git
    zsh
    fzf
    neovim
    nodejs
    tmux
    python3
    alacritty
  ];
}

