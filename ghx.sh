#!/bin/bash
set -e

# Max number of PRs
LIMIT=500

# Check Output Folder
if [[ -z "${OUTPUT_FOLDER}" ]]; then
    # Set to default
    OUTPUT_FOLDER="ghexport"
# else
    # Folder is set
fi
mkdir -p $OUTPUT_FOLDER

PR_LIST_FILE="$OUTPUT_FOLDER/pr_list.txt"
gh pr list --json number --state closed --jq '.[].number' -L $LIMIT > $PR_LIST_FILE

lines=$(cat $PR_LIST_FILE)
for PR_NUMBER in $lines
do
    # Export PR into md file
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


' > $FILE_NAME

done

# ## Assignees
# {{range .assignees}}{{.login .name}}{{end}}
