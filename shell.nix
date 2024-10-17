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

  shellHook = # bash
    ''
      ansible-galaxy collection install -U -r ./requirements.yml > /dev/null
    '';
}
