# RevvUp — System Architecture

## High-level

```mermaid
flowchart LR
  subgraph mobile [React Native App]
    C[Client UI]
    O[Owner UI]
    A[Auth]
  end
  subgraph api [FastAPI on Vercel]
    P[Public /bikes /showrooms]
    OW[Owner /owner/bikes]
    AD[Admin]
  end
  subgraph data [Supabase]
    DB[(Postgres)]
    AU[Auth JWT]
    ST[Storage]
  end
  A --> AU
  C --> P
  O --> OW
  P --> DB
  OW --> DB
  OW --> ST
  AD --> DB
```

## Multi-vendor rule

Every bike row has `owner_id` referencing `profiles.id` for a showroom owner. Public endpoints return **all** rows; owner endpoints filter `WHERE owner_id = current_user`.

## Submodule repos

| Repo | Responsibility |
| ---- | -------------- |
| `revvup-app` | Docs, submodule pointers, workspace |
| `revvup-frontend` | Expo app, role navigators |
| `revvup-backend` | REST API, email approval |
