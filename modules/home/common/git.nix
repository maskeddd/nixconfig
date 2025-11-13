{
  config,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          email = config.me.email;
          name = config.me.fullname;
        };
      };
      ignores = [
        "*~"
        "*.swp"
      ];
    };
  };
}
