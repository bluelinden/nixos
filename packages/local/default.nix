{ pkgs, stdenv, dpkg, glibc, gcc-unwrapped, autoPatchelfHook, libaio, ncurses5, libxkbcommon, alsa-lib, xorg, mesa, cairo, numactl, dbus, gtk3, pango, nss, nspr, gsasl, libz, libxcrypt, cyrus_sasl, makeDesktopItem, copyDesktopItems }:
let
  version = "8.2.0";

  src = if stdenv.hostPlatform.system == "x86_64-linux" then
    builtins.fetchurl {
      url = "https://cdn.localwp.com/releases-stable/8.2.0+6554/local-8.2.0-linux.deb";
      sha256 = "sha256:05nvpzjlr3v6iqrnsckp1zba5pcri68wkgvhglw1zm7fhz32m3ki";
    }
    else
      throw "LocalWP is not supported on ${stdenv.hostPlatform.system}";

in stdenv.mkDerivation {
  name = "localwp-${version}";
  pname = "local";

  system = "x86_64-linux";

  inherit src;

  # Required for compilation
  nativeBuildInputs = [
    dpkg
    libaio
    ncurses5
    libxkbcommon
    alsa-lib
    xorg.libXrandr
    mesa
    cairo
    xorg.libXcomposite
    numactl
    dbus
    gtk3
    pango
    nss
    nspr
    gsasl
    libz
    libxcrypt
    gsasl
    autoPatchelfHook # Automatically setup the loader, and do the magic
    cyrus_sasl
    copyDesktopItems
  ];


  # Required at running time
  buildInputs = [
    glibc
    libaio
  ];

  # unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/local.desktop <<EOF
    [Desktop Entry]
    Name=Local
    Exec=${pkgs.steam-run}/bin/steam-run $out/opt/Local/local %U
    Terminal=false
    Type=Application
    Icon=local
    StartupWMClass=Local
    Comment=Create local WordPress sites with ease.
    MimeType=x-scheme-handler/flywheel-local;
    Categories=Development;
    EOF
    mkdir -p $out/share/icons/hicolor/
    mv $out/usr/share/icons/hicolor/* $out/share/icons/hicolor 
    copyDesktopItems
  '';

  meta = with stdenv.lib; {
    description = "LocalWP";
    homepage = https://localwp.com/;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
