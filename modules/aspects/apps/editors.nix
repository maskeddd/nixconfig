{ den, ... }:
{
  den.aspects.editors.includes = with den.aspects; [
    zed
    helix
    vscode
  ];
}
