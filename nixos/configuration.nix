# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      /etc/nixos/cachix.nix
    ];

  nix = {
    settings = {
      auto-optimise-store = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        extraEntries = ''
          menuentry "UEFI Firmware Settings" {
            fwsetup
          }
        '';
        theme = pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        };
      }; 
    };
  };

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8 * 1024;
  } ];

  services = {
    earlyoom = {
      enable = true;
      freeSwapThreshold = 8;
      freeMemThreshold = 8;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" "nvidia" ];
      excludePackages = with pkgs; [ xterm ];
      desktopManager.xfce.enable = true;
      xkb = {
        layout = "us";
        options = "caps:escape";
      };
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "NixOS Samba Server";
          "netbios name" = "NIXOS";
          "security" = "user";
          "map to guest" = "Bad User";
          "guest account" = "nobody";
        };
        "public" = {
          path = "/mnt/Shares/Public";
          browseable = "yes";
          "guest ok" = "yes";
          "guest only" = "yes";
          "read only" = "no";
          "create mask" = "0777";
          "directory mask" = "0777";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "enfyna";
    };
    gnome.gnome-keyring.enable = true;
  };

  networking = {
    # networking.hostName = "nixos"; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    hosts = {
      "192.168.1.130" = [ "note5" ];
      "192.168.1.138" = [ "rmp.screen" ];
      "127.0.0.1" = [ "play.game.local" "media.game.local" "old.game.local" "legacy.game.local" ];
    };

    firewall.allowedTCPPorts =  [ 80 6112 7002 ]; 
    # firewall.allowedUDPPorts = [ ... ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # https://nixos.wiki/wiki/Nvidia
  hardware = {
    graphics = { 
      enable = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        sync.enable = true;
        # sudo lshw -c display
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # https://discourse.nixos.org/t/missing-man-pages/4680
  documentation = {
    enable = true;
    dev.enable = true;
    man.enable = true;
    man.generateCaches = false;
  }; 

  # https://wiki.nixos.org/wiki/Docker#Rootless_Docker
  virtualisation.docker = {
    enable = true;
    rootless.enable = false;
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
    daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
        registry-mirrors = [ "https://mirror.gcr.io" ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;	
  };

  programs = {
    thunar.plugins = with pkgs.xfce; [ 
      thunar-media-tags-plugin
      thunar-archive-plugin
      thunar-volman
    ];
    seahorse.enable = true;
    bash.completion.enable = true;
    nm-applet.enable = true;
    firefox.enable = true;
    ladybird.enable = true;
    chromium.enable = true;
    git.enable = true;
    # unity3d.enable = true; # next time try this instead of unityhub
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    obs-studio = {
      enable = true;
      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi #optional AMD hardware acceleration
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    coreutils binutils file lshw lsof pciutils pkg-config cpulimit bc usbutils iptables
    clang-tools clang gcc gdb gnumake bear gource
    linux-manual man-pages man-pages-posix
    unzip unrar p7zip wget curl ffmpeg tmux skim vim
    nodejs_24 python3 python311 cargo dotnet-sdk omnisharp-roslyn mono
    nmap lynx vlc gdu htop tree fzf
    xarchiver
    playerctl
    gparted
    appimage-run
    xdotool

    # gcc-arm-embedded 
    # libgcc 
    # glibc_multi
    # # nixpkgs.pkgsi686Linux
    cmake 
    # newlib
    # # libstdc++-arm-none-eabi-newlib

    dbeaver-bin

    quickemu

    nix-index cachix

    figlet

    zuki-themes xfce.xfwm4-themes vimix-icon-theme afterglow-cursors-recolored
    # neovim
    ripgrep fd xclip
  ];

  users.users.enfyna = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "dialout" ];
    # dialout: for serial devices (ttyS0, ttyUSB0, ...)
    packages = with pkgs; [
      wezterm fastfetch gh tea vscode
      kdePackages.kdenlive
      scrcpy
      screenkey
      nix-search
      chromium
      yt-dlp
      arduino-ide arduino-language-server arduino-cli
      firebase-tools
      libnotify

      normalize

      (import ./xfce-prayer-times.nix { inherit pkgs; })
      xfce.xfce4-cpugraph-plugin
      xfce.xfce4-whiskermenu-plugin
      xfce.xfce4-clipman-plugin
      xfce.xfce4-netload-plugin
      xfce.xfce4-systemload-plugin
      xfce.xfce4-xkb-plugin

      xppen_4

      (blender.override { cudaSupport = true; }) 
      gimp
      krita
      unityhub # next time try using programs.unity3d
      godot-mono 
      android-tools sdkmanager
    ];
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

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
