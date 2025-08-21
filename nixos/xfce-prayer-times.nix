{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
    pname = "xfce-prayer-times";
    version = "1.0";

    src = pkgs.fetchFromGitHub {
      owner = "enfyna";
      repo = "xfce-prayer-times";
      rev = "main";
      sha256 = "sha256-JH/5MlD4wKp19uZaDH0ASYngBv7ESfNaW3BG5OJFMzM=";
    };

    nativeBuildInputs = [
      pkgs.clang
      pkgs.pkg-config
      pkgs.gettext
    ];

    buildInputs = [
      pkgs.xfce.libxfce4ui
      pkgs.xfce.xfce4-panel
    ];

    buildPhase = "make";

    installPhase = ''
      mkdir -p $out/share/xfce4/panel/plugins && cp prayer-times-plugin.desktop $out/share/xfce4/panel/plugins
      mkdir -p $out/lib/xfce4/panel/plugins && cp build/libprayer-times-plugin.so $out/lib/xfce4/panel/plugins
    '';
}
