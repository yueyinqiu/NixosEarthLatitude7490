{ pkgs, ... }:
let
  singleFile =
    {
      name,
      version,
      src,
      nugetDeps,
      sdk ? pkgs.dotnetCorePackages.sdk_10_0,
    }:
    let
      project = pkgs.runCommand "${name}-project" { } ''
        mkdir -p "$TMPDIR/dotnet-cli-home"
        export DOTNET_CLI_HOME="$TMPDIR/dotnet-cli-home"

        mkdir -p "$TMPDIR/xdg-data-home"
        export XDG_DATA_HOME="$TMPDIR/xdg-data-home"

        mkdir -p "$TMPDIR/src"
        cp "${src}" "$TMPDIR/src/${name}.cs"

        "${sdk}/bin/dotnet" project convert "$TMPDIR/src/${name}.cs" --output "$out" --interactive False
      '';
    in
    pkgs.buildDotnetModule {
      pname = name;
      version = version;
      src = project;
      dotnet-sdk = sdk;
      dotnet-runtime = sdk;
      projectFile = "${name}.csproj";
      nugetDeps = nugetDeps;
    };
in
{
  _module.args.dotnetBuild = {
    singleFile = singleFile;
  };
}
