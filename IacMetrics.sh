#!/bin/bash

while getopts a:p:t:b:n: flag
do
    case "${flag}" in
        a) TEAM=${OPTARG};;
        p) PROJECT=${OPTARG};;
        t) PIPELINE=${OPTARG};;
        b) BRANCH=${OPTARG};;
        n) BUILD=${OPTARG};;
    esac
done

DATE=$(date +%Y%m%d%H%M%S)

OUTPUT_FILE="iac-scan-${TEAM:-team}-${PROJECT:-project}-${PIPELINE:-pipeline}-${BRANCH:-branch}-${BUILD:-0}-${DATE}.json"

echo "Generating IaC metrics report..."

if [ ! -f trivy-iac-report.json ]; then
  echo "ERROR: trivy-iac-report.json not found"
  exit 1
fi

cp trivy-iac-report.json "${OUTPUT_FILE}"

echo "${OUTPUT_FILE}"
