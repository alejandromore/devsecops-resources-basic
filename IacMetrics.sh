#!/bin/bash

set -e

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

OUTPUT_FILE="iac-scan-${TEAM}-${PROJECT}-${PIPELINE}-${BRANCH}-${BUILD}-${DATE}.json"

echo "Generating IaC metrics report..."

cat trivy-iac-report.json > ${OUTPUT_FILE}

echo ${OUTPUT_FILE}
