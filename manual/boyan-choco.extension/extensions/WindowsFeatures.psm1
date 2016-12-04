function InstallIIS() {
    echo 'Installing IIS and Windows Features'

    if ([System.Environment]::OSVersion.Version.Major -eq 6){
        InstallWindows7IIS
    }
    else {
        # .NET and extensibility
        InstallWindowsFeature NetFx3
        InstallWindowsFeature NetFx4Extended-ASPNET45

        # Web server
        InstallWindowsFeature IIS-WebServer

        # ASP.NET
        InstallWindowsFeature IIS-ASPNET
        InstallWindowsFeature IIS-ASPNET45
    }

    # IIS modules
    choco install UrlRewrite -y
    choco install IIS-ARR -y
}

function InstallWindowsFeature([string] $featureName) {
    $feature = Get-WindowsOptionalFeature -FeatureName $featureName -Online

    if ($feature.State -ne 'Enabled') {
        echo "Enabling $featureName"
        Enable-WindowsOptionalFeature -FeatureName $featureName -Online -All
    }
    else {
        echo "$featureName Enabled...Skipping"
    }
}

function InstallWindows7IIS() {
    try {
        choco uninstall IIS-IIS6ManagementCompatibility -y -source WindowsFeatures
        choco uninstall IIS-Metabase -y -source WindowsFeatures
        choco install NetFx3 -y -source WindowsFeatures
        choco install IIS-WebServerRole -y -source WindowsFeatures
        choco install IIS-WebServer -y -source WindowsFeatures
        choco install IIS-CommonHttpFeatures -y -source WindowsFeatures
        choco install IIS-HttpErrors -y -source WindowsFeatures
        choco install IIS-HttpRedirect -y -source WindowsFeatures
        choco install IIS-ApplicationDevelopment -y -source WindowsFeatures
        choco install IIS-NetFxExtensibility -y -source WindowsFeatures
        choco install IIS-NetFxExtensibility45 -y -source WindowsFeatures
        choco install IIS-HealthAndDiagnostics -y -source WindowsFeatures
        choco install IIS-HttpLogging -y -source WindowsFeatures
        choco install IIS-LoggingLibraries -y -source WindowsFeatures
        choco install IIS-RequestMonitor -y -source WindowsFeatures
        choco install IIS-HttpTracing -y -source WindowsFeatures
        choco install IIS-Security -y -source WindowsFeatures
        choco install IIS-URLAuthorization -y -source WindowsFeatures
        choco install IIS-RequestFiltering -y -source WindowsFeatures
        choco install IIS-IPSecurity -y -source WindowsFeatures
        choco install IIS-Performance -y -source WindowsFeatures
        choco install IIS-HttpCompressionDynamic -y -source WindowsFeatures
        choco install IIS-WebServerManagementTools -y -source WindowsFeatures
        choco install IIS-ManagementScriptingTools -y -source WindowsFeatures
        choco install IIS-CertProvider -y -source WindowsFeatures
        choco install IIS-WindowsAuthentication -y -source WindowsFeatures
        choco install IIS-DigestAuthentication -y -source WindowsFeatures
        choco install IIS-ClientCertificateMappingAuthentication -y -source WindowsFeatures
        choco install IIS-IISCertificateMappingAuthentication -y -source WindowsFeatures
        choco install IIS-ODBCLogging -y -source WindowsFeatures
        choco install IIS-StaticContent -y -source WindowsFeatures
        choco install IIS-DefaultDocument -y -source WindowsFeatures
        choco install IIS-DirectoryBrowsing -y -source WindowsFeatures
        choco install IIS-WebDAV -y -source WindowsFeatures
        choco install IIS-WebSockets -y -source WindowsFeatures
        choco install IIS-ApplicationInit -y -source WindowsFeatures
        choco install IIS-ASPNET -y -source WindowsFeatures
        choco install IIS-ASPNET45 -y -source WindowsFeatures
        choco install IIS-ASP -y -source WindowsFeatures
        choco install IIS-CGI -y -source WindowsFeatures
        choco install IIS-ISAPIExtensions -y -source WindowsFeatures
        choco install IIS-ISAPIFilter -y -source WindowsFeatures
        choco install IIS-ServerSideIncludes -y -source WindowsFeatures
        choco install IIS-CustomLogging -y -source WindowsFeatures
    }
    catch {
    }
}

Export-ModuleMember *