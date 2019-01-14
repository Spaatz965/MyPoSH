<#
This script connects to the User Profile managed service application and iterates through all of the properties
that have been configured dumping the result to XML. The script additionally pulls in any mappings to active directory.
Written by Cat Aronson
#>

#Define our configuration. This is the name you gave the import connection to AD
$url="http://sharepoint.example.com";
$connectionName="Profile Sync";

#Setup our SharePoint objects
$site=Get-SPSite$url;
$serviceContext= Get-SPServiceContext($site);
$upManager=new-objectMicrosoft.Office.Server.UserProfiles.UserProfileConfigManager($serviceContext);
$syncConnection=$upManager.ConnectionManager[$connectionName];

#This is a collection of mappings to AD that we will use later 
$pmc=$syncConnection.PropertyMapping;

#This is a collection of all of the properties which we will iterate
$properties=$upManager.GetProperties();

# Create a new XML writer settings object 
$settings=New-Objectsystem.Xml.XmlWriterSettings;
$settings.Indent=$true; 
$settings.OmitXmlDeclaration=$false; 
$settings.NewLineOnAttributes=$true;

# Create a new string writer to capture the output 
$sw=new-objectSystem.IO.StringWriter;

# Create a new XmlWriter 
$writer= [system.xml.XmlWriter]::Create($sw, $settings);

#Start the document and add the root node
$writer.WriteStartDocument();
$writer.WriteStartElement("properties");

#Iterate through the properties
foreach ($item in $properties)
{

    #Create the property element
 $writer.WriteStartElement("property");

    #Add in the fields as attributes
    $writer.WriteAttributeString("Name", $item.Name); 
    $writer.WriteAttributeString("DisplayName",$item.DisplayName);
    $writer.WriteAttributeString("ManagedPropertyName",$item.ManagedPropertyName);
    $writer.WriteAttributeString("Type",$item.Type);
    $writer.WriteAttributeString("ChoiceList",$item.ChoiceList);
    $writer.WriteAttributeString("Description",$item.Description);
    $writer.WriteAttributeString("URI",$item.URI);
    $writer.WriteAttributeString("IsSystem",$item.IsSystem);
    $writer.WriteAttributeString("AllowPolicyOverride",$item.AllowPolicyOverride);
    $writer.WriteAttributeString("IsUserEditable",$item.IsUserEditable);
    $writer.WriteAttributeString("IsAdminEditable",$item.IsAdminEditable);
    $writer.WriteAttributeString("IsImported",$item.IsImported);
    $writer.WriteAttributeString("Length",$item.Length);
    $writer.WriteAttributeString("IsMultivalued",$item.IsMultivalued);
    $writer.WriteAttributeString("ChoiceType",$item.ChoiceType);
    $writer.WriteAttributeString("DefaultPrivacy",$item.DefaultPrivacy);
    $writer.WriteAttributeString("UserOverridePrivacy",$item.UserOverridePrivacy);
    $writer.WriteAttributeString("IsReplicable",$item.IsReplicable);
    $writer.WriteAttributeString("PrivacyPolicy",$item.PrivacyPolicy);
    $writer.WriteAttributeString("DisplayOrder",$item.DisplayOrder);
    $writer.WriteAttributeString("IsColleagueEventLog",$item.IsColleagueEventLog);
    $writer.WriteAttributeString("IsAlias",$item.IsAlias);
    $writer.WriteAttributeString("IsSearchable",$item.IsSearchable);
    $writer.WriteAttributeString("IsUpgrade",$item.IsUpgrade);
    $writer.WriteAttributeString("IsUpgradePrivate",$item.IsUpgradePrivate);
    $writer.WriteAttributeString("IsVisibleOnEditor",$item.IsVisibleOnEditor);
    $writer.WriteAttributeString("IsVisibleOnViewer",$item.IsVisibleOnViewer);
    $writer.WriteAttributeString("IsTaxonomic",$item.IsTaxonomic);
    $writer.WriteAttributeString("Separator",$item.Separator);
    $writer.WriteAttributeString("MaximumShown",$item.MaximumShown);
    $writer.WriteAttributeString("IsSection",$item.IsSection);
    $writer.WriteAttributeString("IsRequired",$item.IsRequired);
    $writer.WriteAttributeString("SubtypeName",$item.SubtypeName);
   
    #Look up any AD mappings in the PropertyManagerCollection and include them
    $writer.WriteAttributeString("IsImport",$pmc.Item($item.Name).IsImport);
    $writer.WriteAttributeString("IsExport",$pmc.Item($item.Name).IsExport);
    $writer.WriteAttributeString("DataSourcePropertyName",$pmc.Item($item.Name).DataSourcePropertyName);
    $writer.WriteAttributeString("OriginalDataSourcePropertyName",$pmc.Item($item.Name).OriginalDataSourcePropertyName);
    $writer.WriteAttributeString("AssociationName",$pmc.Item($item.Name).AssociationName);
    $writer.WriteAttributeString("Connection",$pmc.Item($item.Name).Connection.DisplayName);
    $writer.WriteEndElement();

#Finish up
$writer.WriteEndElement();
$writer.WriteEndDocument();
$writer.Flush(); 
$writer.Close();

#Capture the output into a string
$result=$sw.ToString();

# Write the XML out
Write-Output $result;
