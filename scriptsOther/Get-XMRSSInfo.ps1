#$url = "https://davidspark.libsyn.com/cisovendor"
$url = "https://defenseindepth.libsyn.com/rss"
#$url = "https://cisoseries.libsyn.com/rss"

#[xml]$xml = (new-object System.Net.WebClient).downloadstring($url)

[xml]$xml = (Invoke-WebRequest -Uri $url).Content
#[xml]$xml = get-content "$doc\cisoseries.xml"


$Title = $xml.rss.channel.title
$Presenter = $xml.rss.channel.author

foreach ( $Item in $xml.rss.channel.item ) {

    $PubDate = [datetime]$Item.pubDate


$Properties = [ordered]@{
    
    'StartDate' = $PubDate.ToString("MMM dd, yyyy")
    'EndDate' = $PubDate.AddDays(5).ToString("MMM dd, yyyy")
    'Title' = "$Title $($PubDate.ToString("dd MMM yyyy"))"
    'Presenter' = $Presenter
    'Year Published' = $PubDate.ToString("yyyy")
    'duration' = "00:$($item.duration)"
    'summary' = $item.description.'#cdata-section'
}

$Output = New-Object -TypeName PSObject -Property $Properties
Write-Output $Output

} # foreach $Item


<#
$xml

$xml.rss.channel.item[0].description.'#cdata-section' | ConvertFrom-Html | select *

$xml.rss.channel.item[1].description.'#cdata-section' | out-file "$Doc\temp.html"


$Source = Get-Content -path "$Doc\temp.html" -raw
$HTML = New-Object -Com "HTMLFile"
$HTML.IHTMLDocument2_write($Source)
$HTML.all.tags("code") | % InnerText




$xml.rss.channel.item.description.'#cdata-section' | Set-Clipboard
#>