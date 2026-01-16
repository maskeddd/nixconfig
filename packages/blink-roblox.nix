{
  lib,
  stdenv,
  fetchFromGitHub,
  lune,
  darklua,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blink-roblox";
  version = "0.18.6";

  src = fetchFromGitHub {
    owner = "1Axen";
    repo = "blink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LQM2R0+YF9ADBtKKlfDKyOuPY4ugK8oEC5W9AB/FKf0=";
  };

  nativeBuildInputs = [
    lune
    darklua
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p release
    darklua process --config build/.darklua.json src/CLI/init.luau release/blink.luau

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/blink
    cp release/blink.luau $out/share/blink/

    cat > $out/bin/blink <<EOF
    #!/bin/sh
    exec ${lune}/bin/lune run $out/share/blink/blink.luau "\$@"
    EOF
    chmod +x $out/bin/blink

    runHook postInstall
  '';

  meta = {
    description = "An IDL compiler written in Luau for ROBLOX buffer networking";
    homepage = "https://github.com/1Axen/blink";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "blink";
  };
})
