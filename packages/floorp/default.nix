{ lib, stdenv, fetchurl, config, wrapGAppsHook, autoPatchelfHook
, alsa-lib
, curl
, dbus-glib
, gtk3
, libXtst
, libva
, pciutils
, pipewire
, gnome
, writeScript
, writeText
, xidel
, coreutils
, gnused
, gnugrep
, gnupg
, runtimeShell
, systemLocale ? config.i18n.defaultLocale or "en_US"
, patchelfUnstable  # have to use patchelfUnstable to support --no-clobber-old-sections
, makeWrapper
}:

let
  version = "11.8.2";
  sources = [
    { 
      url = "https://github.com/Floorp-Projects/Floorp/releases/download/v11.8.2/floorp-11.8.2.linux-x86_64.tar.bz2";
      locale = "en-US";
      arch = "linux-x86_64";
      sha256 = "408653fa59cbfcc0e11c4efcb57ea74084b87b618b0e1fa65562afd11b869042";
    }
  ];


  binaryName = "floorp";

  mozillaPlatforms = {
    i686-linux = "linux-i686";
    x86_64-linux = "linux-x86_64";
  };

  arch = mozillaPlatforms.${stdenv.hostPlatform.system};

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source:
      (isPrefixOf source.locale locale) && source.arch == arch;

  policies = {
    DisableAppUpdate = true;
  } // config.firefox.policies or {};

  policiesJson = writeText "firefox-policies.json" (builtins.toJSON { inherit policies; });

  defaultSource = lib.findFirst (sourceMatches "en-US") {} sources;

  mozLocale =
    if systemLocale == "ca_ES@valencia"
    then "ca-valencia"
    else lib.replaceStrings ["_"] ["-"] systemLocale;

  source = lib.findFirst (sourceMatches mozLocale) defaultSource sources;

  pname = "floorp-bin-unwrapped";

  # FIXME: workaround for not being able to pass flags to patchelf
  # Remove after https://github.com/NixOS/nixpkgs/pull/256525
  wrappedPatchelf = stdenv.mkDerivation {
    pname = "patchelf-wrapped";
    inherit (patchelfUnstable) version;

    nativeBuildInputs = [ makeWrapper ];

    buildCommand = ''
      mkdir -p $out/bin
      makeWrapper ${patchelfUnstable}/bin/patchelf $out/bin/patchelf --append-flags "--no-clobber-old-sections"
    '';
  };

in

stdenv.mkDerivation {
  inherit pname version;




  src = fetchurl { inherit (source) url sha256; };

  nativeBuildInputs = [ wrapGAppsHook autoPatchelfHook wrappedPatchelf ];
  buildInputs = [
    gtk3
    gnome.adwaita-icon-theme
    alsa-lib
    dbus-glib
    libXtst
  ];
  runtimeDependencies = [
    curl
    libva.out
    pciutils
  ];
  appendRunpaths = [
    "${pipewire}/lib"
  ];

  installPhase =
    ''
      mkdir -p "$prefix/lib/floorp-bin-${version}"
      cp -r * "$prefix/lib/floorp-bin-${version}"

      mkdir -p "$out/bin"
      ln -s "$prefix/lib/floorp-bin-${version}/floorp" "$out/bin/${binaryName}"

      # See: https://github.com/mozilla/policy-templates/blob/master/README.md
      mkdir -p "$out/lib/floorp-bin-${version}/distribution";
      ln -s ${policiesJson} "$out/lib/floorp-bin-${version}/distribution/policies.json";
    '';

  passthru = {
    inherit binaryName;
    libName = "floorp-bin-${version}";
    ffmpegSupport = true;
    gssSupport = true;
    gtk3 = gtk3;

    # FIXME: i don't have the patience to rewrite the update script.
    # # update with:
    # # $ nix-shell maintainers/scripts/update.nix --argstr package firefox-bin-unwrapped
    # updateScript = import ./update.nix {
    #   inherit pname channel lib writeScript xidel coreutils gnused gnugrep gnupg curl runtimeShell;
    #   baseUrl = "https://archive.mozilla.org/pub/firefox/releases/";
    # };
  };

  meta = with lib; {
    changelog = "https://github.com/Floorp-Projects/Floorp/releases/tag/v${version}";
    description = "Floorp, free Firefox fork (binary package)";
    homepage = "https://floorp.ablaze.one";
    license = licenses.mpl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames mozillaPlatforms;
    hydraPlatforms = [];
    maintainers = with maintainers; [ taku0 lovesegfault ];
    mainProgram = binaryName;
  };
}