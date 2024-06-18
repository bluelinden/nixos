{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, stdenv
, wayland
, xorg
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

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxkbcommon
  ] ++ lib.optionals stdenv.isLinux [
    wayland
    xorg.libxcb
  ];

  meta = with lib; {
    description = "Xwayland outside your Wayland";
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
    mainProgram = "xwayland-satellite";
  };
}
