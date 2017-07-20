
$Parameters = @{
	'Name'                         = '<String>'
	'Comment'                      = '<String>'
	'ExchangeLocation'             = '<MultiValuedProperty>'
	'Force'                        = '<SwitchParameter>'
	#'Mode'                         = 'Enable' #default
	#'Mode'                         = 'TestWithNotifications'
	'Mode'                         = 'TestWithoutNotifications'
	#'Mode'                         = 'Disable'
	'OneDriveLocation'             = '<MultiValuedProperty>'
	'OneDriveLocationException'    = '<MultiValuedProperty>'
	'SharePointLocation'           = '<MultiValuedProperty>'
	'SharePointLocationException'  = '<MultiValuedProperty>'
} #End Parameters

# See https://technet.microsoft.com/en-us/library/mt627834(v=exchg.160).aspx for detail