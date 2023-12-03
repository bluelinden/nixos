{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wscribe";
  version = "unstable-2023-11-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geekodour";
    repo = "wscribe";
    rev = "205bb19ff3bf400ec7dee1933fa10e4c3827e038";
    hash = "sha256-kPJpQHWnM7bfcTH1d4i5/aj9JMM0MGBc0zX/AcgeNbg=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    faster-whisper
    structlog
  ];

  pythonImportsCheck = [ "wscribe" ];

  meta = with lib; {
    description = "Ez audio transcription tool with flexible processing and post-processing options";
    homepage = "https://github.com/geekodour/wscribe";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "wscribe";
  };
}
