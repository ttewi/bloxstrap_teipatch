$host.ui.rawui.BackgroundColor="Black";cd $PSScriptRoot;$global:args=$args;

(ls '.\mods').Name|%{&".\mods\$($_)" "$($global:args[0])"}
& '.\BloxStrap.exe' -player "$($args[0])"
$($args[0])>.\Logs\uri.txt

echo finished

pause
return
