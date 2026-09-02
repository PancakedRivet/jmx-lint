{ pkgs, lib, config, inputs, ... }:

{
  languages.rust = {
    enable = true;
    channel = "nightly";
    components = [ "rustc" "cargo" "clippy" "rust-analyzer" ];
  };
  packages = with pkgs; [
    bacon 
    cargo-seek
    cargo-nextest
    cargo-generate
  ];
  scripts.watcher = {
    exec = ''
        watchexec -c -e rs \
        "cargo clippy && cargo test && cargo run"
    '';
    packages = [ pkgs.watchexec ];
  };
  env.LD_LIBRARY_PATH = lib.makeLibraryPath [
    pkgs.zlib
  ];
  env = {
      DATABASE_URL = "postgres://user:pass@localhost/dbname";
  };
  enterShell = ''
    echo "Crates ready to update with 'cargo update'":
    cargo update -n
  '';
  git-hooks.hooks = {
    clippy.enable = true;
  };
}
