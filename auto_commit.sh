#!/bin/bash

# Start date
start_date="2023-12-30"
current_date=$start_date
last_date=$start_date

# Define tasks
tasks=(
    "echo 'Task 1: Writing to a file' >> ${current_date}.txt"
    "echo 'Task 2: Appending some random text' >> ${current_date}.txt"
    "echo 'Task 3: Logging the current date' > ${current_date}.log"
    "echo 'Task 4: Creating a backup file' > ${current_date}_backup.txt"
    "echo 'Task 5: Writing a random number' > ${current_date}_random.txt; echo \$RANDOM >> ${current_date}_random.txt"
)

# Loop for 250 days
for (( i=1; i<=543; i++ )); do
    # Determine if it's a commit day or not (60% chance of a commit)
    commit_day=$((RANDOM % 10))
    if [ $commit_day -lt 3 ]; then
        # Determine the number of commits for this day
        num_commits=1
        # On random days, make more than one commit
        if [ $((RANDOM % 5)) -eq 0 ]; then
            num_commits=$((RANDOM % 3 + 2))  # Make 2 or 3 commits
        fi

        # Loop to make multiple commits
        for (( c=1; c<=$num_commits; c++ )); do
            # Determine the number of tasks to run (between 1 and 5)
            num_tasks=$((RANDOM % 5 + 1))

            # Shuffle the task indices
            indices=($(seq 0 4 | shuf))

            # Run the selected number of tasks
            for (( j=0; j<num_tasks; j++ )); do
                eval "${tasks[${indices[$j]}]}"
            done

            # Git operations
            git add .
            git commit -m "updates for $current_date"

            # Set the Git committer date and amend the commit
            git commit --amend --no-edit --date="$current_date 14:00:00"
        done
    fi

    # Move to the next day
    last_date=$current_date
    current_date=$(date -I -d "$current_date + 1 day")
done
