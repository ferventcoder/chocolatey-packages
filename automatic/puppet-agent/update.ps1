import-module au

$releases = 'https://downloads.puppetlabs.com/windows/puppet5/'

function global:au_GetLatest {
	$download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

	$regex = '.msi$'

	$url = $download_page.links | ? href -match $regex | ? href -notmatch 'latest' | select -Last 2 -expand href
	$url32 = $releases + ($url -match 'x86')
	$url64 = $releases + ($url -match 'x64')

	$version = $url -split '-' | select -Index 2

	@{ Version = $version; URL32 = $url32; URL64=$url64 }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
            "(checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

update
