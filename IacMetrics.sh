#!/bin/bash

TEAM="unknown-team"
PROJECT="unknown-project"
PIPELINE="unknown-pipeline"
BRANCH="unknown-branch"
BUILD="0"

while getopts "a:p:t:b:n:" flag; do
  case "$flag" in
    a) TEAM="${OPTARG:-$TEAM}" ;;
    p) PROJECT="${OPTARG:-$PROJECT}" ;;
    t) PIPELINE="${OPTARG:-$PIPELINE}" ;;
    b) BRANCH="${OPTARG:-$BRANCH}" ;;
    n) BUILD="${OPTARG:-$BUILD}" ;;
  esac
done

DATE=$(date +%Y%m%d%H%M%S)

OUTPUT_FILE="iac-scan-${TEAM}-${PROJECT}-${PIPELINE}-${BRANCH}-${BUILD}-${DATE}.json"

# validar que exista el reporte de trivy
if [ ! -f "trivy-iac-report.json" ]; then
  echo "ERROR: trivy-iac-report.json not found"
  exit 1
fi

cp trivy-iac-report.json "$OUTPUT_FILE"

# Jenkins captura esta línea
echo "$OUTPUT_FILE"
