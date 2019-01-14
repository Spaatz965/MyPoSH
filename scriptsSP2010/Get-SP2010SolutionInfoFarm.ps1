<#
    Compile SharePoint Farm Solution Information (Requires SharePoint Module)
#>

$FarmSolution = get-spsolution
$Properties = @{
    'added'                       = $FarmSolution.added
    'containscaspolicy'           = $FarmSolution.containscaspolicy
    'containsglobalassembly'      = $FarmSolution.containsglobalassembly
    'deployed'                    = $FarmSolution.deployed
    'deployedservers'             = $FarmSolution.deployedservers
    'deployedwebapplications'     = $FarmSolution.deployedwebapplications
    'deploymentstate'             = $FarmSolution.deploymentstate
    'displayname'                 = $FarmSolution.displayname
    'farm'                        = $FarmSolution.farm
    'id'                          = $FarmSolution.id
    'iswebpartpackage'            = $FarmSolution.iswebpartpackage
    'jobexists'                   = $FarmSolution.jobexists
    'jobstatus'                   = $FarmSolution.jobstatus
    'lastoperationdetails'        = $FarmSolution.lastoperationdetails
    'lastoperationendtime'        = $FarmSolution.lastoperationendtime
    'lastoperationresult'         = $FarmSolution.lastoperationresult
    'name'                        = $FarmSolution.name
    'parent'                      = $FarmSolution.parent
    'properties'                  = $FarmSolution.properties
    'solutionfile'                = $FarmSolution.solutionfile
    'solutionid'                  = $FarmSolution.solutionid
    'status'                      = $FarmSolution.status
    'typename'                    = $FarmSolution.typename
    'upgradedpersistedproperties' = $FarmSolution.upgradedpersistedproperties
    'version'                     = $FarmSolution.version
}
