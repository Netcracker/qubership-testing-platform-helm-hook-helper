# Qubership Testing Platform Helm Hook Helper

This repository is created to build an auxiliary base docker image for pre-/post-deployment scripts in Qubership Testing Platform Services.

## Build Process

The image is built using GitHub actions for building docker images.

## Usage

It is used via HELPER_IMAGE parameter when installing Qubership Testing Platform services. 
When installing, a pre-/post-hook pod will be created on this image that will perform pre-/post-actions for the service being installed.

### Usage example

- Navigate to https://github.com/Netcracker/qubership-testing-platform-itf-executor repository,
- main branch,
- .github/deploy_templates/values-dev.yaml file

```yaml
HELPER_IMAGE: "ghcr.io/netcracker/qubership-testing-platform-helm-hook-helper:main-20250714085543"
```

All 'qubership-testing-platform-*' repositories of services use this schema to build docker images.
