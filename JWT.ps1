# Install the module that we need to create the JWT token
# Install-Module powershell-jwt

# get the API Key for the App (at https://github.com/settings/apps/<appname>)
$api_key = '255258'

# generate and download the Private Key file
# read in the private key
$api_secret_contents = Get-Content -Path ./powershellapi.2022-10-27.private-key.pem
$api_secret = [System.Text.Encoding]::UTF8.GetBytes($api_secret_contents)

# generate 'iat' and 'exp' dates
$exp = [int][double]::parse((Get-Date -Date $((Get-Date).addseconds(300).ToUniversalTime()) -UFormat %s)) 
$iat = [int][double]::parse((Get-Date -Date $((Get-Date).ToUniversalTime()) -UFormat %s)) 

# generate a signed JWT token
$jwt = New-JWT -Algorithm "RS256" -Issuer $api_key -ExpiryTimestamp $exp -SecretKey $api_secret -PayloadClaims @{ "iat" = $iat}

# get the installation ID (you have installed the App and this is the instance ID)
# find it on the installation URL e.g. https://github.com/settings/installations/30663309
$install_id = "30663309" 

# get an access token from the JWT
$headers = @{
    "Accept" = "application/vnd.github+json"
    "Authorization" = "Bearer $jwt"
}
$res = Invoke-WebRequest -Uri https://api.github.com/app/installations/$install_id/access_tokens -Headers $headers -Method Post
$json_res = ConvertFrom-Json($res.Content)
$token = $json_res.token

# now use the token
$headers = @{
    Accept="application/vnd.github+json"
    Authorization="token $token"
}
Invoke-WebRequest -Uri https://api.github.com/repos/<owner>/<repo>/contents/<path> -Headers $headers