<#
    .SYNOPSIS
    Lists or applies Windows Images in .WIM containers.
    
    .PARAMETER WIM
    Specifies the .WIM file to examine and/or apply images from.
    
    .PARAMETER Apply
    Specifies that the specified image index should be applied to the specified Destination.
    
    .PARAMETER Index
    Specifies the image index of the Windows Image to apply to the specified Destination.
    
    .PARAMETER Destination
    The drive or folder to apply the specified Windows Image to.
    
    .EXAMPLE
    This example will list the available images in the D:\Sources\Install.wim container.
    
    .\Install-WindowsImage.ps1 -WIM D:\Sources\Install.wim
    
    .EXAMPLE
    This example will apply image number 8 from D:\Sources\Install.wim to X:\.
    
    .\Install-WindowsImage.ps1 -WIM D:\Sources\Install.wim -Apply -Index 8 -Destination X:\    

    .Notes 
        NAME:      Install-WindowsImage.ps1
        AUTHOR:    NTDEV\mikekol 
        LASTEDIT:  04/17/2009 11:18:00 AM 
#>

#Requires -Version 2.0 

[CmdletBinding(DefaultParameterSetName = "list")]
param(
    [Parameter(
        Mandatory         = $true,
        ValueFromPipeline = $true)]
    [string]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path $_ })]     
    $WIM,
    
    [Parameter(
        ParameterSetName = "apply",
        Mandatory        = $true)]
    [Switch]
    $Apply,
    
    [Parameter(
        ParameterSetName = "apply",
        Mandatory        = $true)]
    [int]
    [ValidateNotNullOrEmpty()]
    [ValidateRange(1,16)]
    $Index,
    
    [Parameter(
        ParameterSetName  = "apply",
        Mandatory         = $true)]
    [string]
    [validateNotNullOrEmpty()]
    [ValidateScript({ Test-Path $_ })]
    $Destination
)

$ImagingAPIDefinition = @"
using System;
using System.Collections;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Xml;

namespace Microsoft.WimgApi
{
    public interface
    IImage
    {
        XmlDocument ImageInformation
        {
            get;
        }

        string
        ImageName
        {
            get;
        }

        ulong
        ImageSize
        {
            get;
        }

        string
        ImageArchitecture
        {
            get;
        }

        string
        ImageLanguage
        {
            get;
        }

        Version
        ImageVersion
        {
            get;
        }

        string
        ImageDisplayName
        {
            get;
        }

        string
        ImageDisplayDescription
        {
            get;
        }

        void
        Apply(
            string pathToApplyTo
        );
    }

    public sealed class
    WindowsImageContainer : IDisposable
    {
        public enum
        CreateFileAccess
        {
            Read,
            Write
        }

        public enum
        CreateFileMode
        {
            ReservedDoNotUse = 0,
            CreateNew = 1,
            CreateAlways = 2,
            OpenExisting = 3,
            OpenAlways = 4
        }

        public
        WindowsImageContainer(
            string imageFilePath)
            : this(imageFilePath, CreateFileMode.OpenExisting, CreateFileAccess.Read)
        { }

        public
        WindowsImageContainer(
            string imageFilePath,
            CreateFileMode mode,
            CreateFileAccess access)
        {
            CreateFileAccessPrivate fileAccess = GetMappedFileAccess(access);
            if (fileAccess == CreateFileAccessPrivate.Read &&
                (!File.Exists(imageFilePath) ||
                    (CreateFileMode.OpenExisting != mode)))
            {
                throw new System.UnauthorizedAccessException(
                    string.Format(
                        CultureInfo.CurrentCulture,
                        "Read access can be specified only with OpenExisting mode or OpenAlways mode when the .wim file does not exist."));
            }

            //
            //Imaging DLLs must be in the same directory.
            //
            try
            {
                m_ImageContainerHandle = NativeMethods.CreateFile(
                    imageFilePath,
                    (uint)fileAccess,
                    (uint)mode);
                m_WindowsImageFilePath = imageFilePath;
            }
            catch (System.DllNotFoundException ex)
            {
                throw new System.DllNotFoundException(
                    string.Format(
                        CultureInfo.CurrentCulture,
                        "Unable to load WIM libraries. Make sure the correct DLLs are present (Wimgapi.dll and Xmlrw.dll)."),
                    ex.InnerException);
            }

            if (!m_ImageContainerHandle.Equals(IntPtr.Zero))
            {
                //
                //Set the temporary path so that we can write to an image. This
                //cannot be %TEMP% as it does not exist on Windows PE
                //
                string tempDirectory = System.Environment.GetEnvironmentVariable("systemdrive");
                NativeMethods.SetTemporaryPath
                    (m_ImageContainerHandle,
                    tempDirectory);

            }
            else
            {
                //
                //Throw an exception
                //
                throw new System.InvalidOperationException(
                    string.Format(
                        CultureInfo.CurrentCulture,
                        "Unable to open  the .wim file {0}.",
                        imageFilePath));
            }

            m_ImageCount = NativeMethods.GetImageCount(m_ImageContainerHandle);
        }

        ///<summary> Destructor to close open handles.</summary>
        ~WindowsImageContainer()
        {
            DisposeInner();
        }

        public void
        Dispose()
        {
            DisposeInner();
            GC.SuppressFinalize(this);
        }

        private void
        DisposeInner()
        {
            // Get rid of the images that we may have loaded.
            for (int i = (m_ImageCount - 1); i >= 0; i--)
            {
                if (m_Images[i] != null)
                {
                    m_Images[i].Dispose();
                    m_Images[i] = null;
                }
            }

            if (m_ImageContainerHandle != IntPtr.Zero)
            {
                NativeMethods.CloseHandle(m_ImageContainerHandle);
                m_ImageContainerHandle = IntPtr.Zero;
            }

            GC.KeepAlive(this);
        }

        public IImage
        this[int imageIndex]
        {
            //TODO: ArrayList doesn't seem to perform terribly well. 
            //      Investigate using a more efficient data structure

            get
            {
                if (m_Images == null)
                {
                    // Create the array with empty entries
                    ArrayList tempImages = new ArrayList(m_ImageCount);
                    for (int i = 0; i < m_ImageCount; i++)
                    {
                        tempImages.Add(null);
                    }
                    m_Images = (WindowsImage[])tempImages.ToArray(typeof(WindowsImage));
                }

                // We don't have the image we're being asked about.
                if (m_Images[imageIndex] == null)
                {
                    // The array is already set up for us.
                    ArrayList tempImages = new ArrayList(m_ImageCount);
                    for (int i = 0; i < m_ImageCount; i++)
                    {
                        // Load the image from the container.
                        if (i == imageIndex)
                        {
                            tempImages.Add(new WindowsImage(m_ImageContainerHandle, m_WindowsImageFilePath, imageIndex + 1));
                        }
                        else
                        {
                            // Make sure that we preserve the images that we've already loaded.
                            if (m_Images[i] != null)
                            {
                                tempImages.Add(m_Images[i]);
                            }
                            else
                            {
                                tempImages.Add(null);
                            }
                        }
                    }

                    // Turn everything back into an Array.
                    m_Images = (WindowsImage[])tempImages.ToArray(typeof(WindowsImage));
                }

                GC.KeepAlive(this);
                return m_Images[imageIndex];
            }
        }

        public int ImageCount
        {
            get
            {
                return m_ImageCount;
            }
        }

        private class
        WindowsImage : IImage, IDisposable
        {
            private IntPtr m_ParentWindowsImageHandle = IntPtr.Zero;    // .wim file handle
            private string m_ParentWindowsImageFilePath;                // path to .wim file
            private XmlDocument m_ImageInformation;                     // Contains the information for the current image.

            private IntPtr m_ImageHandle = IntPtr.Zero;                 // image handle
            private int m_Index;                                        // index of image

            //
            //DO NOT CHANGE! This controls the format of the image header
            //and it must be present.
            //
            private const string UNICODE_FILE_MARKER = "\uFEFF";

            public
            WindowsImage(
                IntPtr imageContainerHandle,
                string imageContainerFilePath,
                int imageIndex)
            {
                m_ParentWindowsImageHandle = imageContainerHandle;
                m_ParentWindowsImageFilePath = imageContainerFilePath;
                m_Index = imageIndex;

                //
                //Load the image and stash away the handle.
                //
                m_ImageHandle = NativeMethods.LoadImage(
                    imageContainerHandle,
                    imageIndex);

                m_ImageInformation = new XmlDocument();
                
                // Remove the unicode marker at the beginning of the file.
                m_ImageInformation.LoadXml(NativeMethods.GetImageInformation(m_ImageHandle).Remove(0, 1));
                GC.KeepAlive(this);
            }

            ~WindowsImage()
            {
                DisposeInner();
            }

            public void
            Dispose()
            {
                DisposeInner();
                GC.SuppressFinalize(this);
            }

            private void
            DisposeInner()
            {
                //
                //Do not leave any open handles or mounted images.
                //
                if (m_ImageHandle != IntPtr.Zero)
                {
                    NativeMethods.CloseHandle(m_ImageHandle);
                    m_ImageHandle = IntPtr.Zero;
                }

                GC.KeepAlive(this);
            }

            public XmlDocument
            ImageInformation
            {
                get
                {
                    return m_ImageInformation;
                }
            }

            public string
            ImageName
            {
                get { return m_ImageInformation.SelectSingleNode("/IMAGE/NAME").InnerText; }
            }

            public ulong
            ImageSize
            {
                get { return ulong.Parse(m_ImageInformation.SelectSingleNode("/IMAGE/TOTALBYTES").InnerText); }
            }

            public string
            ImageArchitecture
            {
                get
                {
                    int arch = -1;
                    try
                    {
                        arch = int.Parse(m_ImageInformation.SelectSingleNode("/IMAGE/WINDOWS/ARCH").InnerText);
                    }
                    catch { }

                    switch (arch)
                    {
                        case 0:
                            return "x86";

                        case 6:
                            return "ia64";

                        case 9:
                            return "amd64";

                        default:
                            return null;
                    }
                }
            }

            public string
            ImageLanguage
            {
                get
                {
                    string lang = null;
                    try
                    {
                        lang = m_ImageInformation.SelectSingleNode("/IMAGE/WINDOWS/LANGUAGES/LANGUAGE").InnerText;
                    }
                    catch { }

                    return lang;
                }
            }

            public Version
            ImageVersion
            {
                get
                {
                    int major = 0;
                    int minor = 0;
                    int build = 0;
                    int revision = 0;

                    try
                    {
                        major = int.Parse(m_ImageInformation.SelectSingleNode("/IMAGE/WINDOWS/VERSION/MAJOR").InnerText);
                        minor = int.Parse(m_ImageInformation.SelectSingleNode("/IMAGE/WINDOWS/VERSION/MINOR").InnerText);
                        build = int.Parse(m_ImageInformation.SelectSingleNode("/IMAGE/WINDOWS/VERSION/BUILD").InnerText);
                        revision = int.Parse(m_ImageInformation.SelectSingleNode("/IMAGE/WINDOWS/VERSION/SPBUILD").InnerText);
                    }
                    catch { }

                    return (new Version(major, minor, build, revision));
                }
            }

            public string
            ImageDisplayName
            {
                get { return m_ImageInformation.SelectSingleNode("/IMAGE/DISPLAYNAME").InnerText; }
            }

            public string
            ImageDisplayDescription
            {
                get { return m_ImageInformation.SelectSingleNode("/IMAGE/DISPLAYDESCRIPTION").InnerText; }
            }

            public void
            Apply(string pathToApplyTo)
            {
                NativeMethods.ApplyImage(m_ImageHandle, pathToApplyTo);
                GC.KeepAlive(this);
            }
        }

        private class
        NativeMethods
        {
            private
            NativeMethods() { }

            [DllImport("Wimgapi.dll",
                ExactSpelling = true,
                EntryPoint = "WIMCreateFile",
                CallingConvention = CallingConvention.StdCall,
                SetLastError = true)]
            private static extern
            IntPtr
            WimCreateFile(
                [MarshalAs(UnmanagedType.LPWStr)] string WimPath,
                uint DesiredAccess,
                uint CreationDisposition,
                uint FlagsAndAttributes,
                uint CompressionType,
                out IntPtr CreationResult
            );

            public static IntPtr
            CreateFile(
                string imageFile,
                uint access,
                uint mode)
            {
                IntPtr creationResult = IntPtr.Zero;
                IntPtr windowsImageHandle = IntPtr.Zero;
                int rc = -1;

                windowsImageHandle = NativeMethods.WimCreateFile(
                    imageFile,
                    access,
                    mode,
                    0,
                    0,
                    out creationResult);

                rc = Marshal.GetLastWin32Error();
                if (windowsImageHandle == IntPtr.Zero)
                {
                    //
                    //Everything failed; throw an exception
                    //
                    throw new System.InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to open/create .wim file {0}. Error = {1}",
                            imageFile,
                            rc));
                }

                return windowsImageHandle;
            }

            [DllImport("Wimgapi.dll",
                ExactSpelling = true,
                EntryPoint = "WIMCloseHandle",
                CallingConvention = CallingConvention.StdCall,
                SetLastError = true)]
            private static extern bool
            WimCloseHandle(
                IntPtr Handle
            );

            public static void
            CloseHandle(
                IntPtr handle)
            {
                bool status = NativeMethods.WimCloseHandle(handle);
                int rc = Marshal.GetLastWin32Error();
                if (status == false)
                {
                    throw new System.InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to close image handle. Error = {0}",
                            rc));
                }
            }

            [DllImport("Wimgapi.dll",
                ExactSpelling = true,
                EntryPoint = "WIMSetTemporaryPath",
                CallingConvention = CallingConvention.StdCall,
                SetLastError = true)]
            private static extern bool
            WimSetTemporaryPath(
                IntPtr Handle,
                [MarshalAs(UnmanagedType.LPWStr)] string TemporaryPath
            );

            public static void
            SetTemporaryPath(
                IntPtr handle,
                string temporaryPath)
            {
                bool status = NativeMethods.WimSetTemporaryPath(handle, temporaryPath);
                int rc = Marshal.GetLastWin32Error();
                if (status == false)
                {
                    throw new System.InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to set temporary path. Error = {0}",
                            rc));
                }
            }

            [DllImport("Wimgapi.dll",
                ExactSpelling = true,
                EntryPoint = "WIMLoadImage",
                CallingConvention = CallingConvention.StdCall,
                SetLastError = true)]
            private static extern IntPtr
            WimLoadImage(
                IntPtr Handle,
                uint ImageIndex
            );

            public static IntPtr
            LoadImage(
                IntPtr handle,
                int imageIndex)
            {
                //
                //Load the image data based on the .wim handle
                //
                IntPtr hWim = NativeMethods.WimLoadImage(handle, (uint)imageIndex);
                int rc = Marshal.GetLastWin32Error();
                if (hWim == IntPtr.Zero)
                {
                    throw new System.InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to load image. Error = {0}",
                            rc));
                }

                return hWim;

            }

            [DllImport("Wimgapi.dll",
                ExactSpelling = true,
                EntryPoint = "WIMGetImageCount",
                CallingConvention = CallingConvention.StdCall,
                SetLastError = true)]
            private static extern int
            WimGetImageCount(
                IntPtr Handle
            );

            public static int
            GetImageCount(IntPtr windowsImageHandle)
            {
                int count = NativeMethods.WimGetImageCount(windowsImageHandle);
                int rc = Marshal.GetLastWin32Error();
                if (count == -1)
                {
                    throw new System.InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to get image count. Error = {0}",
                            rc));
                }

                return count;
            }

            [DllImport("Wimgapi.dll",
                ExactSpelling = true,
                EntryPoint = "WIMApplyImage",
                CallingConvention = CallingConvention.StdCall,
                SetLastError = true)]
            private static extern bool
            WimApplyImage(
                IntPtr Handle,
                [MarshalAs(UnmanagedType.LPWStr)] string Path,
                uint Flags
            );

            public static void
            ApplyImage(
                IntPtr imageHandle,
                string applicationPath)
            {
                //
                //Call WimApplyImage always with the Index flag for performance reasons.
                //
                bool status = NativeMethods.WimApplyImage(
                    imageHandle,
                    applicationPath,
                    NativeMethods.WIM_FLAG_INDEX);

                int rc = Marshal.GetLastWin32Error();
                if (status == false)
                {
                    throw new System.InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to apply image to {0}. Error = {1}",
                            applicationPath,
                            rc));
                }
            }

            [DllImport("Wimgapi.dll",
                ExactSpelling = true,
                EntryPoint = "WIMGetImageInformation",
                CallingConvention = CallingConvention.StdCall,
                SetLastError = true)]
            private static extern bool
            WimGetImageInformation(
                IntPtr Handle,
                out IntPtr ImageInfo,
                out IntPtr SizeOfImageInfo
            );

            public static string
            GetImageInformation(IntPtr handle)
            {
                IntPtr info = IntPtr.Zero, sizeOfInfo = IntPtr.Zero;
                bool status;

                status = NativeMethods.WimGetImageInformation(
                    handle,
                    out info,
                    out sizeOfInfo);

                int rc = Marshal.GetLastWin32Error();

                if (status == false)
                {
                    throw new System.InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to get image information. Error = {0}",
                            rc));
                }
                string s = Marshal.PtrToStringUni(info);

                //If the function succeeds, return the pointer to the string. Otherwise, return NULL.
                //
                return s;
            }

            public const uint WIM_FLAG_VERIFY = 0x00000002;

            public const uint WIM_FLAG_INDEX = 0x00000004;

        }

        private CreateFileAccessPrivate
        GetMappedFileAccess(CreateFileAccess access)
        {
            //
            //Map the file access specified from an int to uint.
            //
            CreateFileAccessPrivate fileAccess;
            switch (access)
            {
                case CreateFileAccess.Read:
                    fileAccess = CreateFileAccessPrivate.Read;
                    break;

                case CreateFileAccess.Write:
                    fileAccess = CreateFileAccessPrivate.Write;
                    break;

                default:
                    throw new ArgumentException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "No file access level specified."));
            }
            return fileAccess;
        }

        [FlagsAttribute]
        private enum
        CreateFileAccessPrivate : uint
        {
            Read = 0x80000000,
            Write = 0x40000000
        }

        //
        //WindowsImageContainer Member Data
        //
        private IntPtr m_ImageContainerHandle;  //Handle to the .wim file
        private string m_WindowsImageFilePath;  //Path to the .wim file

        private WindowsImage[] m_Images;        //Array of image objects inside a .wim file
        private int m_ImageCount;               //Number of images inside a .wim file

    }
}

"@

trap { break }

add-type -TypeDefinition $imagingAPIDefinition -ReferencedAssemblies "System.Xml"

$wimContainer = new-object Microsoft.WimgApi.WindowsImageContainer $WIM

if ($PsCmdlet.ParameterSetName -eq "list")
{
    Write-Host "`nIndex`tImage Name"
    
    # Loop through the images in the WIM.
    for ($image = 0; $image -lt $wimContainer.ImageCount; $image++)
    {
        Write-Host "[$($image + 1)]`t$($wimContainer[$image].ImageDisplayName)"
    }
}
elseif (($PsCmdlet.ParameterSetName -eq "apply") -and ($Apply))
{   
    $userIdent = new-object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

    if (!$userIdent.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        Write-Error "Images can only be applied by an administrator.  Please run PowerShell elevated and run this script again."
        break
    }
    
    Write-Host "Applying `"$($wimContainer[$Index - 1].ImageDisplayName)`" to $Destination..."
    Write-Warning "This may take up to 15 minutes..."   
    $timer = new-object System.Diagnostics.Stopwatch
    $timer.Start()
    $wimContainer[$($Index - 1)].Apply($Destination)
    $timer.Stop()
    Write-Host "`nElapsed Time: $($timer.Elapsed.ToString())`n"
}
else
{
    Write-Warning "Unable to apply the selected image.  Please check your command line and made sure that you are specifying the -APPLY flag."
}

# Clean up.

Get-Variable -exclude Runspace -Scope "Script" | Where-Object {
    $_.Value -is [Microsoft.WimgApi.WindowsImageContainer]
} | Foreach-Object {
        
    # This is an error-prone process, so get the current ErrorActionPreference.
    $eValue = $ErrorActionPreference    
    
    # Set our own EAP to continue without displaying errors.
    $ErrorActionPreference = "SilentlyContinue"
    
    # Ignore any errors that do crop up.
    trap { continue }
    
    # Clear the variables.
    $_.Value.Dispose() | out-null
    Remove-Variable $_.Name | out-null
    
    # Put the old EAP back.
    $ErrorActionPreference = $eValue
}

Write-Host "`nDone.`n"