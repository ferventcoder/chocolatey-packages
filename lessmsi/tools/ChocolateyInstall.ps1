Install-ChocolateyZipPackage 'lessmsi' `
	'http://lessmsi.googlecode.com/files/lessmsi-v1.0.9.zip' `
	"$(Split-Path -parent $MyInvocation.MyCommand.Definition)"