#!/bin/bash

OUTPUT_FOLDER='github_export'
mkdir -p $OUTPUT_FOLDER
LIMIT=2

# PRS=$(gh pr list -s closed -L 500 --json number,title,author,url,mergedAt) # | jq -r '.[] | select(.mergedAt != null) | select(.author.login == "github-actions[bot]") | select(.labels[].name == "chore") | select(.labels[].name == "release") | .url' | xargs -I {} gh pr view {} --json commits --jq '.commits.nodes[].commit.message' | grep -Eo 'chore\(release\): [0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1 | cut -d ' ' -f 2
PR_LIST_FILE="$OUTPUT_FOLDER/pr_list.txt"
gh pr list --json number --state closed --jq '.[].number' -L $LIMIT > $PR_LIST_FILE

lines=$(cat $PR_LIST_FILE)
for PR_NUMBER in $lines
do
    echo "Current PR: $PR_NUMBER "
    FILE_NAME="$OUTPUT_FOLDER/$PR_NUMBER.md"
    echo "Filename: $FILE_NAME"

    gh pr view $PR_NUMBER --json number,title,body,reviews,assignees,author,commits \
        --template   '{{printf "# %v" .number}} {{.title}}

Author: {{.author.name}} - {{.author.login}}

{{.body}}

## Commits
{{range .commits}}
- {{ .messageHeadline }} [ {{range .authors}}{{ .name }}{{end}} ]{{end}}

## Reviews

{{range .reviews}}{{ .body }}{{end}}

## Assignees
{{range .assignees}}{{.login .name}}{{end}}

' > $FILE_NAME

done