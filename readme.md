# Safe IG Unfollower (Dry-Run)

This is a **safe educational demo tool** that simulates an Instagram unfollower bot using Bash + curl.  
⚠️ **Important:** This script does **not** unfollow by default. It runs in **dry-run mode**, meaning it only shows what it *would* do. To enable actual unfollowing, you must manually set `EXECUTE=1` in the script.

---

## Features
- 🔒 **Safe by default** → runs in dry-run mode.
- 📜 Logs all actions to `unfollower.log`.
- 🛠️ Functions for fetching following list, simulating unfollows.
- ⏱️ Built-in delay between requests.
- 🧹 Clean, modern Bash structure.

---

## Usage
1. Clone repo & make script executable:
   ```bash
   git clone https://github.com/taezeem14/safe-ig-unfollower.git
   cd safe-ig-unfollower
   chmod +x safe-ig-unfollower-dryrun.sh
   ```

2. Run in dry-run mode:
   ```bash
   ./safe-ig-unfollower-dryrun.sh
   ```

3. (Optional) Enable real unfollow mode:
   - Edit the script → set `EXECUTE=1`
   - Confirm prompt by typing `YES`

---

## License
Released under the **MIT License**.

---

## Credits
- Inspired by **HTR-TECH (Tahmid Rayat)**, creator of [Zphisher](https://github.com/htr-tech/zphisher).
- Remixed, cleaned, and made safe by **Taezeem**.

---

## Warning
This is an **educational demo**. Using it to interact with real Instagram accounts may violate Instagram’s Terms of Service and get your account banned.  
Use responsibly — preferably only with dummy accounts for testing. 

---


---

## Banner

```
  ____  _   _ _   _ _   _ _   _
 |  _ \| | | | \ | | | | | \ | |
 | |_) | | | |  \| | | | |  \| |
 |  __/| |_| | . ` | | | | . ` |
 |_|    \___/|_|\__|____/|_|\__|
 Safe IG Unfollower (dry-run)
```

---

## .gitignore (suggested)

```
# logs
*.log

# cookie files
.cookie.*

# system files
.DS_Store

# node / build artifacts
node_modules/
dist/

# OS generated files
Thumbs.db

# editor files
.vscode/
*.swp
```

---


