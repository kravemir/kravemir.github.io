{ pkgs ? import <nixpkgs> {} }:

let
    hugoLockedPkgs = import (builtins.fetchTarball {
        # for Hugo '0.147.3'
        # search with https://lazamar.co.uk/nix-versions/
        url = "https://github.com/NixOS/nixpkgs/archive/4684fd6b0c01e4b7d99027a34c93c2e09ecafee2.tar.gz";
    }) {};

    hugo = hugoLockedPkgs.hugo;

in pkgs.mkShellNoCC {
  packages = [
    hugo
  ];
}
