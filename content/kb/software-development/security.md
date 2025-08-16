---
title: Security
---

Security in software development.

<!--more-->

## Access Control

Solutions and engines:

- [Authelia](https://www.authelia.com/) [[github](https://github.com/authelia/authelia)] - open-source authentication and authorization server and portal fulfilling the identity and access management (IAM)...
- [Cerbos](https://cerbos.dev/) - open source, decoupled access control for your software:
    - [Filtering data using authorization logic](https://cerbos.dev/blog/filtering-data-using-authorization-logic),
    - [Cerbos’s Secret Ingredients: Protobufs and gRPC](https://thenewstack.io/cerboss-secret-ingredients-protobufs-and-grpc/).
- [Open Policy Agent](https://www.openpolicyagent.org/) - open source policy engine:
    - [Partial Evaluation](https://blog.openpolicyagent.org/partial-evaluation-162750eaf422),
    - [Write Policy in OPA. Enforce Policy in SQL.](https://blog.openpolicyagent.org/write-policy-in-opa-enforce-policy-in-sql-d9d24db93bf4).
- [OPAL](https://github.com/permitio/opal) - administration layer for Policy Engines,
- [Oso](https://docs.osohq.com/):
    - [Filter Data](https://www.osohq.com/docs/oss/guides/data_filtering.html),
    - [Why Authorization is Hard](https://www.osohq.com/blog/why-authorization-is-hard).
- [OpenFGA](https://openfga.dev/).
- [SpiceDB](https://github.com/authzed/spicedb) - an open-source, Google Zanzibar-inspired database for FGA.
- Zanzibar:
    - [What is Google Zanzibar?](https://www.osohq.com/learn/google-zanzibar),
    - [Understanding Google Zanzibar: A Comprehensive Overview](https://authzed.com/blog/what-is-google-zanzibar).

Documentation of other systems:

- JIRA:
  - [How do Jira permissions work?](https://support.atlassian.com/jira-work-management/docs/how-do-jira-permissions-work/)
- Google Drive:
  - https://developers.google.com/drive/api/guides/manage-sharing
  - https://developers.google.com/drive/api/v3/reference/permissions
  - https://developers.google.com/drive/api/guides/ref-roles

Glossary, related terminology and concepts:

- FGA - Fine Grained Authorization,
- ABAC - attribute based access control,
- ReBAC - relationship-based access control.
- Reverse Indexing - query resources user has access to.

Other: 

- https://goauthentik.io/
- https://www.reddit.com/r/selfhosted/comments/191879o/authentik_and_authelia_does_it_matter/?rdt=56913
- https://www.permit.io/blog/mac-dac-rbac-and-fga-and-access-control
