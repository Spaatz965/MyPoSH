[psobject].Assembly.GetType(“System.Management.Automation.TypeAccelerators”)::get
<#
REF: https://devblogs.microsoft.com/scripting/use-powershell-to-find-powershell-type-accelerators/
REF: https://4sysops.com/archives/using-powershell-type-accelerators/
#>

$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")
$TAType::Add('accelerators', $TAType)

