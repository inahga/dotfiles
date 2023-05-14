{ pkgs, lib, config, ... }: {
  boot.kernelModules = [ "amd-pstate" ];
  boot.kernelParams = [ "amd_pstate=passive" "amdgpu.sg_display=0" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };
}
