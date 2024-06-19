# Define Variables
$OldUserName = "OldUserName"
$NewUserName = "NewUserName"
$DisplayName = "New User Display Name"
$FirstName = "FirstName"
$LastName = "LastName"
$UserPrincipalName = "$NewUserName@yourdomain.com"
$OldUserProfilePath = "C:\Users\$OldUserName"
$NewUserProfilePath = "C:\Users\$NewUserName"

# Get Secure Password
$Password = Read-Host "Enter Password for new user" -AsSecureString

# Step 1: Create New AD User Account
Write-Output "Creating new user account..."
New-ADUser -Name $DisplayName -GivenName $FirstName -Surname $LastName -SamAccountName $NewUserName -UserPrincipalName $UserPrincipalName -AccountPassword $Password -Enabled $true

# Step 2: Copy Group Memberships from Old User to New User
Write-Output "Copying group memberships..."
$Groups = Get-ADUser $OldUserName -Properties MemberOf | Select-Object -ExpandProperty MemberOf
foreach ($Group in $Groups) {
    Add-ADGroupMember -Identity $Group -Members $NewUserName
}

# Step 3: Copy User Profile and Files
Write-Output "Copying user profile and files..."
if (-Not (Test-Path $NewUserProfilePath)) {
    New-Item -ItemType Directory -Path $NewUserProfilePath
}
Robocopy $OldUserProfilePath $NewUserProfilePath /MIR /SEC /SECFIX /COPYALL /R:0 /W:0

# Step 4: Transfer User Rights and Permissions
Write-Output "Transferring user rights and permissions..."
icacls $NewUserProfilePath /grant "$NewUserName:(OI)(CI)F"
icacls $OldUserProfilePath /grant "$NewUserName:(OI)(CI)F" /replace $OldUserName $NewUserName

# Step 5: Transfer Mailbox (If Applicable)
# Note: Modify or remove this section if not using Exchange or not needed
Write-Output "Transferring mailbox..."
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName admin@yourdomain.com -ShowProgress $true

Add-MailboxPermission -Identity $OldUserName -User $NewUserName -AccessRights FullAccess -InheritanceType All

# Export and Import Mailbox Data
# Note: This process might take a while depending on the mailbox size
New-MailboxExportRequest -Mailbox $OldUserName -FilePath "\\PathToSave\PSTFile.pst"
# Wait for the export request to complete before importing
do {
    $exportStatus = Get-MailboxExportRequest -Status Completed -Mailbox $OldUserName
    Start-Sleep -Seconds 30
} while ($exportStatus -eq $null)

New-MailboxImportRequest -Mailbox $NewUserName -FilePath "\\PathToSave\PSTFile.pst"

# Cleanup
Write-Output "User migration completed. Please verify the new account."

# End of script
