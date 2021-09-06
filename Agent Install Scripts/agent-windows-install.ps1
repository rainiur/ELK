#########################################################
#  Elastic Agent Windows Powershell Install Script
#		by David Walden (Rainiur)
#  This script will download the certificate from the server via scp
#       (This script will register a self-signed cert if you are using a 3rd party signed cert
#       delete --insecure from the elastic-agent install)
#  Install the certificate into the LocalMachine Root
#  Download the agent from elastic.co 
#  And run the install to register it to your Fleet manager
#
#  You will need the following
#		- ssh credentials, filename and IP for the server with your cert 
#			(best to copy the cert to the root directory of the user)
#		- IP address of your Fleet Server
#		- Token for the policy to apply to the system
#
#########################################################

## Change to the user directory and install SSH module
Set-Location ~
Install-Module -Name Posh-SSH -Force

## Credentials to download cert file from server
$credential = Get-Credential

## Use this instead if you do not want to be propmted for a login
#$username = '<username>'
#$password = '<password>' | ConvertTo-SecureString -asPlainText -Force
#$credential = New-Object System.Management.Automation.PSCredential($username,$password)

## Download the cert and close the SSH session
Get-SCPItem -ComputerName <IP of Server> -AcceptKey -Credential $credential -Path "<cert name 'ca.crt'>" -PathType File -Destination ./
Get-SSHSession | Remove-SSHSession

## Import the cert into the Root of the LocalMachine
Import-Certificate -FilePath ca.crt  -CertStoreLocation 'Cert:\LocalMachine\Root' -Verbose

# Remove copied cert file and uninstall module
Remove-Item ca.crt
Remove-Module -Name Posh-SSH -Force

## Verify the cert is installed
Get-ChildItem Cert:\LocalMachine\Root\ | Where-Object { $_.Subject -like '*Elastic*'}

## Download the agent
$filename = "elastic-agent-7.14.1-windows-x86_64.zip"
$ProgressPreference = 'SilentlyContinue'
$url = "https://artifacts.elastic.co/downloads/beats/elastic-agent/" + $filename
Invoke-WebRequest $url -OutFile $filename
$ProgressPreference = 'Continue'

## Unzip the agent
Expand-Archive $filename

## Change into agent directory and install (Don't know why is creates 2 subdirectories to store the files)
Set-Location $filename.Replace(".zip","")
Set-Location $filename.Replace(".zip","")
./elastic-agent install -f --url=https://<IP of Fleet Server>:8220 --insecure --enrollment-token=<policy token to enroll to Fleet Server>

## Cleanup
Set-Location ../..
Remove-Item -Recurse -Force $filename.Replace(".zip","")
Remove-Item $filename


