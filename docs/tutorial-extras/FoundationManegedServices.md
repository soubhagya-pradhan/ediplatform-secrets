# EDI Platform Foundation

This repo shall be used by propositions for onboarding foundation managed services. Foundation is a proposition onboarded to the [edi-platform](https://github.com/philips-internal/edi-platform) to get the HSDP managed resources information as well as onboarded tenant information.

## What is deployed?

1. [EDI Authentication Gateway](https://github.com/philips-internal/edi-foundation-envoy-gateway) using the [terraform module](https://github.com/philips-internal/terraform-api-gateway)
2. [Configuration Service](https://tfsemea1.ta.philips.com/tfs/TPC_Region11/SAL/_git/SA-Configuration-Service)
3. [ID Token Validator](https://github.com/philips-internal/edi-foundation-idtoken-validator)
4. [PKI Certificates](https://www.hsdp.io/documentation/public-key-infrastructure/) for all the platform onboarded tenants which will enable token exchange using Vue SSO
5. [OAuth Client Credentials](https://www.hsdp.io/documentation/identity-and-access-management-iam/how-to/token-exchange-integrator-guide) for token exchange onboarding


## How is it deployed?

This foundation managed services is deployed using terragrunt configuration that will enable a multi-environment and region deployment strategy. The deployment is split up into distinct modules that can be built on top of one another and are able to pass outputs from one to inputs of another. This is done to ensure we can deploy things that need to change frequently in isolation of things that do not need to change often. Thus not putting important low change infrastructure at risk with each deployment.

The actual deployment pipeline is handled by GitHub actions that include the planning phase included with a gated deployment phase. In this way you can inspect the plan and decide if you with to allow the deploy to continue. If you are using a pull request the plan will also be added as a comment to the PR so you can view it there.

## How to onboard ?

For a proposition to access foundation managed secrets it first needs to be on-boarded. A proposition can onboard per region by adding the proposition details to the proposition list inside the `terragrunt.hcl` within the proposition folder of each region.

### Required information for propositions

The following information is required for onboarding. Fork the repo and raise a PR with the following information.

| Value                 | Description                                                                                                                                                                                                                                             |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name                  | This is the short name of your proposition and will be used to create resources. Its best to keep this under 8 characters and be aware it will be uppercase in some usages.                                                                             |
| description           | This is a long description of your proposition and will be used where a description is needed when creating new resources                                                                                                                               |
| azure_object_ids      | This is a list of Azure active directory object Ids that will be given access to the Azure resources created as part of the onboarding process. You can add multiple ids here. They can be groups, users or service principals. Groups are recommended. |  

### Proposition Secrets and variables

Once your request is approved you will get access to a vault with the following information.

 - Azure
    - PKI Certificates for each tenants
    - Client Credentials for each tenant (used for token exchange)
    - Gateway Endpoint of the onboarded region

More about the design and architecture can be found [here](./docs/design.md)