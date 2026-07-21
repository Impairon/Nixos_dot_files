{ config, pkgs, ... }: {

# Networking and Wifi
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  # Nix settings
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # --- Open SSH ----
  services.openssh = {
  enable = true;
};

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "aboayman";
    dataDir = "/home/aboayman/.config/syncthing";
  };

  # --- Bluetooth ---
  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  };   

  # Firewall ports (Syncthing)
  networking.firewall.allowedTCPPorts = [ 8000 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

}
