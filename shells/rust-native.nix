{pkgs ? import <nixpkgs-unstable> {}}:
pkgs.mkShell {
  nativeBuildInputs = [pkgs.pkg-config];
  buildInputs = with pkgs; [
    cargo
    clippy
    cmake
    libgit2
    openssl
    rust-analyzer
    rustc
    rustfmt
  ];
}
