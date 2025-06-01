#/fn
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


;## fflags .jsonc :3 srry

$config=(k(gc -raw -path '.\config.json'))

$t=$config.fflagsJsoncLocation
if(($t -eq $null) -or (!(test-path -path $t))) {
    $config.fflagsJsoncLocation='.\fflags.jsonc';
    $io::writealllines('.\config.json',(json($config)));
}

$t=$config.fflagsJsoncLocation
if(!(test-path -path $t)){w(' <red>!! <white>[<yellow>'+$myinvocation.mycommand+'<white>]\n');return}


$n=k((gc -raw -Path $t)-replace'(?m)(?<=^([^"]|"[^"]*")*)//.*'-replace'(?ms)/\*.*?\*/')
$io::writealllines('.\Modifications\ClientSettings\ClientAppSettings.json',(json($n)))



w(' <white>[<yellow>'+$myinvocation.mycommand+'<white>]\n')

return

