{
  den.aspects.git = {
    homeManager.programs.git = {
      enable = true;
      settings.user = {
        email = "37945842+maskeddd@users.noreply.github.com";
        name = "masked";
      };
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqBWCeRPMDsD8zUF92Nxask7FmR4oIqdNGmylLW0A6Q";
        format = "ssh";
        signByDefault = true;
      };
    };

    hmLinux =
      { pkgs, lib, ... }:
      {
        programs.git.signing.signer = lib.getExe' pkgs._1password-gui "op-ssh-sign";
      };

    hmDarwin.programs.git.signing.signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  };
}
