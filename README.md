# Qubership Testing Platform Helm Hook Helper

This repository is created to build an auxiliary base docker image for pre-/post-deployment scripts in QSTP Services.

## Build Process

The image is built using GitHub actions for building docker images.

## Usage

It is used when installing QSTP services in the HELPER_IMAGE parameter. 
When installing, a pre-/post-hook pod will be created on this image that will perform pre-/post-actions for the service being installed. 

