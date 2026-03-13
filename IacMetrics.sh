#!/bin/bash
set -e

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

echo "TEAM=$TEAM"
echo "PROJECT=$PROJECT"
echo "PIPELINE=$PIPELINE"
echo "BRANCH=$BRANCH"
echo "BUILD=$BUILD"

DATE=$(date +%Y%m%d%H%M%S)

OUTPUT_FILE="iac-scan-${TEAM}-${PROJECT}-${PIPELINE}-${BRANCH}-${BUILD}-${DATE}.json"

echo "OUTPUT_FILE=$OUTPUT_FILE"

if [ ! -f "trivy-iac-report.json" ]; then
  echo "ERROR: trivy-iac-report.json not found"
  exit 1
fi

cp trivy-iac-report.json "$OUTPUT_FILE"

echo "Generated file: $OUTPUT_FILE"

echo "$OUTPUT_FILE"
