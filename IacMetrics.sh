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

# valores por defecto si no llegan parámetros
TEAM=${TEAM:-unknown-team}
PROJECT=${PROJECT:-unknown-project}
PIPELINE=${PIPELINE:-unknown-pipeline}
BRANCH=${BRANCH:-unknown-branch}
BUILD=${BUILD:-0}

DATE=$(date +%Y%m%d%H%M%S)

OUTPUT_FILE="iac-scan-${TEAM}-${PROJECT}-${PIPELINE}-${BRANCH}-${BUILD}-${DATE}.json"

echo "Generating IaC metrics report..."

# validar que el reporte exista
if [ ! -f trivy-iac-report.json ]; then
    echo "ERROR: trivy-iac-report.json not found"
    exit 1
fi

cp trivy-iac-report.json "${OUTPUT_FILE}"

echo "${OUTPUT_FILE}"
