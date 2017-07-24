#
# Script3.ps1
#
# Create a new resource group
$rgName="SP2013TestLab"
$locName="East US"
New-AzureRMResourceGroup -Name $rgName -Location $locName


# Create the TestLab virtual network

$CorpSubnetParams = @{
	'Name' = "Corpnet"
	'AddressPrefix' = "10.0.0.0/24"
	} #End $CorpSubnetParams
$corpnetSubnet=New-AzureRMVirtualNetworkSubnetConfig @CorpSubnetParams

$VirtualNetworkParams = @{
	'Name' = "TestLab"
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'AddressPrefix' = "10.0.0.0/8"
	'Subnet' = $corpnetSubnet
	'DNSServer' = "10.0.0.4"
	} #End $VirtualNetworkParams
New-AzureRMVirtualNetwork  @VirtualNetworkParams

$Rule1Params = @{
	'Name' = "RDPTraffic"
	'Description' = "Allow RDP to all VMs on the subnet"
	'Access' = "Allow"
	'Protocol' = "Tcp"
	'Direction' = "Inbound"
	'Priority' = 100
	'SourceAddressPrefix' = "Internet"
	'SourcePortRange' = "*"
	'DestinationAddressPrefix' = "*"
	'DestinationPortRange' = 3389
	} #End $Rule1Params
$rule1=New-AzureRMNetworkSecurityRuleConfig @Rule1Params

$SecurityGroupParams = @{
	'Name' = "Corpnet"
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'SecurityRules' = $rule1
	} #End $SecurityGroupParams
New-AzureRMNetworkSecurityGroup @SecurityGroupParams

$VnetParams = @{
	'ResourceGroupName' = $rgName
	'Name' = "TestLab"
	} #End $VnetParams
$vnet=Get-AzureRMVirtualNetwork @VnetParams

$nsgParams = @{
	'Name' = "Corpnet"
	'ResourceGroupName' = $rgName
	} #End $nsgParams
$nsg=Get-AzureRMNetworkSecurityGroup @nsgParams

$VNetConfigParams = @{
	'VirtualNetwork' = $vnet
	'Name' = "Corpnet"
	'AddressPrefix' = "10.0.0.0/24"
	'NetworkSecurityGroup' = $nsg
	} #End $VnetConfigParams
Set-AzureRMVirtualNetworkSubnetConfig @VnetParams


# Create the DC1 VM
$HostName = "DC1"

$PipParams = @{
	'Name' = "$HostName-PIP"
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'AllocationMethod' = "Dynamic"
	} #End $PipParams
$pip=New-AzureRMPublicIpAddress @PipParams

$NicParams = @{
	'Name' = "$HostName-NIC"
	'ResourceGroupName' = $rgName
	'Location' = $locName
	'SubnetId' = $vnet.Subnets[0].Id
	'PublicIpAddressId' = $pip.Id
	'PrivateIpAddress' = "10.0.0.4"
	} #End $NicParams
$nic=New-AzureRMNetworkInterface @NicParams

$VMParams = @{
	'VMName' = $HostName
	'VMSize' = "Standard_A1"
	} #End $VMParams
$vm=New-AzureRMVMConfig @VMParams

$UserName = "MC$HostName"
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>
	$Password = ConvertTo-SecureString -String '<password>' -AsPlainText -Force
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>

$CredParams = @{
	'TypeName' = "System.Management.Automation.PSCredential"
	'ArgumentList' = $UserName, $Password
	} #End $CredParams
$cred=New-Object @CredParams

$VMOSParams = @{
	'VM' = $vm
	'Windows' = $true
	'ComputerName' = $HostName
	'Credential' = $cred
	'ProvisionVMAgent' = $true
	'EnableAutoUpdate' = $true
	} #End $VMOSParams
$vm=Set-AzureRMVMOperatingSystem @VMOSParams

$VMSourceParams = @{
	'VM' = $vm
	'PublisherName' = "MicrosoftWindowsServer"
	'Offer' = "WindowsServer"
	'Skus' = "2016-Datacenter"
	'Version' = "latest"
	} #End $VMSourceParams
$vm=Set-AzureRMVMSourceImage @VMSourceParams

$VMNicParams = @{
	'VM' = $vm
	'Id' = $nic.Id
}
$vm=Add-AzureRMVMNetworkInterface @VMNicParams

$VMOSDiskParams = @{
	'VM' = $vm
	'Name' = "$HostName-OS"
	'DiskSizeInGB' = 128
	'CreateOption' = "FromImage"
	'StorageAccountType' = "StandardLRS"
	} #End $VMOSDiskParams
$vm=Set-AzureRmVMOSDisk @VMOSDiskParams

$DiskConfigParams = @{
	'AccountType' = "StandardLRS"
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'CreateOption' = "Empty"
	'DiskSizeGB' = 20
}
$diskConfig=New-AzureRmDiskConfig @DiskConfigParams

$DataDisk1Params = @{
	'DiskName' = "$HostName-DataDisk1"
	'Disk' = $diskConfig
	'ResourceGroupName' = $rgName
	} #End $DataDisk1Params
$dataDisk1=New-AzureRmDisk @DataDisk1Params

$VMAddDataDiskParams = @{
	'VM' = $vm
	'Name' = "$HostName-DataDisk1"
	'CreateOption' = "Attach"
	'ManagedDiskId' = $dataDisk1.Id
	'Lun' = 1
}
$vm=Add-AzureRmVMDataDisk @VMAddDataDiskParams

$NewVMParams = @{
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'VM' = $vm
}
New-AzureRMVM @NewVMParams


# Create the CLIENT1 VM
$HostName = "CLIENT1"

$PipParams = @{
	'Name' = "$HostName-PIP"
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'AllocationMethod' = "Dynamic"
	} #End $PipParams
$pip=New-AzureRMPublicIpAddress @PipParams

$NicParams = @{
	'Name' = "$HostName-NIC"
	'ResourceGroupName' = $rgName
	'Location' = $locName
	'SubnetId' = $vnet.Subnets[0].Id
	'PublicIpAddressId' = $pip.Id
	} #End $NicParams
$nic=New-AzureRMNetworkInterface @NicParams

$VMParams = @{
	'VMName' = $HostName
	'VMSize' = "Standard_A1"
	} #End $VMParams
$vm=New-AzureRMVMConfig @VMParams

$UserName = "MC$HostName"
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>
	$Password = ConvertTo-SecureString -String '<password>' -AsPlainText -Force
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>

$CredParams = @{
	'TypeName' = "System.Management.Automation.PSCredential"
	'ArgumentList' = $UserName, $Password
	} #End $CredParams
$cred=New-Object @CredParams

$VMOSParams = @{
	'VM' = $vm
	'Windows' = $true
	'ComputerName' = $HostName
	'Credential' = $cred
	'ProvisionVMAgent' = $true
	'EnableAutoUpdate' = $true
	} #End $VMOSParams
$vm=Set-AzureRMVMOperatingSystem @VMOSParams

$VMSourceParams = @{
	'VM' = $vm
	'PublisherName' = "MicrosoftWindowsServer"
	'Offer' = "WindowsServer"
	'Skus' = "2016-Datacenter"
	'Version' = "latest"
	} #End $VMSourceParams
$vm=Set-AzureRMVMSourceImage @VMSourceParams

$VMNicParams = @{
	'VM' = $vm
	'Id' = $nic.Id
}
$vm=Add-AzureRMVMNetworkInterface @VMNicParams

$VMOSDiskParams = @{
	'VM' = $vm
	'Name' = "$HostName-OS"
	'DiskSizeInGB' = 128
	'CreateOption' = "FromImage"
	'StorageAccountType' = "StandardLRS"
	} #End $VMOSDiskParams
$vm=Set-AzureRmVMOSDisk @VMOSDiskParams

$NewVMParams = @{
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'VM' = $vm
}
New-AzureRMVM @NewVMParams


# Create the SQL1 VM
$HostName = "SQL1"

$PipParams = @{
	'Name' = "$HostName-PIP"
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'AllocationMethod' = "Dynamic"
	} #End $PipParams
$pip=New-AzureRMPublicIpAddress @PipParams

$NicParams = @{
	'Name' = "$HostName-NIC"
	'ResourceGroupName' = $rgName
	'Location' = $locName
	'SubnetId' = $vnet.Subnets[0].Id
	'PublicIpAddressId' = $pip.Id
	} #End $NicParams
$nic=New-AzureRMNetworkInterface @NicParams

$VMParams = @{
	'VMName' = $HostName
	'VMSize' = "Standard_A3"
	} #End $VMParams
$vm=New-AzureRMVMConfig @VMParams

$UserName = "MC$HostName"
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>
	$Password = ConvertTo-SecureString -String '<password>' -AsPlainText -Force
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>

$CredParams = @{
	'TypeName' = "System.Management.Automation.PSCredential"
	'ArgumentList' = $UserName, $Password
	} #End $CredParams
$cred=New-Object @CredParams

$VMOSParams = @{
	'VM' = $vm
	'Windows' = $true
	'ComputerName' = $HostName
	'Credential' = $cred
	'ProvisionVMAgent' = $true
	'EnableAutoUpdate' = $true
	} #End $VMOSParams
$vm=Set-AzureRMVMOperatingSystem @VMOSParams

$VMSourceParams = @{
	'VM' = $vm
	'PublisherName' = "MicrosoftSQLServer"
	'Offer' = "SQL2012SP4-WS2012R2"
	'Skus' = "Enterprise"
	'Version' = "latest"
	} #End $VMSourceParams
$vm=Set-AzureRMVMSourceImage @VMSourceParams

$VMNicParams = @{
	'VM' = $vm
	'Id' = $nic.Id
}
$vm=Add-AzureRMVMNetworkInterface @VMNicParams

$VMOSDiskParams = @{
	'VM' = $vm
	'Name' = "$HostName-OS"
	'DiskSizeInGB' = 196
	'CreateOption' = "FromImage"
	'StorageAccountType' = "StandardLRS"
	} #End $VMOSDiskParams
$vm=Set-AzureRmVMOSDisk @VMOSDiskParams

$NewVMParams = @{
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'VM' = $vm
}
New-AzureRMVM @NewVMParams


# Create the APP1 VM
$HostName = "APP1"

$PipParams = @{
	'Name' = "$HostName-PIP"
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'AllocationMethod' = "Dynamic"
	} #End $PipParams
$pip=New-AzureRMPublicIpAddress @PipParams

$NicParams = @{
	'Name' = "$HostName-NIC"
	'ResourceGroupName' = $rgName
	'Location' = $locName
	'SubnetId' = $vnet.Subnets[0].Id
	'PublicIpAddressId' = $pip.Id
	} #End $NicParams
$nic=New-AzureRMNetworkInterface @NicParams

$VMParams = @{
	'VMName' = $HostName
	'VMSize' = "Standard_A3"
	} #End $VMParams
$vm=New-AzureRMVMConfig @VMParams

$UserName = "MC$HostName"
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>
	$Password = ConvertTo-SecureString -String '<password>' -AsPlainText -Force
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>

$CredParams = @{
	'TypeName' = "System.Management.Automation.PSCredential"
	'ArgumentList' = $UserName, $Password
	} #End $CredParams
$cred=New-Object @CredParams

$VMOSParams = @{
	'VM' = $vm
	'Windows' = $true
	'ComputerName' = $HostName
	'Credential' = $cred
	'ProvisionVMAgent' = $true
	'EnableAutoUpdate' = $true
	} #End $VMOSParams
$vm=Set-AzureRMVMOperatingSystem @VMOSParams

$VMSourceParams = @{
	'VM' = $vm
	'PublisherName' = "MicrosoftSharePoint"
	'Offer' = "MicrosoftSharePointServer"
	'Skus' = "2013"
	'Version' = "latest"
	} #End $VMSourceParams
$vm=Set-AzureRMVMSourceImage @VMSourceParams

$VMNicParams = @{
	'VM' = $vm
	'Id' = $nic.Id
}
$vm=Add-AzureRMVMNetworkInterface @VMNicParams

$VMOSDiskParams = @{
	'VM' = $vm
	'Name' = "$HostName-OS"
	'DiskSizeInGB' = 128
	'CreateOption' = "FromImage"
	'StorageAccountType' = "StandardLRS"
	} #End $VMOSDiskParams
$vm=Set-AzureRmVMOSDisk @VMOSDiskParams

$NewVMParams = @{
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'VM' = $vm
}
New-AzureRMVM @NewVMParams

# Create the WFE1 VM
$HostName = "WFE1"

$PipParams = @{
	'Name' = "$HostName-PIP"
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'AllocationMethod' = "Dynamic"
	} #End $PipParams
$pip=New-AzureRMPublicIpAddress @PipParams

$NicParams = @{
	'Name' = "$HostName-NIC"
	'ResourceGroupName' = $rgName
	'Location' = $locName
	'SubnetId' = $vnet.Subnets[0].Id
	'PublicIpAddressId' = $pip.Id
	} #End $NicParams
$nic=New-AzureRMNetworkInterface @NicParams

$VMParams = @{
	'VMName' = $HostName
	'VMSize' = "Standard_A3"
	} #End $VMParams
$vm=New-AzureRMVMConfig @VMParams

$UserName = "MC$HostName"
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>
	$Password = ConvertTo-SecureString -String '<password>' -AsPlainText -Force
	<#
	*********WARNING - PASSWORD IN SCRIPT*********
	#>

$CredParams = @{
	'TypeName' = "System.Management.Automation.PSCredential"
	'ArgumentList' = $UserName, $Password
	} #End $CredParams
$cred=New-Object @CredParams

$VMOSParams = @{
	'VM' = $vm
	'Windows' = $true
	'ComputerName' = $HostName
	'Credential' = $cred
	'ProvisionVMAgent' = $true
	'EnableAutoUpdate' = $true
	} #End $VMOSParams
$vm=Set-AzureRMVMOperatingSystem @VMOSParams

$VMSourceParams = @{
	'VM' = $vm
	'PublisherName' = "MicrosoftSharePoint"
	'Offer' = "MicrosoftSharePointServer"
	'Skus' = "2013"
	'Version' = "latest"
	} #End $VMSourceParams
$vm=Set-AzureRMVMSourceImage @VMSourceParams

$VMNicParams = @{
	'VM' = $vm
	'Id' = $nic.Id
}
$vm=Add-AzureRMVMNetworkInterface @VMNicParams

$VMOSDiskParams = @{
	'VM' = $vm
	'Name' = "$HostName-OS"
	'DiskSizeInGB' = 128
	'CreateOption' = "FromImage"
	'StorageAccountType' = "StandardLRS"
	} #End $VMOSDiskParams
$vm=Set-AzureRmVMOSDisk @VMOSDiskParams

$NewVMParams = @{
	'ResourceGroupName' = $rgName
	'Location' = (Get-AzureRmResourceGroup -Name $rgName).Location
	'VM' = $vm
}
New-AzureRMVM @NewVMParams