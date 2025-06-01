
<#
iex2(@"
[console]::title='* $($n-replace'(?<=.*)\..*$','')\multi'
echo ([console]::title)
mode concols=120lines=30;
if(!(`$m=[threading.mutex]::new(1,('ROBLOX_singletonMutex'))).waitone(0)){return};

add-type @`'
using System;
using System.Runtime.InteropServices;

public class API {

    public enum SW : int {
        Hide=0,
        Normal=1,
        ShowMinimized=2,
        Maximize=3,
        ShowNoActivate=4,
        Show=5,
        Minimize=6,
        ShowMinNoActive=7,
        ShowNA=8,
        Restore=9,
        Showdefault=10,
        Forceminimize=11
    }

    [DllImport("user32.dll",
    EntryPoint="ShowWindow",
    SetLastError=true,
    CharSet=CharSet.Unicode,
    ExactSpelling=true,
    CallingConvention=CallingConvention.StdCall)]

    public static extern int ShowWindow(IntPtr hwnd, SW nCmdShow);
}
`'@


`$h=([system.diagnostics.process]::getcurrentprocess().mainwindowhandle)


#pause



#[api]::ShowWindow(`$h,"show")
#[api]::ShowWindow(`$h,"restore")
mode concols=50lines=15;


sleep 
[api]::ShowWindow(`$h,"hide")






pause
"@)
#>

start powershell -windowstyle hidden {
    mode concols=50lines=15;
    if(![threading.mutex]::new(1,([console]::title='ROBLOX_singletonMutex')).waitone(0)){return};
    pause
};


w(' <white>[<cyan>'+$myinvocation.mycommand+'<white>]\n')

return


