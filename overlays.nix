{pkgs}:
[
  (
    final: prev: {
      logseq = prev.logseq.overrideAttrs (oldAttrs: {
        installPhase = ''
            runHook preInstall
        
            mkdir -p $out/bin $out/share/${prev.pname} $out/share/applications
            cp -a ${prev.appimageContents}/{locales,resources} $out/share/${prev.pname}
            cp -a ${prev.appimageContents}/Logseq.desktop $out/share/applications/${prev.pname}.desktop
        
            # remove the `git` in `dugite` because we want the `git` in `nixpkgs`
            chmod +w -R $out/share/${prev.pname}/resources/app/node_modules/dugite/git
            chmod +w $out/share/${prev.pname}/resources/app/node_modules/dugite
            rm -rf $out/share/${prev.pname}/resources/app/node_modules/dugite/git
            chmod -w $out/share/${prev.pname}/resources/app/node_modules/dugite
        
            mkdir -p $out/share/pixmaps
            ln -s $out/share/${prev.pname}/resources/app/icons/logseq.png $out/share/pixmaps/${prev.pname}.png
        
            substituteInPlace $out/share/applications/${prev.pname}.desktop \
              --replace Exec=Logseq Exec=${pkgs.steam-run} ${prev.pname} \
              --replace Icon=Logseq Icon=${prev.pname}
        
            runHook postInstall
          '';
      });
    }
  )
]
