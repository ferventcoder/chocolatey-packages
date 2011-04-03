param ($Script = $(throw "Script parameter is required"))

function Get-ProcessorArchitecture
{
    $processor = Get-WmiObject Win32_Processor
    
    switch ($processor.Architecture)
    {
        0 { return "x86" }
        1 { return "MIPS" }
        2 { return "Alpha" }
        3 { return "PowerPC" }
        6 { return "Itanium" }
        9 { return "x64" }
    }
}

function Get-WindowsVersion
{
    switch ([Environment]::OSVersion.Platform)
    {
        "Win32NT" {
            switch ([Environment]::OSVersion.Version.Major)
            {
                5 {
                    switch ([Environment]::OSVersion.Version.Minor)
                    {
                        0 { return "Windows 2000" }
                        1 { return "Windows XP" }
                        2 { return "Windows 2003" }
                    }
                }
                
                6 {
                    switch ([Environment]::OSVersion.Version.Minor)
                    {
                        0 { return "Windows Vista" }
                        1 { return "Windows 7" }
                    }
                }
            }
        }
    }
}

# execute the file
& $Script