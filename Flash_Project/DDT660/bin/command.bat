@echo off
setlocal enabledelayedexpansion

set "swcFile=DDT660.swc"
set "swfFile=library.swf"
set "newName=2.png"

REM WinRAR'ın kurulu olduğu yol
set "winrarPath=C:\Program Files\WinRAR\WinRAR.exe"

REM Eğer client.png varsa sil
if exist "%newName%" (
    del /f /q "%newName%"
)

REM .swc dosyasından .swf dosyasını çıkar
"%winrarPath%" e "%swcFile%" %swfFile% -o+

REM Eğer çıkarılan .swf dosyası varsa, yeniden adlandır
if exist "%swfFile%" (
    rename "%swfFile%" "%newName%"
)

REM Eğer yeniden adlandırma başarılıysa .swc dosyasını sil
if exist "%newName%" (
    del /f /q "%swcFile%"
    echo Başarıyla çıkarıldı ve yeniden adlandırıldı: %newName%
) else (
    echo Hata: %swfFile% bulunamadı veya yeniden adlandırılamadı.
)

exit
