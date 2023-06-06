{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = with pkgs; [
    openssl
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
  ];
}
