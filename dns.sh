#! /usr/bin/env bash


# -----------CONFIG------------
CONFIG_PROVIDER="script.cf"
#------------TEST--------------
test [ ! -e "$CONFIG_PROVIDER" ] && echo "Current config file does not exist."
test [ ! -r "$CONFIG_PROVIDER" ] && echo "User cannot read current config file."
#------------VARS--------------
IGNORE=
PING=
# -----------INFO----------------

echo "Created by: Adriano Heller"

echo "version: 1.0"

echo "functionalities: DNS check and Reverse DNS check."

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
  local input=$1
  local file_name="success.txt"
  if [ -f "$file_name" ]
  then
    $input > $file_name 2> "/dev/null"
  else
    touch "./$file_name"
    $input > $file_name 2> "/dev/null"
  fi      
}

function check_error_log {
  local path="./"
  local error_log_file="error.txt"
  local previous_input_command=$1
  if [ -f "$error_log_file" ]
  then
    $previous_input_command 2> "$path$error_log_file" 1> "/dev/null"
  else
    touch "$path$error_log_file"
    $previous_input_command 2> "$path$error_log_file" 1> "/dev/null"
  fi
}

function process_external_config {
  local var_key=$( echo $1 | cut -d = -f 1 )
  local var_value=$( echo $1 | cut -d = -f 2 )
  case $var_key in
    IGNORE) IGNORE=$var_value ;;
    PING) PING=$var_value     ;;
  esac   
}

while read -r file_config
do
  test [ echo "$file_config" | cut -d " " -f 1 = "#" ] && continue
  test [ ! "$file_config" ] && continue
  process_external_config "$file_config"    
done < $CONFIG_FILE

check_domain
check_success_log check_domain
check_error_log check_domain
