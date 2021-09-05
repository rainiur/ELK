## This can remove the cert if you made a mistake
Get-ChildItem Cert:\LocalMachine\Root\ | Where-Object { $_.Subject -like '*Elastic*'} | Remove-Item

## To remove the agent and endpoint (had to do this a lot for a lot of corrections)
Set-Location "C:/Program Files/Elastic/Agent"
./elastic-agent uninstall
Set-Location ../Endpoint
./elastic-endpoint uninstall
Set-Location ../..
Remove-Item -Recurse -Force Elastic
Set-Location ~
