{ lib
, stdenv
, fetchFromGitHub
, writeShellScript
, python3
, pipx
}:

stdenv.mkDerivation rec {
  pname = "ofrak";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "redballoonsecurity";
    repo = "ofrak";
    rev = "ofrak-v${version}";
    hash = "sha256-W5HB84HHRgPG2OWGEeRQYef8wAsSlz7Fb008ZoDOncI=";
  };

  buildInputs = [
  	(writeShellScript "black" ''
  	  ${pipx}/bin/pipx run black==23.3.0
  	'')
  ];

  meta = with lib; {
    description = "OFRAK: unpack, modify, and repack binaries";
    homepage = "https://github.com/redballoonsecurity/ofrak";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ ];
    mainProgram = "ofrak";
    platforms = platforms.all;
  };
}
