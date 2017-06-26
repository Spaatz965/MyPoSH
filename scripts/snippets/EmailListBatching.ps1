For ( $I = 1; $I -le 36; $I++) {
    $email1 = $email | where {$_.DayBatch -eq $I -and $_.mailprimary -ne ""}
    $output = $email1.mailprimary -join ";"
    $output | Out-File mailing.txt -Append
}
