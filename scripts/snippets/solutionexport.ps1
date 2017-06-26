$SPSolution = get-spsoluion

$properties = @{
	'name'                    = $SPSolution.name
	'displayname'             = $SPSolution.displayname
	'lastoperationendtime'    = $SPSolution.lastoperationendtime
	'lastoperationresult'     = $SPSolution.lastoperationresult
	'id'                      = $SPSolution.id
	'added'                   = $SPSolution.added
	'containsglobalassembly'  = $SPSolution.containsglobalassembly
	'deployed'                = $SPSolution.deployed
	'deployedservers'         = $SPSolution.deployedservers
	'deployedwebapplications' = $SPSolution.deployedwebapplications
	'deploymentstate'         = $SPSolution.deploymentstate
	'lastoperationdetails'    = $SPSolution.lastoperationdetails
	'solutionfile'            = $SPSolution.solutionfile
	'solutionid'              = $SPSolution.solutionid
	'status'                  = $SPSolution.status
	'version'                 = $SPSolution.version
}


$Output = New-Object -TypeName PSObject -Property $properties
Write-Output $Output

