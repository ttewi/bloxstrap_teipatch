$host.ui.rawui.BackgroundColor="Black";

mode concols=96lines=30;cd $psscriptroot;
$n=[console]::title=$myinvocation.mycommand;
if(!($m=[threading.mutex]::new(1,'て'+$n)).waitone(0)){return};

(ls '.\mods').Name|%{&".\mods\$($_)" "$($args[0])"}
& '.\BloxStrap.exe' -player "$($args[0])"
$($args[0])>.\Logs\uri.txt

echo finished

#pause

$m.close()
return