
<#
if (!([security.principal.windowsprincipal][security.principal.windowsidentity]::
getcurrent()).isinrole([security.principal.windowsbuiltinrole]::administrator)) {
    start -windowstyle normal -verb runas -filepath "powershell" -argumentlist @(
        "-Executionpolicy bypass",
        (
            '-command "cd ' + $pwd + ';& \""' + $pscommandpath + '\"""'
        )
    )
    pause
    return
}
#>

#/ functions and stuffs
    if ((test-path -path ($psscriptroot+'\'+$myinvocation.mycommand)) -eq $true){$name=$myinvocation.mycommand.name}else{$name='teipatch-installer.ps1'}

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

    mode concols=120lines=30;#cd $psscriptroot;
    $n=[console]::title=$name;
    if(!($m=[threading.mutex]::new(1,'て'+$n)).waitone(0)){w('<red>!!\n');return};




    function k($s){
        $h=@{}
        $f=@{} #[hashtable]::new()
        foreach($t in ($s|ConvertFrom-Json).psobject.properties){
            $a=$t.name;$b=$t.value;
            $h[$a]=$f[$a]=$b
        }
        $n=l($s)


        foreach ($t in $h.getenumerator()) {
            $a=$t.name;$b=$t.value;
            if ($b.length -eq $null) {$f[$a]=$n[$a]}
        }


        return $f
    };
    add-type -assemblyname 'System.Web.Extensions'
    function l([string]$s) {
        $parser = New-Object Web.Script.Serialization.JavaScriptSerializer
        $parser.MaxJsonLength = $s.length
        Write-Output -NoEnumerate $parser.Deserialize($s, [hashtable])

        #Write-Output -NoEnumerate $parser.DeserializeObject($s)
        #return $parser.Deserialize($s, [hashtable])
        # To deserialize to a dictionary, use $parser.DeserializeObject($text) instead
    }
    function format-json([Parameter(Mandatory, ValueFromPipeline)][String] $json) {
        $indent = 0;
        ($json -Split "`n" | % {
            if ($_ -match '[\}\]]\s*,?\s*$') {$indent--};
            $line = ('  ' * $indent) + $($_.TrimStart() -replace '":  (["{[])', '": $1' -replace ':  ', ': ');
            if ($_ -match '[\{\[]\s*$') {$indent++};
            $line
        }) -Join "`n"
    };
    function json($o){return ($o|convertto-json|format-json)}

# write-host -foregroundcolor 'darkgray' ('')
# w('')

#/ $td


    $td="$($env:localappdata)\bloxstrap"
    #$td+='\a'
    if (!(test-path -path $td)) {
        w('<yellow>' + $td + ' might not exist\n<gray>manual bloxstrap folder input srry: ')
        
        $td=read-host
        w('\n\n')
    }



    w('<gray>'+$name+'<darkcyan> => <gray>'+$td+'\blockstrap.exe')

    if (!(test-path -path ($td+'\bloxstrap.exe'))) {
        w('<red> !!\n\n')
        #sleep 3;return $m.close();
        pause
        $m.close()
    }

    w('<cyan> '+[char]0x221a+'\n\n')



    cd $td
    

## bloxstrap teipatch installer


$io=[io.file]
$utf8=[System.Text.Encoding]::UTF8
$cwd=($pwd).path
$wc=([System.Net.WebClient]::new())
$ce=(test-path -path "$($cwd)\config.json")
$server=k($wc.downloadstring('https://raw.githubusercontent.com/ttewi/bloxstrap_teipatch/refs/heads/main/config.json'))


#? config
if($ce -eq $false){$io::writealllines("$($cwd)\config.json",(json(@{})),$utf8)};
$config=(k(gc -raw -path "$($cwd)\config.json"))
if(!($config.containskey('meta'))){$config.meta=@{version=0}}




#/ $config.meta
    w('<darkgray>$config.meta<yellow> => ')
    $i=0
    foreach ($t in $server.meta.getenumerator()) { # .getenumerator()
        $a=$t.key
        $b=$t.value


        if (!($config.meta.containskey($a))){ # .containskey($a)
            if(!($i -eq 0 )){w('<gray>, ')}
            w('<gray>'+$a)
            $config.meta[$a]=$b
            $i++
        }
    }
    $p=''
    $t='yellow'
    if ($i -ne 0) {
        $p=' '
        $t='red'
    }

    w('<'+$t+'>'+$p+[char]0x25a0+'\n')





#/ settings
    $settings=(k(gc -raw -path "$($cwd)\settings.json"))

    $s='teipatch'
    $t=$null
    for ($a=0;$a -lt $settings.customintegrations.length;$a++) {
        $b=$settings.customintegrations[$a]
        if ($b.name -eq $s){$t=$b;break;}
    }

    $c='yellow'
    w('<darkgray>$settings.customintegrations<yellow> => ')
    if ($t -eq $null) {
        $c='cyan'
        $settings.customintegrations+=(@{
            Name='teipatch';
            Location='cmd.exe';
            LaunchArgs='/cstart/min "" powershell -WindowStyle Hidden -ExecutionPolicy'+
            ' Bypass -command "& si -path ''Registry::HKCR\roblox-player\shell\open\co'+
            'mmand'' -value (''cmd /cstart/min \""\"" powershell -windowstyle hidden -'+
            'executionpolicy bypass -file \""'+$cwd+'\teipatch.ps1\"" \""%1\""'') "'
            AutoClose=$false
        })
    }
    w('<'+$c+'>teipatch\n\n')


#? teipatch protocol sry
si -path 'Registry::HKCR\roblox-player\shell\open\command' -value ('cmd /cstart/min "" powershell -windowstyle hidden -executionpolicy bypass -file "'+$cwd+'\teipatch.ps1" "%1"')





$s=@"
mode concols=50lines=15
if(!(`$m=[threading.mutex]::new(1,'て$($name)')).waitone(8000)){return}
#pause

`$t='https://raw.githubusercontent.com/ttewi/bloxstrap_teipatch/refs/heads/main/teipatch-installer.ps1'
[io.file]::writealllines('$($cwd)\teipatch-installer.ps1',([System.Net.WebClient]::new()).downloadstring(`$t),[System.Text.Encoding]::UTF8)
#pause
"@

#$config.meta.version=0

w('<darkgray>$config.meta.version <yellow>@ '+$config.meta.version+"\n")



if ($config.meta.version -lt $server.meta.version) {


    $t='https://raw.githubusercontent.com/ttewi/bloxstrap_teipatch/refs/heads/main/teipatch.ps1'
    $io::writealllines("$($cwd)\teipatch.ps1",$wc.downloadstring($t),$utf8);
    w('<darkgray>.\teipatch.ps1<yellow> => <cyan>'+$p+[char]0x25a0+'\n')


    w('<darkgray>.\mods<yellow> => ')
    $c='yellow';$p=''

    md "$($cwd)\mods"
    $t='https://api.github.com/repos/ttewi/bloxstrap_teipatch/contents/mods'
    foreach ($t in (((iwr ($t) -usebasicparsing).content)|convertfrom-json).getenumerator()) {
        $c='cyan';$p=' '
        $h=$t.name
        $io::writealllines(("$($cwd)\mods\"+$h),$wc.downloadstring($t.download_url),$utf8)
        w('<gray>'+$h+' ')
    }
    w('<'+$c+'>'+$p+[char]0x25a0+'\n')

    start -windowstyle normal -filepath "powershell.exe" -argumentlist @(
        "-Executionpolicy bypass",
        "-NoProfile",
        (
            '-command "&{iex(''' + ($s -replace'"','\$0$0'-replace'''','$0$0') + ''')}"'
        )
    )
    
    $config.meta.version=$server.meta.version
    
}


$io::writealllines("$($cwd)\config.json",(json($config)))
$io::writealllines("$($cwd)\settings.json",(json($settings)))


#pause
$m.close()
if(!($args[0] -gt 0)){
    start -windowstyle normal -filepath "powershell.exe" -argumentlist @(
        "-Executionpolicy bypass",
        (
            '-file "'+$cwd+'\teipatch.ps1" "" "8"'
        )
    )
}


return





<#

iex([net.webclient]::new()).downloadstring('https://raw.githubusercontent.com/ttewi/bloxstrap_teipatch/refs/heads/main/teipatch-installer.ps1')
iex((gc -raw -path 'C:\Users\memaz\AppData\Local\Bloxstrap\teipatch-installer.ps1'))

#>