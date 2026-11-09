{
  den.aspects.virtualisation = {
    nixos = {
      programs.virt-manager.enable = true;
      virtualisation = {
        libvirtd = {
          enable = true;
          qemu.verbatimConfig = ''
            namespaces = []
            cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/userfaultfd",
              "/dev/nvidiactl", "/dev/nvidia0", "/dev/nvidia-modeset"
            ]
          '';
        };
        spiceUSBRedirection.enable = true;
      };
    };

    provides.to-users.user.extraGroups = [ "libvirtd" ];
  };
}
