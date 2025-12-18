{
  config,
  pkgs,
  lib,
  ...
}:

let
  signerBinary =
    if pkgs.stdenv.isDarwin then
      "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else
      "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
in
{
  programs.git = {
    enable = true;

    settings.user = {
      email = config.me.email;
      name = config.me.fullname;
    };

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBr31av52kwxC8FIIeSKosnY6NeYnrR0zQj8Ziqfqtqj";
      format = "ssh";
      signer = signerBinary;
      signByDefault = true;
    };
  };
}
