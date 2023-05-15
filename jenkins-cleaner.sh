#!/bin/bash

jenkins_directory=/var/lib/jenkins/jobs
# log_file=/root/jenkins-job-cleaner/logs/`date '+%Y-%m-%d'`_cleaner-log.txt

cd $jenkins_directory
directories=(*)

for dir in "${directories[@]}"
do
    cd $jenkins_directory/$dir/builds
    echo "In job $dir" # >> $log_file
    count=$(ls -1 | grep -v "^d" | wc -l)
    if [ "$count" -gt 5 ] && [ "$dir" != "clean-jenkins-jobs" ]
    then
        my_array=(*)
        my_array=($(echo "${my_array[@]}" | tr ' ' '\n' | sort -d | sort -n))
        new_array=("${my_array[@]:2:${#my_array[@]}-5}")

        for subdir in "${new_array[@]}"
        do
            rm -r $subdir
            echo "  Build $subdir is deleted" # >> $log_file
        done
    else
       echo "  Skipped" # >> $log_file
    fi
done
