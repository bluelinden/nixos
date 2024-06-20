{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, stdenv
, wayland
, xorg
, xcb-util-cursor
, ...
}:

rustPlatform.buildRustPackage rec {
  pname = "xwayland-satellite";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = "v${version}";
    hash = "sha256-dwF9nI54a6Fo9XU5s4qmvMXSgCid3YQVGxch00qEMvI=";
  };

  cargoHash = "sha256-nKPSkHbh73xKWNpN/OpDmLnVmA3uygs3a+ejOhwU3yA==";

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxkbcommon
  ] ++ lib.optionals stdenv.isLinux [
    wayland
    xorg.libxcb
    xcb-util-cursor
  ];

  meta = with lib; {
    description = "Xwayland outside your Wayland";
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
    mainProgram = "xwayland-satellite";
  };
}
