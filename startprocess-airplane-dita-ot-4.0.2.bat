REM @echo off
set BACKUP_PATH=%PATH%
set BACKUP_JAVA_HOME=%JAVA_HOME%
set PATH=C:\Program Files\Java\jre1.8.0_321\bin;%PATH%;C:\Program Files\7-Zip\
set JAVA_HOME=C:\Program Files\Java\jre1.8.0_321;%JAVA_HOME%
REM *
REM * Example: 
REM *   startprocess-airplane-dita-ot-4.0.2.bat C:\mcmsm\published\nl-nl\xob1585897131743.ditamap_20201201-1536_MjAyMDEyMDEgMTUzNg\xob1585897131743_202301300844_003.ditamap
REM * 
set dirname=%~p1
echo Logging goes to %dirname%
set template=C:\mcmsm
set drive=C:
echo Launching build...
%template%\dita-ot-4.0.2\bin\ant.bat -f %template%\build-dod\build-dod.xml -Dexport.dir=%template% -Dditamap.file=%1 -Ddita.dir=%template%\dita-ot-4.0.2 -Dbuild.dir=%template%\build -DlanguageId=en_US -verbose -debug 
REM * Add or remove option '-Ddraft=pdf' to trigger build for one manual only
