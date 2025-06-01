$host.ui.rawui.BackgroundColor="Black";

# 27 13
mode concols=27lines=13;cd $psscriptroot;
$n=[console]::title=$myinvocation.mycommand;
if(!($mutex=[threading.mutex]::new(1,'て'+$n)).waitone(0)){return};

function w($s) {
    $t=([regex]'(?s)(?:(?:(?<!\\)\<(.+?)\>)|^)?(.+?\n?)(?=(?<!\\)\<|$)').matches(($s -replace'(?<!\\)\\n',"`n"))
    foreach ($h in $t.getenumerator()) {
        #echo $h
        $l=$h.groups[2].value
        $c=$h.groups[1].value
        #echo $g
        if ($c -eq ''){$c='white'}

        #echo $l
        if ($c -eq 'white') {
            write-host -nonewline ($l)
        } else {
            write-host -nonewline -foregroundcolor $c ($l)
        }

    }


    return #$t
}

function iex2($s, $w='hidden') {
    start -windowstyle ($w) -filepath "powershell" -argumentlist @(
        "-Executionpolicy bypass",
        "-NoProfile",
        #"-windowstyle minimized",
        (
            '-command "&{iex(''' + ($s -replace'"','\$0$0'-replace'''','$0$0') + ''')}"'
        )
    )
    return
}


w('<gray> ╔═══════════════════════╗\n ║ <cyan>bloxstrap teipatch :3<gray> ║\n ╚═══════════════════════╝\n\n')

$io=[io.file]
$utf8=[System.Text.Encoding]::UTF8

(ls '.\mods').Name|%{&".\mods\$($_)" "$($args[0])"}
& '.\BloxStrap.exe' -player "$($args[0])"
$($args[0])>.\Logs\uri.txt




#echo finished


#pause
if($args[1] -gt 0){for($i=0;$i -lt 1;){$t=(read-host)}}

$n=$myinvocation.mycommand
iex2(@"
if(!(`$m=[threading.mutex]::new(1,'て$($n)')).waitone(8000)){return}
& "$($pwd)\teipatch-installer.ps1" "8"
#pause
"@)


$mutex.close()



#& ".\teipatch-installer.ps1" "8"
return
