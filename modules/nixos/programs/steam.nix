{ pkgs, ... }:
{
  programs.steam = {
    enable = pkgs.stdenv.isx86_64;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
