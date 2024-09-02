#!/bin/bash
set -ex

CHANGESET_OPTION="--no-execute-changeset"

if [ $# -ne 1 ]; then
  if [ $# = 2 ] && [ $2 = "deploy" ]; then
      echo "deploy mode"
      CHANGESET_OPTION=""
  else
      echo "Setted $# input." 1>&2
      echo "Usage: ./${0##*/} {INPUT_FILE_PATH} deploy" 1>&2
      exit 1
  fi
fi

INPUT_FILE=$1
source ${INPUT_FILE}

STACK_NAME=VPC-Subnets-RouteTable-NACL-${ServiceName}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

aws --region "ap-northeast-1" \
    cloudformation deploy \
    --stack-name "${STACK_NAME}" \
    --capabilities CAPABILITY_NAMED_IAM \
    --template-file "${DIR}/vpc-subnet-resources.yaml" \
    --parameter-overrides `cat ${DIR}/${INPUT_FILE}` \
    ${CHANGESET_OPTION}

