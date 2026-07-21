{ config, pkgs, ... }:

{
  imports = [
  ./hardware-configuration.nix
  ./modules/system.nix
  ./modules/programs.nix
  ./modules/firewall.nix
  ];
}
