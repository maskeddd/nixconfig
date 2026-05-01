{
  den.aspects.onepassword = {
    nixos = {
      programs = {
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = [ "cody" ];
        };
      };

      environment.etc."1password/custom_allowed_browsers" = {
        text = ''
          brave
        '';
        mode = "0755";
      };
    };

    homeManager =
      { pkgs, ... }:
      let
        onePassPath =
          if pkgs.stdenv.isLinux then
            "~/.1password/agent.sock"
          else
            "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      in
      {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks."*".identityAgent = onePassPath;
        };
      };
  };
}
