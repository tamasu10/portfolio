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

ServiceName=ECS-cluster
INPUT_FILE=$1
source ${INPUT_FILE}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

aws --region "ap-northeast-1" \
    cloudformation deploy \
    --stack-name "${ProjectCategoryName}-${ServiceName}${TargetEnvNameSuffix}" \
    --capabilities CAPABILITY_NAMED_IAM \
    --template-file "${DIR}/ecs-cluster.yaml" \
    --parameter-overrides `cat ${DIR}/${INPUT_FILE}` \
    ${CHANGESET_OPTION}