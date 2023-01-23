---
layout: post
title:  "Configure winRM for Ansible playbook"
date:   2022-12-22 06:21:11 +0530
categories: config 
---

Create user in windows as ansible
- Go to explorer pick my PC and right click and select Manage
- Go to User section in Computer Managmenet.
 - Go to Users creation option and create a user by
 name : ansible
 description : ansible
 password : PlayBook@2023 // This illustration password only.
 
 - Then Go to Groups section, Select Administrator groups
 - then Add ansible user just created in above steps to this administrator group.
 
Step -X ==> Start windows powershell with administrator credential.
-  right click on the powershell icon and start ==> run as Administrator.


1. verify PowerShell version  - Execute below command in powershell
{% highlight ruby %}
	C:\windows\system32> Get-Host | Select-Object Version	
	Version
	-------
	5.1.19041.1237
{% endhighlight %}

2. verify .NET version  - Execute below command in powershell
{% highlight ruby %}
	C:\windows\system32> Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where { $_.PSChildName -Match '^(?!S)\p{L}'} | Select PSChildName, version

PSChildName                      Version
-----------                      -------
v2.0.50727                       2.0.50727.4927
v3.0                             3.0.30729.4926
Windows Communication Foundation 3.0.4506.4926
Windows Presentation Foundation  3.0.6920.4902
v3.5                             3.5.30729.4926
Client                           4.8.03761
Full                             4.8.03761
Client                           4.0.0.0
{% endhighlight %}

3. Verify WinRM not-configured   -  Execute below command in powershell
{% highlight ruby %}
	C:\windows\system32> winrm get winrm/config/Service
{% endhighlight %}


4. Setup WinRM - Execute below command in powershell
{% highlight ruby %}
PS C:\windows\system32> [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
PS C:\windows\system32> $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
PS C:\windows\system32> $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
PS C:\windows\system32> (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
PS C:\windows\system32> powershell.exe -ExecutionPolicy ByPass -File $file
Self-signed SSL certificate generated; thumbprint: 95602B16C0092C3481D45140D3E81A7D7603AE49


wxf                 : http://schemas.xmlsoap.org/ws/2004/09/transfer
a                   : http://schemas.xmlsoap.org/ws/2004/08/addressing
w                   : http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd
lang                : en-US
Address             : http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous
ReferenceParameters : ReferenceParameters

Ok.


{% endhighlight %}

5.  Verify again the winRM installation

{% highlight ruby %}

PS C:\windows\system32> winrm get winrm/config/Service
Service
    RootSDDL = O:NSG:BAD:P(A;;GA;;;BA)(A;;GR;;;IU)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)
    MaxConcurrentOperations = 4294967295
    MaxConcurrentOperationsPerUser = 1500
    EnumerationTimeoutms = 240000
    MaxConnections = 300
    MaxPacketRetrievalTimeSeconds = 120
    AllowUnencrypted = false
    Auth
        Basic = true
        Kerberos = true
        Negotiate = true
        Certificate = false
        CredSSP = false
        CbtHardeningLevel = Relaxed
    DefaultPorts
        HTTP = 5985
        HTTPS = 5986
    IPv4Filter = *
    IPv6Filter = *
    EnableCompatibilityHttpListener = false
    EnableCompatibilityHttpsListener = false
    CertificateThumbprint
    AllowRemoteAccess = true
	
	
PS C:\windows\system32> winrm get winrm/config/Winrs
Winrs
    AllowRemoteShellAccess = true
    IdleTimeout = 7200000
    MaxConcurrentUsers = 2147483647
    MaxShellRunTime = 2147483647
    MaxProcessesPerShell = 2147483647
    MaxMemoryPerShellMB = 2147483647
    MaxShellsPerUser = 2147483647

PS C:\windows\system32>

PS C:\windows\system32>  winrm enumerate winrm/config/Listener
Listener
    Address = *
    Transport = HTTP
    Port = 5985
    Hostname
    Enabled = true
    URLPrefix = wsman
    CertificateThumbprint
    ListeningOn = 127.0.0.1, 169.254.32.125, 169.254.55.13, 169.254.68.134, 169.254.74.224, 169.254.173.43, 192.168.29.167, 192.168.56.1, 192.168.166.65, ::1, 2405:201:c008:d231:b0fa:4ef2:d030:60e9, 2405:201:c008:d231:d9cb:5baa:b0fb:fc49, fe80::7e37:2758:e65:43b8%11, fe80::b368:a5cb:9017:7b37%33, fe80::b645:f628:b1b8:bcb3%4, fe80::c248:5f4a:74dc:8e2b%10, fe80::c637:6dd0:3a54:f365%12, fe80::d129:cd82:f8bb:44c9%9, fe80::e815:529a:4d5:16f3%3

Listener
    Address = *
    Transport = HTTPS
    Port = 5986
    Hostname = INHMT2E-DL722
    Enabled = true
    URLPrefix = wsman
    CertificateThumbprint = 95602B16C0092C3481D45140D3E81A7D7603AE49
    ListeningOn = 127.0.0.1, 169.254.32.125, 169.254.55.13, 169.254.68.134, 169.254.74.224, 169.254.173.43, 192.168.29.167, 192.168.56.1, 192.168.166.65, ::1, 2405:201:c008:d231:b0fa:4ef2:d030:60e9, 2405:201:c008:d231:d9cb:5baa:b0fb:fc49, fe80::7e37:2758:e65:43b8%11, fe80::b368:a5cb:9017:7b37%33, fe80::b645:f628:b1b8:bcb3%4, fe80::c248:5f4a:74dc:8e2b%10, fe80::c637:6dd0:3a54:f365%12, fe80::d129:cd82:f8bb:44c9%9, fe80::e815:529a:4d5:16f3%3
	
	{% endhighlight %}
	
	
[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/