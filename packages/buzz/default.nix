{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "buzz";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chidiwilliams";
    repo = "buzz";
    rev = "v${version}";
    hash = "sha256-gA40Ei4jz4Y+3IgRprxD0kFMvKovFKi2+b6/e3GvqrE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    python3.pkgs.cmake
    # python3.pkgs.ctypesgen
    python3.pkgs.poetry-core
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    dataclasses-json
    faster-whisper
    humanize
    keyring
    openai
    openai-whisper
    platformdirs
    pyqt6
    sounddevice
    # stable-ts
    torch
    transformers
  ];

  pythonImportsCheck = [ "buzz" ];

  meta = with lib; {
    description = "Buzz transcribes and translates audio offline on your personal computer. Powered by OpenAI's Whisper";
    homepage = "https://github.com/chidiwilliams/buzz";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "buzz";
  };
}
