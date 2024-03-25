{
  description = "Enhanced runtime class redefinition";
  inputs = {nixpkgs.url = "github:NixOS/nixpkgs";};

  outputs = {
    self,
    nixpkgs,
  }: let
    mkDCEVM = {
      system,
      systemType,
      bits,
      baseJdk,
    }: let
      pkgs = import nixpkgs {inherit system;};
    in
      pkgs.stdenv.mkDerivation rec {
        name = "dcevm-1.8";
        version = "1.0.0"; # TODO proper version
        installerDerivation = pkgs.fetchurl {
          url = "https://github.com/dcevm/dcevm/releases/download/light-jdk8u181/DCEVM-8u181-installer.jar";
          hash = "sha256-zo1M7MOLyUCXFOiZOLyBGAOB1MUAA9HH3uL1zGHeMNI=";
        };
        proprietaryJdk = baseJdk;
        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.jdk8
        ];
        src = ./.;

        buildInputs = with pkgs; [
          stdenv.cc.cc
          glib
          cups
          alsa-lib
          fontconfig
          freetype
          cairo
          gtk3
          ffmpeg.lib
          gtk2

          xorg.libX11
          xorg.libXext
          xorg.libXi
          xorg.libXrender
          xorg.libXtst
          xorg.libXxf86vm
          zlib
        ];
        autoPatchelfIgnoreMissingDeps = [
          "libavcodec*.so.*"
          "libavformat*.so.*"
        ];
        buildPhase = ''
          ${pkgs.jdk8}/bin/javac -cp ${installerDerivation} CLIInstaller.java
          tar -xf ${proprietaryJdk}
          ${pkgs.jdk8}/bin/java -cp .:${installerDerivation} CLIInstaller ${systemType} jdk1.8.0_181 ${bits}
        '';
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -R jdk1.8.0_181/* $out/
          runHook postInstall
        '';
      };
  in {
    defaultPackage.x86_64-linux = mkDCEVM {
      system = "x86_64-linux";
      systemType = "LINUX";
      bits = "64";
      baseJdk = nixpkgs.legacyPackages.x86_64-linux.requireFile {
        name = "jdk-8u181-linux-x64.tar.gz";
        url = "https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html";
        sha256 = "sha256-GEVWcJW/v+vULtDQk5eTl5bQVFYpD7IKg8R2ugn5kdM=";
      };
    };
  };
}
