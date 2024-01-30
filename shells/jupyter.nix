{pkgs ? import <nixos-unstable> {}}:
pkgs.mkShell {
  buildInputs = with pkgs;
  with python3Packages; [
    ipython
    jupyter
    pandas
    numpy
    matplotlib
  ];
  shellHook = "jupyter notebook";
}
