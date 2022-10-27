# PowerShell GitHub App Auth Sample

This repo contains a sample script for showing authentication to GitHub using a GitHub App.

## Instructions

1. Create a GitHub App
1. Generate a private key and download it
2. Install the app on an org
3. Make a note of the `appId` as well as the `installation_id`
4. Use the sample [script](./JWT.ps1) to generate a JWT token
5. Use the JWT token to get an access token
6. Use the access token to interact with GitHub
