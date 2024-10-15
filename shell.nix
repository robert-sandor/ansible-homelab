{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    ansible
    ansible-lint
    gnumake
    python312Packages.jmespath
  ];
}
