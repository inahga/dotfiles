{pkgs ? import <nixos-unstable> {}}:
pkgs.mkShell {
  buildInputs = with pkgs;
  with python3Packages; [
    black
    click
    pip
    pytest
    pyyaml
    requests
  ];
}
