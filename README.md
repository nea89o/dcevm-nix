# DCEVM for nix

## Usage

Since old java versions are not allowed to be redistributed, you will need to manually download them first.

Go to download jdk-8u181-linux-x64.tar.gz from https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html

Right now only the linux x64 tarball download is supported and *only* version 1.8u181.

Next, run `nix-store --add-fixed sha256 jdk-8u181-linux-x64.tar.gz` to make nix aware of the downloaded file.

Now you can run `nix build` as normally to build this flake (or any flakes that may depend on this flake).

The `result/` folder will contain your jdk to be used by another project.

Alternatively you can use this flake as you normally would. This still requires the `nix-store` command to be run tho.
