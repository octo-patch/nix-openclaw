{
  lib,
  stdenvNoCC,
  jq,
  openclawPackage,
}:

lock:

let
  packageName = "openclaw-runtime-plugin-${lock.id}";
  drv = stdenvNoCC.mkDerivation {
    pname = packageName;
    version = lock.version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [ jq ];

    env = {
      OPENCLAW_BUNDLED_PLUGIN_ID = lock.id;
      OPENCLAW_BUNDLED_PLUGIN_PATH = lock.bundledPath;
      OPENCLAW_GATEWAY_PACKAGE = openclawPackage;
    };

    installPhase = "${../scripts/install-openclaw-bundled-runtime-plugin.sh}";

    passthru.openclawRuntimePlugin = {
      inherit (lock) id version packageName;
      source = "bundled";
      loadPath = drv;
    };

    meta = with lib; {
      description = "Nix-packaged bundled OpenClaw runtime plugin ${lock.id}";
      homepage = "https://github.com/openclaw/openclaw";
      license = licenses.mit;
      platforms = platforms.darwin ++ platforms.linux;
    };
  };
in
drv
