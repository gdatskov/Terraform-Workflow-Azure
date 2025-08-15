# About

This project aims to demonstrate CI/CD with Github Actions and IaaC automated provisioning and deployment with Terraform, using MS Azure as a cloud provider -  
Terraform configuration for provisioning Azure resources and deploying the "TaskBoard" Web app (provided as a ready-to-deploy app from SoftUni) to Azure Web Apps, uploading it to GitHub and using GitHub Actions workflows to test and run the configuration.

# Resources and functionality:
1. "TaskBoard" Web app (.NET):
   - ready to be uploaded as a GitHub repository - in this case, added as a repo here: https://github.com/gdatskov/TaskBoard-Azure-Web-App-with-Database.git
   - ready to be deployed
2. Terraform configuration files:
   - main.tf - main terraform configuration file, specifying IaaC automated provisioning steps to deploy the app on the MS Azure cloud service
   - variables.tf – contains variable declarations, as addition to the main configuration file
   - outputs.tf – contains outputs declarations, as addition to the main configuration file
   - values.tfvars – contains values for the variables, defined in variables.tf (used to customize the deployment)
3. GitHub Actions CI/CD workflow:
One unified workflow, automating the integration and deployment of the application - on push to the "main" branch, as well as an option to run the workflow manually.  
  3.1. Test  
  3.2. Plan required provisioning steps  
  3.3. Deploy, by also providing required resources  

# Requirements:
1. Active MS Azure subscription. The ID of the subscription must be provided in the values.tfvars file as azure_subscription_id = [azure_subscription_id]
2. Azure CLI installed
3. MS Entra App (Azure AD principal account), aka RBAC
  Can be created with the following command:  
    `az ad sp create-for-rbac --name ["unique_name"] --role contributor --scopes /subscriptions/[subscription_id] --sdk-auth`
   - TODO: Create automated workflow creating it automatically by a click of a button.
4. Add the credentials of the principal account as GitHub Actions Secrets:
   - AZURE_CREDENTIALS (the returned JSON from the RBAC creation)
   - AZURE_CLIENT_ID
   - AZURE_CLIENT_SECRET
   - AZURE_SUBSCRIPTION_ID
   - AZURE_TENANT_ID
5. Provisioning to store the application's provision state (terraform.tfstate):  
   5.1. Create a resource group for the storage  
     `az group create --name [storage_resource_group_name] --location [location(region)]`  
   5.2. Create a storage account (inside the resource group)  
     `az storage account create --name [storage_account_name] --resource-group [storage_resource_group_name] --location [location(region)] --sku Standard_LRS --kind StorageV2`  
   5.3. Create a storage container (inside the account)  
     `az storage container create -n [storage_container_name] --account-name [storage_account_name]`  
   5.4. TODO: Automate steps 5.1. 5.2. 5.3.
6. TODO: Automate and connect everything from step 2 to step 5

# Screenshots:
<img width="1918" height="948" alt="image" src="https://github.com/user-attachments/assets/2c2a9a8d-0457-4073-8f89-e55f8564dad4" />
<img width="1535" height="837" alt="image" src="https://github.com/user-attachments/assets/80cda0dc-dc16-4f8b-bd5c-5fded3f3daac" />
<img width="1919" height="890" alt="image" src="https://github.com/user-attachments/assets/da99bdf3-5a08-4784-b174-f110be54f580" />
<img width="1356" height="713" alt="image" src="https://github.com/user-attachments/assets/57b80f0a-fe53-4265-9d79-b361aa394869" />
<img width="1223" height="618" alt="image" src="https://github.com/user-attachments/assets/f4f0265d-5482-4af9-b0f4-3d2d62fcca00" />





   

