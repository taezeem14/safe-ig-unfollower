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

## Repo Layout
```
README.md
LICENSE
safe-ig-unfollower-dryrun.sh
core/                # stores cookie + following list
.gitignore
```

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

## LICENSE (MIT)

```
MIT License

Copyright (c) 2025 YOUR NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
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
.
