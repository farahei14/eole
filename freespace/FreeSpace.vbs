Dim fs, a, d, s
Set fs = CreateObject("Scripting.FileSystemObject")
Set a = fs.CreateTextFile("U:\testfile.txt", True)
Set fs = CreateObject("Scripting.FileSystemObject")
Set d = fs.GetDrive(fs.GetDriveName("U:\"))
s = "			ATTENTION !!" & vbnewline & vbnewline & "	Espace disque disponible faible, il ne vous reste que  " & FormatNumber(d.FreeSpace/1024, 0) & " ko libres" & vbnewline & vbnewline & "            Faites un peu de ménage en supprimant les fichiers inutiles ou obsolètes                      "
if d.FreeSpace/1024 < 5000 then 
MsgBox(s)
end if
