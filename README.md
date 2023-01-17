# GitHub Export

This tool is written to export your old Pull Requests to a folder full of
readable markdown files.

It is required to have GitHub CLI installed.

```bash

# Start in the root folder of your GitHub project

# Login to your GitHub Account
gh auth login

# Set your default repository for GitHub export
gh repo set-default <owner>/<repo>

# include path where you downloaded this repos
<path-to-ghx>/ghx.sh
```
