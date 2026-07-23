# Mateo governance

Mateo is stewarded by Ventairy and developed in public. The maintainers listed
in [CODEOWNERS](.github/CODEOWNERS) are responsible for the project direction,
review standards, releases, security response, and Code of Conduct enforcement.

## Roles

- Contributors report problems, propose ideas, improve documentation, write
  tests, and submit code or design changes.
- Reviewers provide informed feedback in an area they understand and help a
  contribution reach Mateo's quality bar.
- Maintainers merge pull requests, resolve design disagreements, manage public
  APIs, and operate releases and security processes.

Sustained, constructive contribution and sound judgment are the path toward
broader review or maintenance responsibility. Maintainer access is granted by
the existing maintainers when the trust and project need are clear.

## Decisions

Small changes are decided through pull-request review. Broad foundation,
component, API, taxonomy, or governance changes begin with an issue and aim for
rough consensus. Maintainers make the final decision when consensus is not
possible, explaining the tradeoff in the issue or pull request.

Mateo's authored design system remains the source of truth. Platform packages
may differ where native conventions require it, but an implementation does not
silently redefine the shared contract.

## Releases

Only maintainers can merge Release Please pull requests, create bootstrap tags,
approve registry environments, or publish packages. Release policy is defined
in [RELEASES.md](RELEASES.md) and each package's release checklist.
