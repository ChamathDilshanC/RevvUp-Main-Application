# Contributing to RevvUp

## GitHub account

All commits and repository access must use the project owner account:

**https://github.com/ChamathDilshanC**

Do not push as automated bot accounts (e.g. Cursor Agent, GitHub Actions bots on personal forks unless intentional).

## Commit author (local)

Before your first commit, set identity **only in this repo** (from repo root):

```bash
git config user.name "Chamath Dilshan"
git config user.email "150304779+ChamathDilshanC@users.noreply.github.com"
```

Submodules (`revvup-frontend`, `revvup-backend`) need the same in each folder if you commit inside them.

## Submodule workflow

```bash
git clone --recursive https://github.com/ChamathDilshanC/main-application.git
cd main-application
```

After changing a submodule:

```bash
cd revvup-frontend
git add -A && git commit -m "your message" && git push origin main
cd ..
git add revvup-frontend
git commit -m "chore: bump frontend submodule"
git push origin main
```

## Adding collaborators

Repo owner adds collaborators in GitHub: **Settings → Collaborators**. They use their own GitHub login; commits appear under their usernames.
