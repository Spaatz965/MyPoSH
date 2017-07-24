# Load SharePoint PSSnaping
Add-PSSnapin "Microsoft.SharePoint.PowerShell"  -ErrorAction SilentlyContinue




function Inventory-SPFarmSolutions {
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)]$farm,
		[Parameter(Mandatory=$true)]$logfilename
	) #param
	BEGIN {
		Write-Output "  Inventorying Solutions in $($farm.Name)"
		$solutions = $farm.Solutions
		if (-not (test-path $logfilename)) {
			$row = '"SolutionId","SolutionDisplayName"' 
			$row | Out-File $logfilename
		}
	} #BEGIN
	PROCESS {
		foreach ($solution in $solutions) { 
				$row='"'+$solution.ID+'","'+$solution.DisplayName+'"'
				$row | Out-File $logfilename -append 
			} #foreach solution
	} #PROCESS
	END {} #END
}
