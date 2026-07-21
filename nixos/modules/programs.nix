{ config, pkgs, unstable, ... }: {

  # ---- SYSTEM PACKAGES ----
  environment.systemPackages = with pkgs; [
    zed-editor
    telegram-desktop
    obsidian
    virt-manager
    virtiofsd
    brave
    kitty
    neovim
    bottom
    yazi
    pavucontrol   
    mpv
    rofi
    jujutsu
    hyprshot
    grim
    slurp
    satty
    hypridle
    waybar
    starship
    swaybg
    hyprsunset
    hyprlock
    libnotify
    ncdu
    brightnessctl
    swaynotificationcenter
    rofimoji
    keepassxc
    veracrypt
    git
    wget
    xdg-desktop-portal-hyprland
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    uwsm
    bc
    wtype
    networkmanagerapplet
    fastfetch
    python3
    cliphist
    wl-clipboard
    nwg-look
    qt6Packages.qt6ct
    arc-theme
    (pkgs.sddm-astronaut.override {
    embeddedTheme = "black_hole";
    })
    ];
}
