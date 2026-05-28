# RevvUp

**RevvUp** is a premium, modern motorbike selling mobile application. Riders explore curated superbikes, inspect detailed hardware specs, and manage accounts through a sleek dark-themed experience.

## Architecture Overview

RevvUp uses a **monorepo + Git submodules** layout: one main repository orchestrates two independently versioned projects.

```
revvup-app/                 ← Main repository (this repo)
├── README.md
├── .gitignore
├── .gitmodules
├── revvup-frontend/        ← Submodule: React Native + NativeWind
└── revvup-backend/         ← Submodule: FastAPI on Vercel
```

| Repository | Stack | Role |
| ---------- | ----- | ---- |
| [revvup-frontend](https://github.com/tharakawijayathilaka/revvup-frontend) | React Native, Expo, NativeWind | Mobile UI — Explore, Catalog, Details, Profile |
| [revvup-backend](https://github.com/tharakawijayathilaka/revvup-backend) | FastAPI, Vercel Serverless | REST API — bikes catalog, specs, auth |

### Why submodules?

- **Independent releases** — Ship frontend and backend on separate cadences.
- **Clear ownership** — Each repo has its own CI, issues, and access control.
- **Single entry point** — Developers clone one umbrella repo and get both projects aligned.

## Clone (Recursive)

To clone the main repo **and** all submodules in one step:

```bash
git clone --recursive https://github.com/tharakawijayathilaka/revvup-app.git
cd revvup-app
```

If you already cloned without `--recursive`:

```bash
git submodule update --init --recursive
```

## Quick Start

### Frontend

```bash
cd revvup-frontend
npm install
npm start
```

See [revvup-frontend/README.md](revvup-frontend/README.md).

### Backend

```bash
cd revvup-backend
python -m venv .venv
.venv\Scripts\activate    # Windows
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

See [revvup-backend/README.md](revvup-backend/README.md).

## API Summary

| Endpoint | Method |
| -------- | ------ |
| `/api/v1/bikes` | `GET` |
| `/api/v1/bikes/{id}` | `GET` |
| `/api/v1/auth/login` | `POST` |
| `/api/v1/auth/register` | `POST` |

## Updating Submodules

Pull latest commits for all submodules:

```bash
git submodule update --remote --merge
```

Or work inside a submodule as its own repo:

```bash
cd revvup-frontend
git checkout main
git pull origin main
cd ..
git add revvup-frontend
git commit -m "chore: bump frontend submodule"
```

## Repository Links

- **Main:** https://github.com/tharakawijayathilaka/revvup-app
- **Frontend:** https://github.com/tharakawijayathilaka/revvup-frontend
- **Backend:** https://github.com/tharakawijayathilaka/revvup-backend

## License

Proprietary — RevvUp © 2026
