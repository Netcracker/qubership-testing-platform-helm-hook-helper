# Qubership Testing Platform Helm Hook Helper

This repository builds the auxiliary Docker image that runs the pre- and post-deployment scripts of
Qubership Testing Platform services. A service's Helm chart starts a hook pod from this image, and the pod
runs the service's pre- or post-install actions with the command-line clients the image contains.

The repository holds no application code. It holds a [Dockerfile](Dockerfile) and the GitHub Actions workflows that
build and publish the image.

## Contents of the image

The image is based on `bellsoft/liberica-openjdk-alpine-musl:8u402` (Liberica OpenJDK 8 on Alpine Linux) and sets
`NODE_ENV=production`. It is built for `linux/amd64` only.

| Tool                      | Version | Command            | Typical use in a hook                  |
|---------------------------|---------|--------------------|----------------------------------------|
| `kubectl`                 | 1.28.4  | `kubectl`          | Read or change Kubernetes resources    |
| PostgreSQL client         | 14.17   | `psql`             | Prepare or check a PostgreSQL database |
| MongoDB Shell (`mongosh`) | 2.2.5   | `mongosh`, `mongo` | Prepare or check a MongoDB database    |
| Node.js                   | 21.7.2  | `node`             | Run JavaScript hook scripts            |
| `bash`                    | 5.2.21  | `bash`             | Run shell hook scripts                 |
| `jq`                      | 1.7.1   | `jq`               | Process JSON                           |

`mongo` is a symbolic link to `mongosh`, so scripts written for the legacy `mongo` shell run unchanged. `npm` is
installed only to fetch `mongosh` and is removed from the final image, so a hook cannot install npm packages at run
time. A Java runtime (JDK 8) comes with the base image.

The tool versions are pinned in the [Dockerfile](Dockerfile). Change them there.

## Usage

A Qubership Testing Platform service takes the image through the `HELPER_IMAGE` parameter in its deployment values.
When you install the service, Helm creates the pre- or post-hook pod from that image, and the pod runs the actions
for the service being installed.

Every `qubership-testing-platform-*` service repository uses this scheme.

### Usage example

The ITF Executor service sets the image in its development values:

1. Open the [qubership-testing-platform-itf-executor](https://github.com/Netcracker/qubership-testing-platform-itf-executor)
   repository.
1. Switch to the `main` branch.
1. Open `.github/deploy_templates/values-dev.yaml`.

The file contains the image reference:

```yaml
HELPER_IMAGE: "ghcr.io/netcracker/qubership-testing-platform-helm-hook-helper:main-20250714085543"
```

To use a newer image, replace the tag with one from the
[package page](https://github.com/orgs/Netcracker/packages?repo_name=qubership-testing-platform-helm-hook-helper).

## Build and release

The image is built by GitHub Actions and published to the GitHub Container Registry as
`ghcr.io/netcracker/qubership-testing-platform-helm-hook-helper`. The build settings (the Dockerfile path, the build
context, and the target platform) are in [.github/docker-build-config.json](.github/docker-build-config.json).

### Development builds

The [dev-mvn-docker-build](.github/workflows/dev-mvn-docker-build.yaml) workflow runs on every push to a branch other
than a release, `prettier/*`, or `dependabot/*` branch, and on manual dispatch. It does not run when a push changes
only `docs/**`, `README.md`, or `.github/**`.

The workflow tags the image `<ref-name>-<timestamp>`. For example, `main-20250714085543` is a build of the `main`
branch.

### Releases

The [maven-release-v2](.github/workflows/maven-release-v2.yaml) workflow, titled "Docker Image release", runs only on
manual dispatch. Start it from the Actions tab and select the `version-type` (`major`, `minor`, or `patch`). The
workflow builds and publishes the image for the new version and then creates the GitHub release.

## Contributing

1. Change the [Dockerfile](Dockerfile) on a branch. Pushing the branch publishes a development image that you can
   reference from a service's `HELPER_IMAGE` to test the change.
1. Open a pull request. The title and the commit messages must follow
   [Conventional Commits](https://www.conventionalcommits.org/); the pull request checks verify this.
1. Sign the Contributor License Agreement when the CLA check asks for it.

The repository is maintained by the owners listed in [CODEOWNERS](CODEOWNERS). The license is in [LICENSE](LICENSE).
