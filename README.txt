README - ATFilterDriver Project

This project includes placeholder ATFilter.cat. To generate a valid catalog file:

1. Open a WDK or EWDK build environment.
2. Run:
   Inf2Cat.exe /driver:"<path_to_this_project_folder>" /os:10_X64
3. Sign the .cat file:
   signtool sign /a /fd SHA256 ATFilter.cat
4. Then use deploy.ps1 to build, sign, install, and start ETW session.
   Or manually:
     pnputil /add-driver ATFilter.inf /install
     wevtutil im ATFilter.manifest
     logman start ATFilterTrace -p b1c0ffee-1234-5678-abcd-1234567890ab 0x1 -ets

If you cannot generate a .cat, you may disable signature enforcement for testing only:
   bcdedit /set nointegritychecks on
   bcdedit /set TESTSIGNING ON
