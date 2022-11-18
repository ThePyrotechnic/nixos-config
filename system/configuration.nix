# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vmware.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.kernelModules = [ "kvm-amd" ];
  
  virtualisation.libvirtd.enable = true;

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
      noto-fonts
      noto-fonts-emoji noto-fonts-emoji-blob-bin
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
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

    EDITOR =	   "vim";
 };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_US/ISO-8859-1"
    "ja_JP.EUC-JP/EUC-JP"
    "ja_JP.UTF-8/UTF-8"
  ];
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ mozc ];
  };

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
      Option         "metamodes" "DP-2: 2560x1440_144 +0+0, DP-0: 2560x1440_144 +0+1440"
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

  xdg.mime.defaultApplications = {
    "inode/directory" = "org.kde.dolphin.desktop";
  };

  hardware.nvidia.nvidiaSettings = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudio.override { jackaudioSupport = true; };

    extraConfig = ''
      load-module module-udev-detect tsched=0
    '';

    daemon = {
      config = {
        high-priority = "yes";
        nice-level = -15;
        realtime-scheduling = "yes";
        realtime-priority = 50;
        resample-method = "speex-float-0";
        default-fragments = 2;
        default-fragment-size-msec = 2;
      };
    };
  };
 
  services.jack = {
    jackd.enable = true;
    alsa.enable = true;
    loopback = {
      enable = false;
    };
    jackd.extraOptions = [ "-dalsa" "--device" "hw:MK2" "--rate" "48000" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.groups = { 
    webdirs = {
      members = [ "michael" "nginx" ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michael = {
    isNormalUser = true;
    initialPassword = "1234asdf";
    extraGroups = [ "wheel" "jackaudio" "audio" "docker" "nginx" "libvirtd" ];
  };
 
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.steam = {
    enable = true;
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  programs.kdeconnect = {
    enable = true;
  };

  programs.java.enable = true;

  programs.git = {
    enable = true;
    config = {
      credential.helper = "libsecret";
      user.name = "Michael Manis";
      user.email = "michaelmanis@tutanota.com";
      user.signingkey = "0F9BB19D64F8154D";
      init.defaultBranch = "master";
    };
  };

  programs.ssh.startAgent = true;

  programs.gnupg = {
    agent.enable = true;
    agent.pinentryFlavor = "curses";
  };

  security.acme.acceptTerms = true;  
  security.acme.defaults.email = "michaelmanis@tutanota.com";
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

  services.gnome.gnome-keyring.enable = true;

  systemd.services.nginx.serviceConfig.ReadOnlyPaths = "/var/www";

  services.mullvad-vpn.enable = true;

  services.unifi = {
    enable = true;
  };

  services.nginx = {
    enable = true;
    
    logError = "stderr debug";

    additionalModules = [ pkgs.nginxModules.rtmp ];

    virtualHosts = {
      "live.michaelmanis.com" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 5000;
            ssl = true;
          }
        ];

        forceSSL = true;
        useACMEHost = "michaelmanis.com";
        
        extraConfig = ''
          root /var/www/stream;
        '';
      };

      "stream.michaelmanis.com" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 5000;
            ssl = true;
          }
        ];
        
        forceSSL = true;
        useACMEHost = "michaelmanis.com";

        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8080$request_uri";
          };
        };
      };

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

        
      extraConfig = ''
         root /var/www/5etools-mirror-1.github.io;
         add_header 'Access-Control-Allow-Origin' 'https://foundry.michaelmanis.com:5000';
         add_header 'Access-Control-Allow-Methods' 'GET,OPTIONS'; 
        '';
      };

      "192.168.1.195" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 5001;
            ssl = false;
          }
        ];

        extraConfig = ''
          root /var/www/local;
          autoindex on;
        '';
      };

      "foundry.michaelmanis.com" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 5000;
            ssl = true;
          }
        ];

        forceSSL = true;
        useACMEHost = "michaelmanis.com";
        
        extraConfig = ''
          ssl_ciphers               HIGH:!aNULL:!MD5;
          ssl_session_timeout       5m;
          ssl_session_cache         shared:SSL:1m;
          ssl_prefer_server_ciphers on;

          client_max_body_size 300M;
        '';       
 
        locations = {
          "/" = {
            proxyPass = "http://localhost:30000";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
            '';
          };
        };
      };
    };
  };

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # CORE
    ((vim_configurable.override {  }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix vim-lastplace ];
        opt = [];
      };
      vimrcConfig.customRC = ''
        set nocompatible
        set backspace=indent,eol,start
        syntax on
      '';
      }
    )
    wget
    firefox
    i3
    dolphin breeze-icons filelight kdf partition-manager
    gparted
    steam-run
    deluge
    zip unzip p7zip
    git git-crypt
    pinentry-qt
    gnumake
    cmake
    openssh
    nodejs
    cmake
    gcc
    mullvad

    # FUN
    dolphin-emu
    frotz
    devilutionx
    lutris
    xivlauncher
    heroic
    legendary-gl
    mupen64plus
    osu-lazer
    prismlauncher
    
    # MESSAGING
    discord
    tdesktop
    signal-desktop 
 
    # TERM
    rxvt-unicode
    powershell
    
    # TEXT
    vscode-fhs
    
    # UTIL
    fontpreview
    fontforge-gtk
    psmisc
    xorg.xprop
    xorg.xev
    xclip
    pavucontrol
    usbutils
    pciutils
    nginx
    awscli
    tiny
    wineWowPackages.staging winetricks protontricks protonup
    yabridge yabridgectl
    psensor
    mitmproxy
    xdotool
    rustc
    nss
    aria
    smem
    gnome.zenity
    p7zip
    rar
    pick-colour-picker
    libimobiledevice
    usbmuxd
    ifuse
    mslink
    trickle
    linuxKernel.packages.linux_5_15.v4l2loopback
    sdl-jstest
    kubectl
    minikube
    kubernetes-helm
    xdelta
    dmidecode
    lm_sensors
    psensor
    drawio
    kmag
    libreoffice
    unixtools.ifconfig
    jq
    virt-manager
    llvmPackages_8.libunwind

    # MEDIA
    mpv
    spotify
    audacity
    scrot
    (
      wrapOBS.override { obs-studio = pkgs.obs-studio; } {
        plugins = with pkgs.obs-studio-plugins; [
          obs-vkcapture
        ];
      }
    )
    qjackctl jack_capture
    reaper
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.kio-extras
    libsForQt5.kfind
    feh
    ffmpeg
    kdenlive
    mixxx
    krita
    gimp
    okular
    pulsemixer
    inkscape
    (lowPrio helm)  # synthesizer
    streamlink
    anki-bin
    darktable
    rawtherapee
    exiftool
    imagemagick
    photon-rss

    # PYTHON
    (let 
      custom-packages = python-packages: with python-packages; [ 
        requests
        pyyaml
        waitress
        flask
      ];
      python-with-packages = python3.withPackages custom-packages;
    in
    python-with-packages)
  ];

boot.supportedFilesystems = [ "ntfs" ];

fileSystems = {
  "/winstorage" = {
    device = "/dev/disk/by-label/WinStorage";
    options = ["rw" "uid=1000,gid=1000"];
  };
  "/windows" = {
    device = "/dev/nvme0n1p3";
    options = ["rw" "uid=1000,gid=1000"];
  };
  "/storage" = {
    device = "/dev/disk/by-label/Storage";
    fsType = "ext4";
  };
  "/nvmestorage" = {
    device = "/dev/disk/by-label/NVMeStorage";
    fsType = "ext4";
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
  services.openssh = {
    enable = true;
    ports = [ 666 ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 25565 30000 5000 9994 9995 ];
  # networking.firewall.allowedUDPPorts = [ 25565 30000 5000 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

