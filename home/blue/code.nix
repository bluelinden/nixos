{ pkgs, upkgs, extensions }:
{

  enable = true;
  package = upkgs.vscodium;
  extensions = with extensions."x86_64-linux".vscode-marketplace; [
    aaron-bond.better-comments
    # activitywatch.aw-watcher-vscode
    # adrianwilczynski.alpine-js-intellisense
    andrejunges.handlebars
    ardenivanov.svelte-intellisense
    arrterian.nix-env-selector
    # astro-build.astro-vscode
    bbenoist.nix
    beardedbear.beardedicons
    bierner.markdown-mermaid
    bmewburn.vscode-intelephense-client
    bpruitt-goddard.mermaid-markdown-syntax-highlighting
    bradlc.vscode-tailwindcss
    catppuccin.catppuccin-vsc
    catppuccin.catppuccin-vsc-icons
    catppuccin.catppuccin-vsc-pack
    ccy.ayu-adaptive
    championswimmer.quieter-dark-color-theme
    ckolkman.vscode-postgres
    codezombiech.gitignore
    coolbear.systemd-unit-file
    csilva2810.rose-pine-next
    csstools.postcss
    davidanson.vscode-markdownlint
    davidbwaters.macos-modern-theme
    davidfreer.go-to-character-position
    dbaeumer.vscode-eslint
    divola.ayu-dark-lighter
    dustypomerleau.rust-syntax
    eamodio.gitlens
    ecmel.vscode-html-css
    editorconfig.editorconfig
    embertooling.emberjs
    embertooling.vscode-ember
    enkia.tokyo-night
    esbenp.prettier-vscode
    fivethree.vscode-svelte-snippets
    gencer.html-slim-scss-css-class-completion
    # gengjiawen.vscode-wasm
    github.remotehub
    github.vscode-github-actions
    github.vscode-pull-request-github
    gleam.gleam
    helixquar.asciidecorator
    # icrawl.discord-vscode
    ikenshu.rose-noctis
    jnoortheen.nix-ide
    lehwark.htmx-literals
    liamhammett.inline-parameters
    macabeus.vscode-fluent
    matthiashunt.wordpress-syntax-highlighter
    mkhl.direnv
    mrmlnc.vscode-scss
    ms-azuretools.vscode-docker
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance
    # ms-toolsai.jupyter
    # ms-toolsai.jupyter-keymap
    # ms-toolsai.jupyter-renderers
    # ms-toolsai.vscode-jupyter-cell-tags
    # ms-toolsai.vscode-jupyter-slideshow
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode.azure-repos
    ms-vscode.remote-explorer
    ms-vscode.remote-repositories
    ms-vscode.remote-server
    ms-vscode.vscode-typescript-next
    mtxr.sqltools
    mtxr.sqltools-driver-pg
    mvllow.rose-pine
    natqe.reload
    otovo-oss.htmx-tags
    oven.bun-vscode
    pinage404.nix-extension-pack
    piousdeer.adwaita-theme
    pkief.material-product-icons
    plievone.vscode-template-literal-editor
    # redhat.java
    redhat.vscode-xml
    redhat.vscode-yaml
    rust-lang.rust-analyzer
    serayuzgur.crates
    # RobertOstermann.vscode-sqlfluff
    stylelint.vscode-stylelint
    surrealdb.surrealql
    # svelte.svelte-vscode
    syler.sass-indented
    tamasfe.even-better-toml
    teabyii.ayu
    tomoyukim.vscode-mermaid-editor
    tryghost.ghost
    typed-ember.glint-vscode
    ultram4rine.vscode-choosealicense
    usernamehw.errorlens
    vadimcn.vscode-lldb
    visualstudioexptteam.intellicode-api-usage-examples
    visualstudioexptteam.vscodeintellicode
    vivaxy.vscode-conventional-commits
    vscjava.vscode-java-debug
    vscjava.vscode-java-dependency
    vscjava.vscode-java-pack
    vscjava.vscode-java-test
    vscjava.vscode-maven
    yandeu.five-server
    yoavbls.pretty-ts-errors
    zguolee.tabler-icons
    eww-yuck.yuck
    shaunlebron.vscode-parinfer
  ];
}
