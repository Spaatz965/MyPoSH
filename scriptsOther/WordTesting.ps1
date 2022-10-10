# https://mcpmag.com/articles/2018/05/24/getting-started-word-using-powershell.aspx
# https://learn-powershell.net/2014/12/31/beginning-with-powershell-and-word/
# https://www.udp689.com/2019/06/07/add-images-to-word-from-command-powershell/

$Word = New-Object -ComObject Word.Application

$Word.Visible = $True

$Document = $Word.Documents.Add()


$Word.ActiveDocument.Styles("Heading 1").Font.Name = "Segoe UI"

$Word.ActiveDocument.Styles("Normal").Font.Name = "Segoe UI"  

$Selection = $Word.Selection

$Selection.TypeText("My username is $($Env:USERNAME) and the date is $(Get-Date)")

$Word.ActiveDocument.Styles

$Selection.TypeParagraph()

$Selection.Style = "Heading 1"

$Selection.Font.Bold = 1
$Selection.TypeText("This is on a new line!")
$Selection.Font.Bold = 0
$Selection.TypeParagraph()
$Selection.TypeParagraph()
$Selection.TypeText("Yet another line to type on!")


$Selection.Font.Name = "Segoe UI"
$Selection.Font.Size = 12


$Selection.TypeParagraph()
$Selection.Font.Bold = 1
$Selection.TypeText("Here is something that I felt should be in Bold")
$Selection.Font.Bold = 0
$Selection.TypeParagraph()
$Selection.Font.Italic = 1
$Selection.TypeText("Just some fun text that is now in Italics!")
$Selection.Font.Italic = 0

$Selection.Font.Underline = 1
$Selection.Font.Underline = 0

$ImageFilePath = "D:\OneDrive\Pictures\Headshots\spaatz965@gmail.com-190107.jpg"

$Properties = @{'ImageName' = $ImageFile.Name
'Action(Insert)' = Try
{
$Word.Selection.EndKey(6)|Out-Null
$Word.Selection.InlineShapes.AddPicture("$ImageFilePath",$False)|Out-Null
$Word.Selection.TypeText("$ImageFilePath")|Out-Null
$Word.Selection.InsertNewPage() #insert new page to word
"Finished"
}
Catch
{
"Unfinished"
}
}







$Report = ".\MyFirstDocument2.docx"
$Document.SaveAs([ref]$Report,[ref]$SaveFormat::wdFormatDocument)
$word.Quit()

$null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$word)
[gc]::Collect()
[gc]::WaitForPendingFinalizers()
Remove-Variable word