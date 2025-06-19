#!/bin/bash

read -p "Enter the new assignment name: " new_assignment

if [ ! -f config/config.env ]; then
	    echo "Config file not found!"
	        exit 1
fi

sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" config/config.env

echo "Assignment changed to $new_assignment"

/submission_reminder_Sheja/startup.sh


