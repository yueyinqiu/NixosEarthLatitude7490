#:sdk Microsoft.NET.Sdk.Web
#:property PublishAot=false
#:package YueYinqiu.Su.DotnetRunFileUtilities@0.0.3

using System.Diagnostics;
using System.Runtime.InteropServices;
using CliWrap;
using CliWrap.Buffered;
using Microsoft.AspNetCore.Mvc;

var socket = "/run/nix-daemon-proxy.sock";
var overrideConf = new FileInfo("/run/systemd/system/nix-daemon.service.d/override.conf");

var builder = WebApplication.CreateBuilder();
builder.WebHost.ConfigureKestrel(options =>
{
    options.ListenUnixSocket(socket);
});
var app = builder.Build();

app.MapPost("/", async ([FromQuery] string proxy = "") =>
{
    await File.WriteAllTextAsync(overrideConf.FullName,
        $"""
        [Service]
        Environment="all_proxy={proxy}"
        Environment="http_proxy={proxy}"
        Environment="https_proxy={proxy}"
        Environment="ALL_PROXY={proxy}"
        Environment="HTTP_PROXY={proxy}"
        Environment="HTTPS_PROXY={proxy}"
        """
    );
    await Cli.Wrap("systemctl").WithArguments(["daemon-reload"]).ExecuteBufferedAsync();
    await Cli.Wrap("systemctl").WithArguments(["restart", "nix-daemon"]).ExecuteBufferedAsync();
});
app.Lifetime.ApplicationStarted.Register(async () =>
{
    Debug.Assert(RuntimeInformation.IsOSPlatform(OSPlatform.Linux));
    File.SetUnixFileMode(socket, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.GroupRead | UnixFileMode.GroupWrite);
    await Cli.Wrap("chown").WithArguments(["root:nix-daemon-proxy", socket]).ExecuteBufferedAsync();
});

overrideConf.Directory?.Create();
if (File.Exists(socket))
    File.Delete(socket);

app.Run();