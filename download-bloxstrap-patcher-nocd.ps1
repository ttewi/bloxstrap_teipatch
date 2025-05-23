#cd $env:localappdata\bloxstrap;
function format-json([Parameter(Mandatory, ValueFromPipeline)][String] $json) {$indent = 0;($json -Split "`n" | % {if ($_ -match '[\}\]]\s*,?\s*$') {$indent--};$line = ('  ' * $indent) + $($_.TrimStart() -replace '":  (["{[])', '": $1' -replace ':  ', ': ');if ($_ -match '[\{\[]\s*$') {$indent++};$line}) -Join "`n"};

[IO.File]::WriteAllLines(($pwd).path+"\teipatch.ps1",([System.Net.WebClient]::new()).downloadstring('https://raw.githubusercontent.com/m-ood/.general/main/files/scripts/ps1/teipatch.ps1'));

$s=@{};foreach($a in ((gc -Raw -Path .\settings.json)|ConvertFrom-Json).PSObject.Properties){$s[$a.name]=$a.value};
for ($i=0; $i -lt $s.CustomIntegrations.Length; $i++) {if ($s.CustomIntegrations[$i].name -eq 'teipatch') {$int=1}};
if ($int -eq $null){$s.CustomIntegrations+=(@{Name='teipatch';Location='cmd.exe';LaunchArgs='/c start /min "" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -command "& sp -path ''Registry::HKCR\roblox-player\shell\open\command'' -name ''(Default)'' -value (''cmd.exe /c start /min \""\"" powershell.exe  -WindowStyle Hidden -ExecutionPolicy Bypass -file \""'' + $env:localappdata + ''\bloxstrap\teipatch.ps1\"" \""%1\""'') " ';AutoClose=$false});};
$s.ConfirmLaunches=$false
[IO.File]::WriteAllLines(($pwd).path+"\settings.json",($s|convertto-json));

#($s|convertto-json) | out-file -encoding "ASCII" -NoNewline -Force -FilePath .\settings.json

if ((test-path -path '.\config.json') -eq $false) {[IO.File]::WriteAllLines(($pwd).path+"\config.json",(@{FflagsOverrideLocation='.\fflags.jsonc'}|convertto-json|format-json));};
if ((test-path -path '.\fflags.jsonc') -eq $false) {[IO.File]::WriteAllLines(($pwd).path+"\fflags.jsonc",(gc -Raw -Path .\Modifications\ClientSettings\ClientAppSettings.json));};
sp -path 'Registry::HKCR\roblox-player\shell\open\command' -name '(Default)' -value ('cmd.exe /c start /min "" powershell.exe  -WindowStyle Hidden -ExecutionPolicy Bypass -file "' + $env:localappdata + '\bloxstrap\teipatch.ps1" "%1"')

#$ default mods
if ((test-path -path '.\mods') -eq $false) {
    mkdir mods
    [IO.File]::WriteAllLines(($pwd).path+"\mods\jsonc-fflags.ps1",([System.Net.WebClient]::new()).downloadstring('https://raw.githubusercontent.com/m-ood/.general/main/files/scripts/ps1/jsonc-fflags.ps1'));
    [IO.File]::WriteAllLines(($pwd).path+"\mods\ROBLOX_singletonMutex.ps1",([System.Net.WebClient]::new()).downloadstring('https://raw.githubusercontent.com/m-ood/.general/main/files/scripts/ps1/ROBLOX_singletonMutex.ps1'));

    #([System.Net.WebClient]::new()).downloadstring('https://raw.githubusercontent.com/m-ood/.general/main/files/scripts/ps1/jsonc-fflags.ps1') | out-file -encoding "ASCII" -NoNewline -Force -FilePath .\mods\jsonc-fflags.ps1
    #([System.Net.WebClient]::new()).downloadstring('https://raw.githubusercontent.com/m-ood/.general/main/files/scripts/ps1/ROBLOX_singletonMutex.ps1') | out-file -encoding "ASCII" -NoNewline -Force -FilePath .\mods\ROBLOX_singletonMutex.ps1
}


# [IO.File]::WriteAllLines(($pwd).path+"\",);
# cmd.exe /c start /min "" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -file "C:\Users\memaz\AppData\Local\bloxstrap\teipatch.ps1" "%1"


## iex([System.Net.WebClient]::new()).downloadstring('https://raw.githubusercontent.com/ttewi/bloxstrap_teipatch/refs/heads/main/download-bloxstrap-patcher.ps1');

