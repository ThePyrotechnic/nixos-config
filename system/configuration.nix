# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "michael-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp9s0.useDHCP = true;
  networking.interfaces.wlp7s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      source-code-pro
      font-awesome
      material-icons
    ];
  };

  environment.variables = {
    COLOR_FG =     "#c5c8c6";
    COLOR_BG =     "#1d1f21";
    COLOR_CURSOR = "#c5c8c6";
    COLOR_0 =      "#1d1f21";
    COLOR_8 =      "#969896";
    COLOR_1 =      "#cc6666";
    COLOR_9 =      "#cc6666";
    COLOR_2 =      "#b5bd68";
    COLOR_10 =     "#b5bd68";
    COLOR_3 =      "#f0c674";
    COLOR_11 =     "#f0c674";
    COLOR_4 =      "#81a2be";
    COLOR_12 =     "#81a2be";
    COLOR_5 =      "#b294bb";
    COLOR_13 =     "#b294bb";
    COLOR_6 =      "#8abeb7";
    COLOR_14 =     "#8abeb7";
    COLOR_7 =      "#c5c8c6";
    COLOR_15 =     "#ffffff";
 };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    colors = [
      "#1d1f21"
      "#cc6666"
      "#b5bd68"
      "#f0c674"
      "#81a2be"
      "#b294bb"
      "#8abeb7"
      "#c5c8c6"
      "#969896"
      "#cc6666"
      "#b5bd68"
      "#f0c674"
      "#81a2be"
      "#b294bb"
      "#8abeb7"
      "#ffffff"
    ];
  };
  
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # dpi = 180;
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    displayManager.lightdm.background = /home/michael/Pictures/Wallpapers/lock.png;

    videoDrivers = [ "nvidia" ];    

    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
      };
    };

    screenSection = ''
      Option         "metamodes" "DP-2: nvidia-auto-select +0+0, DP-0: nvidia-auto-select +0+1440"
    '';

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        polybarFull
        i3lock
        zscroll
        playerctl 
     ];
    };
  };

  hardware.nvidia.nvidiaSettings = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudio.override { jackaudioSupport = true; };
 
  # musnix = {
  #   enable = true;
  #   alsaSeq.enable = true;  
  # };
 
  services.jack = {
    jackd.enable = true;
    alsa.enable = false;
    loopback = {
      enable = true;
    };
    jackd.extraOptions = [ "-dalsa" "--device" "hw:USB" "--rate" "48000" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michael = {
    isNormalUser = true;
    initialPassword = "1234asdf";
    extraGroups = [ "wheel" "jackaudio" "audio" ];
  };
  
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.steam = {
    enable = true;
  };

  programs.git = {
    enable = true;
    config = {
      credential.helper = "libsecret";
      user.name = "Michael Manis";
      user.email = "michaelmanis@tutanota.com";
      init.defaultBranch = "master";
    };
  };

  programs.gnupg = {
    agent.enable = true;
    agent.pinentryFlavor = "qt";
  };

security.acme.acceptTerms = true;  
security.acme.email = "michaelmanis@tutanota.com";
security.acme.certs."michaelmanis.com" = {
  group = "nginx";
  domain = "*.michaelmanis.com";
  dnsProvider = "route53";
  credentialsFile = 
    let
      secrets = (lib.importJSON ./secrets.json).acme.route53;
    in
      pkgs.writeText "route53-credentials" ''
        AWS_REGION=us-east-2
        AWS_ACCESS_KEY_ID=${secrets.key}
        AWS_SECRET_ACCESS_KEY=${secrets.secret}
        AWS_HOSTED_ZONE_ID=${secrets.zoneid}
      '';
  dnsPropagationCheck = true;
};

services.nginx = {
    enable = true;
    virtualHosts = {
      "5e.michaelmanis.com" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 5000;
            ssl = true;
          }
        ];

        forceSSL = true;
        useACMEHost = "michaelmanis.com";
        root = /home/michael/Documents/5etools-mirror-1.github.io;
        extraConfig = ''
         add_header 'Access-Control-Allow-Origin' 'https://foundry.michaelmanis.com:5000';
         add_header 'Access-Control-Allow-Methods' 'GET,OPTIONS'; 
        '';
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # CORE
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    i3
    dolphin breeze-icons filelight kdf partition-manager
    gparted
    steam-run
    deluge
    zip unzip p7zip
    git git-crypt
    pinentry pinentry-qt
    gnumake
    cmake

    # FUN
    spotify
    dolphin-emu
    frotz
    
    # MESSAGING
    discord
    tdesktop
    signal-desktop 
 
    # TERM
    rxvt-unicode
    # TEXT
    vscode-fhs
    
    # UTIL
    fontpreview
    fontforge-gtk
    psmisc
    xorg.xprop
    xorg.xev
    xclip
    vmware-horizon-client
    pavucontrol
    usbutils
    pciutils
    nginx
    awscli

    # MEDIA
    mpv
    audacity
    scrot
    obs-studio
    jack2 libjack2 qjackctl jack2Full jack_capture
    reaper
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.kio-extras
    libsForQt5.kfind
    feh

    # PYTHON
    (let 
      custom-packages = python-packages: with python-packages; [ 
        requests
        pyyaml
      ];
      python-with-packages = python3.withPackages custom-packages;
    in
    python-with-packages)
  ];

boot.supportedFilesystems = [ "ntfs" ];

fileSystems = {
  "/home/michael/mnt/windows" = {
    device = "/dev/nvme0n1p3";
    options = ["uid=1000,gid=1000"];
  };
  "/home/michael/mnt/storage" = {
    device = "/dev/sdb2";
    options = ["rw" "uid=1000,gid=1000"];
  };
};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 5000 ];
  networking.firewall.allowedUDPPorts = [ 5000 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

