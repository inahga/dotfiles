{pkgs ? import <nixos-unstable> {}}:
pkgs.mkShell {
  nativeBuildInputs = [pkgs.pkg-config];
  buildInputs = with pkgs; [
    cargo
    clippy
    cmake
    openssl
    rust-analyzer
    rustc
    rustfmt
  ];
}
