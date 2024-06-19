# ADUserMigration

A PowerShell script to migrate Active Directory user accounts, including profile files, group memberships, user rights, permissions, and mailbox data.

## Features

- Creates a new Active Directory user account.
- Copies group memberships from the old user to the new user.
- Copies user profile and files.
- Transfers user rights and permissions.
- Transfers mailbox data (if applicable).

## Prerequisites

- Active Directory PowerShell module.
- ExchangeOnlineManagement module (if transferring mailbox data).
- Administrative rights to run PowerShell commands.
- Proper permissions to access user profiles and mailbox data.

## Usage

1. Clone the repository:
    ```shell
    git clone https://github.com/your-github-username/ADUserMigration.git
    cd ADUserMigration
    ```

2. Open `migrate_user.ps1` and modify the variables at the beginning of the script to match your environment:
    ```powershell
    $OldUserName = "OldUserName"
    $NewUserName = "NewUserName"
    $DisplayName = "New User Display Name"
    $FirstName = "FirstName"
    $LastName = "LastName"
    $UserPrincipalName = "$NewUserName@yourdomain.com"
    $OldUserProfilePath = "C:\Users\$OldUserName"
    $NewUserProfilePath = "C:\Users\$NewUserName"
    ```

3. Run the script in PowerShell:
    ```powershell
    .\migrate_user.ps1
    ```

4. Follow the prompts to enter the password for the new user.

## Notes

- Ensure you have the necessary permissions and modules installed.
- The mailbox transfer section is optional and should be modified or removed if not applicable.
- The script includes a wait loop to handle mailbox export and import requests. Adjust the sleep duration as needed based on your environment.
