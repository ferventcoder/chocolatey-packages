----------------------------------------------------------- README-WIN.TXT ----
The Binary Distribution of DeleGate for Windows
                                                DeleGate/9.9.7
                                                March 31, 2010

This distribution contains four files under the "bin" directory:

  1) dg9_9_7.exe   -- the executable file of DeleGate (9.9.7)
  2) dgzlib1.dll   -- Zlib library (1.2.3.f-DeleGate-v3)
  3) libssl32.dll  -- OpenSSL library (0.9.8g 19 Oct 2007)
  4) ssleay32.dll  -- OpenSSL library (0.9.8g 19 Oct 2007)

HOW TO INSTALL
==============
  Copy all of the above four files into the same directory.

    You may rename the executable file of DeleGate but other (DLL)
    files must not be renamed.

NOTE FOR USERS OF OLDER VERSIONS
================================

  Add -vt or -vs option if you need to reduce or suppress the logging
  into the LOGFILE.

    In older versions before 9.7.0, the logging has been suppressed
    unintentionally when DeleGate is running as a service owned by
    Administrators/SYSTEM due to lacking of the write permission for
    SYSTEM to files created by DeleGate itself.

LICENSE / COPYRIGHT
===================
  The "doc" directory contains license data for the components.
     COPYRIGHT        -- DeleGate
     zlib.h           -- Zlib
     OpenSSL-LICENSE  -- OpenSSL
-------------------------------------------------------------------------------
