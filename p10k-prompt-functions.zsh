#!/bin/zsh

function prompt_environment_name() {
  if [[ -v ENVIRONMENT_NAME ]]; then
    if [[ $ENVIRONMENT_NAME == "PROD" ]]; then
      p10k segment -f red -t "${ENVIRONMENT_NAME}"
    elif [[ $ENVIRONMENT_NAME == "UAT" ]]; then
      p10k segment -f yellow -t "${ENVIRONMENT_NAME}"
    else
      p10k segment -f green -t "${ENVIRONMENT_NAME}"
    fi
  else
    p10k segment -f green -t "No ENV Name"
  fi
}

function instant_prompt_environment_name() {
  prompt_environment_name
}

function prompt_container_name() {
  if [[ -v CONTAINER_NAME ]]; then
    p10k segment -b white -f red -t "${CONTAINER_NAME}"
  fi
}

function instant_prompt_container_name() {
  prompt_container_name
}