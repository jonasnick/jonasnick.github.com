# Pinned, because Zola releases break templates (see 0.23).
let
  nixpkgs = fetchTarball {
    # 2026-11-04, with Zola 0.23.6
    url = "https://github.com/NixOS/nixpkgs/archive/6dadaf4375be35033e1c84395adbd53ff5fded96.tar.gz";
    sha256 = "1g9sadx7zszll972hlv78675vc5vz2iw8v9jzs4338ccx8gzp48g";
  };
  pkgs = import nixpkgs { };
in
pkgs.mkShell {
  packages = [ pkgs.zola ];
}
