#!/bin/bash

function usage() {
cat <<EOS
Usage:  $0

 引数はありません。

EOS
  exit 1
}

function parse_args(){
  if [[ $# != 0 ]]; then
    usage
  fi
}

function set_env(){
  readonly CURRENT_IP=$(curl -s http://checkip.amazonaws.com/)
  readonly TFVARS_FILE="./terraform.tfvars"
  source ./.env_for_cron
}

function diff_check(){
  local -r _current_ip="$1"

  if [[ "$_current_ip" == "$(grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$TFVARS_FILE")" ]]; then
    echo "IP address has not been changed."
    exit 0
  else
    echo "IP address has been changed. $_current_ip -> $(grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$TFVARS_FILE")"
  fi
}

function change_ip(){
  local -r _current_ip="$1"

  sed -i -E "s/(my_global_ip = \")([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})(\")/\1${_current_ip}\3/" "$TFVARS_FILE"
}

function terraform_apply(){
  terraform init -no-color
  terraform apply -auto-approve -no-color
}

function main(){
  set_env
  diff_check "$CURRENT_IP"
  change_ip "$CURRENT_IP"
  terraform_apply
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  parse_args "$@"
  main
fi
