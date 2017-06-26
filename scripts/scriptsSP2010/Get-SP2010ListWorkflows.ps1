$Site = "https://sharepoint.example.com"
$SiteCollection = get-spsite -identity $Site

$lists = foreach ($web in $SiteCollection.AllWebs) {
    foreach ($list in $web.lists) {
        if ($list.NoCrawl -eq $false -and $list.IsApplicationList -eq $false -and $list.RootWebOnly -eq $false -and $list.AllowDeletion -eq $true -and $list.BaseType -eq 'GenericList') {
            $properties = @{
				'BaseType'                    = $list.BaseType
				'ContentTypes'                = ($list.ContentTypes | Measure-Object).count
				'Created'                     = get-date ($list.Created) -format "dd/MM/yyyy hh:mm:ss"
				'Description'                 = $list.Description
				'EnableAttachments'           = $list.EnableAttachments
				'EnableVersioning'            = $list.EnableVersioning
				'Fields'                      = ($list.Fields | Measure-Object).count
				'Hidden'                      = $list.Hidden
				'IsApplicationList'           = $list.IsApplicationList
				'IsSiteAssetsLibrary'         = $list.IsSiteAssetsLibrary
				'ItemCount'                   = $list.ItemCount
				'LastItemDeletedDate'         = get-date ($list.LastItemDeletedDate) -format "dd/MM/yyyy hh:mm:ss"
				'LastItemModifiedDate'        = get-date ($list.LastItemModifiedDate) -format "dd/MM/yyyy hh:mm:ss"
				'MajorVersionLimit'           = $list.MajorVersionLimit
				'MajorWithMinorVersionsLimit' = $list.MajorWithMinorVersionsLimit
				'Title'                       = $list.Title
				'Views'                       = ($list.Views | Measure-Object).count
				'WorkflowAssociations'        = ($list.WorkflowAssociations | Measure-Object).count
				'Author'                      = $list.Author
				'RootFolder'                  = $list.RootFolder
				'DefaultDisplayFormUrl'       = $list.DefaultDisplayFormUrl
				'DefaultDisplayFormUrlCount'  = ($list.DefaultDisplayFormUrl | Measure-Object -Character).count
				'EnableMinorVersions'         = $list.EnableMinorVersions
				'RootWebOnly'                 = $list.RootWebOnly
				'IsCatalog'                   = $list.IsCatalog
				'ShowUser'                    = $list.ShowUser
				'NoCrawl'                     = $list.NoCrawl
				'RestrictedTemplateList'      = $list.RestrictedTemplateList
				'HasExternalDataSource'       = $list.HasExternalDataSource
				'Version'                     = $list.Version
				'AllowDeletion'               = $list.AllowDeletion
            } # $properties
                        
            $Output = New-Object -TypeName PSObject -Property $properties
            $Output.PSObject.TypeNames.Insert(0,'Contoso.SharePoint.ListInfo')
            write-output $output
        } # if
    } # foreach $list
    $web.dispose()
} # foreach $web
$SiteCollection.dispose()
Write-Output $lists
