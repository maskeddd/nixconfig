let
  projectModules = {
    buf = "";
    bun = "";
    c = "";
    cmake = "";
    cobol = "";
    cpp = "";
    crystal = "";
    daml = "Λ";
    dart = "";
    deno = "";
    dotnet = "";
    elixir = "";
    elm = "";
    erlang = "";
    fennel = "";
    fortran = "";
    gleam = "";
    golang = "";
    gradle = "";
    haskell = "";
    haxe = "";
    helm = "";
    java = "";
    julia = "";
    kotlin = "";
    lua = "";
    maven = "";
    mojo = "󰈸";
    nim = "";
    nodejs = "";
    ocaml = "";
    odin = "󰟢";
    opa = "";
    perl = "";
    php = "";
    pixi = "󰏗";
    purescript = "";
    python = "";
    quarto = "⨁";
    raku = "󱖊";
    red = "󱍼";
    rlang = "󰟔";
    ruby = "";
    rust = "󱘗";
    scala = "";
    solidity = "";
    swift = "";
    terraform = "";
    typst = "";
    vagrant = "";
    vlang = "";
    xmake = "";
    zig = "";
  };
in
{
  den.aspects.starship.homeManager =
    { config, lib, ... }:
    {
      programs.fish.functions.starship_transient_prompt_func = "${lib.getExe config.programs.starship.package} module character $argv";

      programs.starship = {
        enable = true;
        enableTransience = true;
        settings =
          lib.mapAttrs (_: symbol: {
            inherit symbol;
            format = "[$symbol]($style) ";
            disabled = false;
          }) projectModules
          // {
            format = "[╭─](bright-black)($username$hostname )$directory$git_branch$git_status${
              lib.concatMapStrings (m: "$" + m) (lib.attrNames projectModules)
            }$nix_shell$line_break[╰─](bright-black)$character";
            right_format = "$cmd_duration";

            character = {
              success_symbol = "[λ](bold green)";
              error_symbol = "[λ](bold red)";
            };
            username.format = "[$user]($style)";
            hostname = {
              format = "[@$hostname]($style)";
              trim_at = ".local";
            };
            directory.style = "bold blue";
            git_branch.format = "[$branch]($style) ";
            git_status.format = "([$all_status$ahead_behind]($style) )";
            cmd_duration.format = "[$duration]($style) ";
            nix_shell = {
              format = "[$symbol]($style)";
              symbol = "󱄅";
            };
          };
      };
    };
}
