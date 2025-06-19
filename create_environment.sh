#!/bin/bash
# This script is going to permit a working environment for the submission_reminder.

#User is asked to enter their name
read -p "Enter your name: " User_name
submi_dir="submission_reminder_${User_name}"
echo "Creating directory: $submi_dir"
mkdir -p "$submi_dir"

echo "Creating subdirectories"
mkdir -p "$submi_dir/app"
mkdir -p "$submi_dir/modules"
mkdir -p "$submi_dir/assets"
mkdir -p "$submi_dir/config"

#Creating files corresponding to each subdirectory
touch "$submi_dir/app/reminder.sh"
touch "$submi_dir/modules/functions.sh"
touch "$submi_dir/assets/submissions.txt"
touch "$submi_dir/config/config.env"
touch "$submi_dir/startup.sh"

#Inputting data in reminder.sh
cat > "$submi_dir/app/reminder.sh" <<EOF
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions \$submissions_file
EOF

#Inputting data in functions.sh
cat > "$submi_dir/modules/functions.sh" <<EOF
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOF

#Inputting data in the config.env
cat > "$submi_dir/config/config.env" <<EOF
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

#Inputting data in submissions.txt and adding my own as well
cat > "$submi_dir/assets/submissions.txt" <<EOF
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Breuil, Shell Navigation, submitted
Carol, Shell Basics, not submitted
Yoni, Git, submitted
Nouga, Shell Navigation, submitted
Tucker, Shell Basics, not submitted
EOF

#Making our scripts executable
cat > "$submi_dir/startup.sh" <<EOF
#!/bin/bash
echo "Launching the Submission Reminder App"
source config/config.env
echo "Assignment: \$ASSIGNMENT for user \$USER"
bash app/reminder.sh
EOF

# Make all .sh files inside the project executable
echo "Making all shell scripts executable."
find "$submi_dir" -type f -name "*.sh" -exec chmod +x {} \;

echo "Setup complete"
