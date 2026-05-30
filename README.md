# RevvUp

**RevvUp** is a premium, multi-vendor motorbike marketplace mobile application. Verified **showroom owners** list and manage inventory per shop; **clients** browse a unified catalog across all showrooms with a sleek dark UI.

## Multi-vendor architecture

```
revvup-app/                    ← Main repository (Git submodules)
├── README.md
├── .gitignore
├── .gitmodules
├── revvup-frontend/           ← Submodule: React Native + NativeWind
└── revvup-backend/            ← Submodule: FastAPI on Vercel Serverless
```

| Role | Frontend experience | Backend access |
| ---- | ------------------- | -------------- |
| **Client** | Explore, Catalog, Bike details (read-only) | `GET /api/v1/bikes`, `GET /api/v1/bikes/{id}`, `GET /api/v1/showrooms` |
| **Showroom owner** | Dashboard, inventory CRUD, showroom profile | `GET/POST/PUT/DELETE /api/v1/owner/bikes`, `PATCH /api/v1/owner/showroom/me` |
| **Admin** | Approval workflows (email + API) | Admin endpoints + full owner capabilities |

Owners register as `showroom_owner` (API role). After developer email approval, status becomes `active` and owner routes unlock.

## Permission matrix

| Action | Client | Showroom owner | Admin |
| ------ | :----: | :------------: | :---: |
| Browse all bikes | ✅ | ✅ | ✅ |
| View bike details | ✅ | ✅ | ✅ |
| List showrooms | ✅ | ✅ | ✅ |
| Create / edit / delete bikes | ❌ | ✅ (own only) | ✅ |
| Edit own showroom profile | ❌ | ✅ | ✅ |
| Approve pending owners | ❌ | ❌ | ✅ |

## Tech stack

| Layer | Technology |
| ----- | ---------- |
| Mobile | React Native (Expo), NativeWind, React Navigation |
| API | FastAPI, Pydantic, Vercel Serverless |
| Data | Supabase (Postgres, Auth, Storage) |

## Clone (recursive)

```bash
git clone --recursive https://github.com/ChamathDilshanC/revvup-app.git
cd revvup-app
git submodule update --init --recursive
```

Legacy umbrella repo: [main-application](https://github.com/ChamathDilshanC/main-application) (same layout).

## Quick start

### Frontend

```bash
cd revvup-frontend
npm install
cp .env.example .env   # EXPO_PUBLIC_API_URL
npx expo start
```

### Backend

```bash
cd revvup-backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload --port 8000
```

## Submodule workflow

```bash
# Pull latest in all submodules
git submodule update --remote --merge

# Commit pointer bump in main repo
git add revvup-frontend revvup-backend
git commit -m "chore: bump submodules"
```

## Repository links

| Repo | URL |
| ---- | --- |
| Main | https://github.com/ChamathDilshanC/revvup-app |
| Frontend | https://github.com/ChamathDilshanC/revvup-frontend |
| Backend | https://github.com/ChamathDilshanC/revvup-backend |

## Developer

**Chamath Dilshan** — [GitHub](https://github.com/chamathdilshanc) · [LinkedIn](https://www.linkedin.com/in/chamathdilsahnc/) · dilshancolonne123@gmail.com

Proprietary — RevvUp © 2026
