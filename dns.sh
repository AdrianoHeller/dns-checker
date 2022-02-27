#! /usr/bin/env bash

# ------------------

echo "This script does a slight network check"

# --------------------

domain_to_check=$1

function check_domain() {
  if [ $domain_to_check ]
    then
      check_ip=$( nslookup $domain_to_check )
      echo "$check_ip"
  else  
      echo "You must provide a domain to be checked"
  fi
  return $check_ip
}

function check_success_log {
  input=$1
  file_name="success.txt"
  if [ -f "$file_name" ]
  then
    $input > $file_name 2> "/dev/null"
  else
    touch "./$file_name"
    $input > $file_name 2> "/dev/null"
  fi      
}

function check_error_log {
  path="./"
  error_log_file="error.txt"
  previous_input_command=$1
  if [ -f "$error_log_file" ]
  then
    $previous_input_command 2> "$path$error_log_file" 1> "/dev/null"
  else
    touch "$path$error_log_file"
    $previous_input_command 2> "$path$error_log_file" 1> "/dev/null"
  fi
}

check_domain
check_success_log check_domain
check_error_log check_domain
