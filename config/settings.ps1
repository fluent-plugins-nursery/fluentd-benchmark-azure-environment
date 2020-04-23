Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile ConfigureRemotingForAnsible.ps1
powershell -ExecutionPolicy RemoteSigned ConfigureRemotingForAnsible.ps1
Remove-Item -path ConfigureRemotingForAnsible.ps1 -force
