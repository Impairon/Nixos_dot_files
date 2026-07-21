{ config, pkgs, ... }: {

  #Dynamic Linking
  programs.nix-ld.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname & network
  # User account
  users.users."aboayman" = {
    isNormalUser = true;
    description = "Mohamad Ayman";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  networking.hostName = "nix-pc";

  # Dynamic store optimization => sudo nix-store --optimise
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "10:00" ];

  # Add Flakes if yo want =================> "falkes"👇
  nix.settings.experimental-features = [ "nix-command" ];

  # Time & locale
  time.timeZone = "Africa/Cairo";
  i18n.defaultLocale = "en_US.UTF-8";
   i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ar_EG.UTF-8/UTF-8" 
  ];
  # Language 
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.UTF-8"; 
    LC_ADDRESS = "ar_EG.UTF-8";
    LC_IDENTIFICATION = "ar_EG.UTF-8";
    LC_MEASUREMENT = "ar_EG.UTF-8";
    LC_MONETARY = "ar_EG.UTF-8";
    LC_NAME = "ar_EG.UTF-8";
    LC_NUMERIC = "ar_EG.UTF-8";
    LC_PAPER = "ar_EG.UTF-8";
    LC_TELEPHONE = "ar_EG.UTF-8";
    LC_TIME = "ar_EG.UTF-8";
  };

  # System Fonts
    fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ nerd-fonts._0xproto ];
    fontconfig.defaultFonts.monospace = [ "0xProto Nerd Font Mono" ];
  };

  # Sound
  services.pipewire.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;               
    powerManagement.enable = true;
  };

  # X11 (required for KDE Plasma and XWayland)
  services.xserver.enable = true;

  # ---- DISPLAY MANAGER (SDDM) ----
    services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    wayland.enable = true;
    extraPackages = with pkgs; [
      kdePackages.qtsvg
      kdePackages.qtvirtualkeyboard
      kdePackages.qtmultimedia
      (pkgs.sddm-astronaut.override {
        embeddedTheme = "black_hole";
      })
    ];
    };
  
  # ---- DESKTOP ENVIRONMENTS ----
  services.desktopManager.plasma6.enable = true;   # KDE Plasma
  programs.hyprland.enable = true;                 # Hyprland
  programs.hyprland.xwayland.enable = true;        # X11 Ehtiyaty

  # Printing
  services.printing.enable = true;


  # Virtualisation
  virtualisation.libvirtd.enable = true;

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # ---- Partition Mnager ---
  programs.partition-manager.enable = true;
  boot.supportedFilesystems = [ "exfat" ];

  system.stateVersion = "26.05";
}
