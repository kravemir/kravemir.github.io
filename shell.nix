{ pkgs ? import <nixpkgs> {} }:

let
    hugoLockedPkgs = import (builtins.fetchTarball {
        # for Hugo '0.147.3'
        # search with https://lazamar.co.uk/nix-versions/
        url = "https://github.com/NixOS/nixpkgs/archive/4684fd6b0c01e4b7d99027a34c93c2e09ecafee2.tar.gz";
    }) {};

    mermaidLockedPkgs = import (builtins.fetchTarball {
        # for mermaid '11.4.2'
        # search with https://lazamar.co.uk/nix-versions/
        url = "https://github.com/NixOS/nixpkgs/archive/e6f23dc08d3624daab7094b701aa3954923c6bbb.tar.gz";
    }) {};

    hugo = hugoLockedPkgs.hugo;
    mermaid-cli = mermaidLockedPkgs.mermaid-cli;

in pkgs.mkShellNoCC {
  packages = [
    hugo
    mermaid-cli
  ];
}
