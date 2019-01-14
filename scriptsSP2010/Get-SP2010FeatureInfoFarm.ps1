<#
    Compile SharePoint Farm Feature Information (Requires SharePoint Module)
    add -webapplication https://webapplication.example.com to get web application features
#>

$FarmFeature = get-spfeature -limit all #-webapplication https://webapplication.example.com
$Properties= @{
    'activateondefault'           = $FarmFeature.activateondefault
    'activationdependencies'      = $FarmFeature.activationdependencies
    'alwaysforceinstall'          = $FarmFeature.alwaysforceinstall
    'autoactivateincentraladmin'  = $FarmFeature.autoactivateincentraladmin
    'defaultresourcefile'         = $FarmFeature.defaultresourcefile
    'displayname'                 = $FarmFeature.displayname
    'farm'                        = $FarmFeature.farm
    'hidden'                      = $FarmFeature.hidden
    'id'                          = $FarmFeature.id
    'name'                        = $FarmFeature.name
    'parent'                      = $FarmFeature.parent
    'properties'                  = $FarmFeature.properties
    'receiverassembly'            = $FarmFeature.receiverassembly
    'receiverclass'               = $FarmFeature.receiverclass
    'requireresources'            = $FarmFeature.requireresources
    'rootdirectory'               = $FarmFeature.rootdirectory
    'scope'                       = $FarmFeature.scope
    'solutionid'                  = $FarmFeature.solutionid
    'status'                      = $FarmFeature.status
    'typename'                    = $FarmFeature.typename
    'uiversion'                   = $FarmFeature.uiversion
    'upgradedpersistedproperties' = $FarmFeature.upgradedpersistedproperties
    'upgradereceiverassembly'     = $FarmFeature.upgradereceiverassembly
    'upgradereceiverclass'        = $FarmFeature.upgradereceiverclass
    'version'                     = $FarmFeature.version
}

$Output = New-Object -TypeName PSObject -Property $Properties
Write-Output $Output
