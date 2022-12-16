# vh-infra-wowza
This project deploys the infrastructure for the Wowza components used within VH. 

The infrastrucure mainly consists of load balancers routing traffic to Linux VMs running the Wowza software. There is also a storage account that stores the recordings. For more information about the Wowza solution please see [here](https://tools.hmcts.net/confluence/x/Nos7Xw)

## Environments
This projects follows the main environments for VH, as shown in the following:

| Environment  | Use | Location | 
| - | - | - | 
| `DEV` | Used as the main environment for development | [vh-infra-wowza-dev](https://portal.azure.com/#@HMCTS.NET/resource/subscriptions/867a878b-cb68-4de5-9741-361ac9e178b6/resourceGroups/vh-infra-wowza-dev/overview) |
| `STG` | Used as a pre-prod type environment and for end-to-end/load testing | [vh-infra-wowza-stg](https://portal.azure.com/#@HMCTS.NET/resource/subscriptions/74dacd4f-a248-45bb-a2f0-af700dc4cf68/resourceGroups/vh-infra-wowza-stg/overview) |
| `PROD` | Used as production | [vh-infra-wowza-prod](https://portal.azure.com/#@HMCTS.NET/resource/subscriptions/5ca62022-6aa2-4cee-aaa7-e7536c8d566c/resourceGroups/vh-infra-wowza-prod/overview) |

## Pipeline
This project uses Azure DevOps to run the pipelines for deploying the infrastructure.

[hmcts.vh-infra-wowza](https://dev.azure.com/hmcts/Video%20Hearings/_build?definitionId=686)

This pipeline is triggered during PRs and when merged in to the `master` branch. The following defines the stages used:

- `Validate_Terraform_Code`
  - Runs basic terraform file validation and format checking
  - Scans the TF config with TFsec  

- `Terraform_Plan_<ENV>`
  - Remove any resource lock
  - Gets secrets from AKV
  - Gets SP details for networking service connection 
  - Accept Wowza usage policy to use the image
  - Set vars for TF
  - TF init/plan
  - Publish TF plan output

- `Terraform_Apply_<ENV>`
  - Download TF plan artifact
  - Gets secrets from AKV
  - TF init/apply
  - Ensure lease on statefile is broken
  - `ApplyExtToEnv` - Gets settings for OMS agent. Installs OMS agent on VMs
  - `MonitoringTasks` - Gets and set authentication for Dynatrace

### PR run

When triggered via a PR the following stages will run:

```mermaid
graph LR;
    A[Validate_Terraform_Code];

        B[Terraform_Plan_Dev]-->|APPROVAL REQUIRED|C;
        C[Terraform_Apply_Dev];

    A --> B;
```

### Master run

When triggered via a merge to `master` or manually triggered from the `master` branch the following stages will run (see above for details of each stage):

```mermaid
graph LR;
    A[Validate_Terraform_Code];
    subgraph DEV
        B[Terraform_Plan_Dev]-->|APPROVAL REQUIRED|C;
        C[Terraform_Apply_Dev];
    end
    subgraph STG
        D[Terraform_Plan_Stg]-->|APPROVAL REQUIRED|E;
        E[Terraform_Apply_Stg];
    end
    subgraph PROD
        F[Terraform_Plan_Prod]-->|APPROVAL REQUIRED|G;
        G[Terraform_Apply_Prod];
    end
    A --> DEV
    DEV --> STG
    STG --> PROD
```