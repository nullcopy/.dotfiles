{ pkgs, ... }:

let
  # CLI for the Keystone ForgeBox, packaged from source and pinned to
  # master (upstream tags lag package.json). To bump: new rev, clear both
  # hashes, copy the hashes from the failed rebuild.
  forgebox-cli = pkgs.buildNpmPackage {
    pname = "forgebox-cli";
    version = "1.2.0";

    src = pkgs.fetchFromGitHub {
      owner = "KeystoneHQ";
      repo = "forgebox-cli";
      rev = "9b26ddebccb14a8eef970b3ad2c95952d21a8c91";
      hash = "sha256-LBe+CghXqhTLmoA5MddUhlKYZjeuNsw6mIdZeJUT5EE=";
    };

    npmDepsHash = "sha256-HZrOz0BorXKnkaAj0Ee5LEUPC2gcapjUrC028BYQRUc=";

    nativeBuildInputs = with pkgs; [
      python3
      pkg-config
    ];

    # The `usb` dependency ships glibc prebuilds that expect /usr/lib
    # libudev; node-gyp compiles it against nix libs so the rpath points
    # into the store.
    buildInputs = with pkgs; [
      libusb1
      systemd
    ];
    npm_config_build_from_source = "true";
  };
in
pkgs.mkShell {
  packages = [ forgebox-cli ];
}
