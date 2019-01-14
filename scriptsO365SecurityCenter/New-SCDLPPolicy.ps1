
$Parameters = @{
	'Name'                         = '<String>'
	'Comment'                      = '<String>'
	'Force'                        = '<SwitchParameter>'
	'ExchangeLocation'             = 'All' 
	#'Mode'                         = 'Enable' #default
	#'Mode'                         = 'TestWithNotifications'
	'Mode'                         = 'TestWithoutNotifications'
	#'Mode'                         = 'Disable'
	'OneDriveLocation'             = "all" #'<MultiValuedProperty>'
	#'OneDriveLocationException'    = '<MultiValuedProperty>'
	'SharePointLocation'           = "all" #'<MultiValuedProperty>'
	#'SharePointLocationException'  = '<MultiValuedProperty>'
} #End Parameters

# See https://technet.microsoft.com/en-us/library/mt627834(v=exchg.160).aspx for detail