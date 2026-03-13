#!/bin/bash

set -e

TEAM=""
PROJECT=""
PIPELINE=""

while getopts "a:p:t:" opt; do
  case $opt in
    a) TEAM="$OPTARG" ;;
    p) PROJECT="$OPTARG" ;;
    t) PIPELINE="$OPTARG" ;;
  esac
done

DATE=$(date +"%Y%m%d-%H%M%S")

OUTPUT_FILE="trivy-metrics-${TEAM}-${PROJECT}-${DATE}.json"

if [ ! -f trivy-report.json ]; then
  echo "ERROR: trivy-report.json not found"
  exit 1
fi

CRITICAL=$(jq '[.Results[].Vulnerabilities[]? | select(.Severity=="CRITICAL")] | length' trivy-report.json)
HIGH=$(jq '[.Results[].Vulnerabilities[]? | select(.Severity=="HIGH")] | length' trivy-report.json)
MEDIUM=$(jq '[.Results[].Vulnerabilities[]? | select(.Severity=="MEDIUM")] | length' trivy-report.json)
LOW=$(jq '[.Results[].Vulnerabilities[]? | select(.Severity=="LOW")] | length' trivy-report.json)

cat <<EOF > ${OUTPUT_FILE}
{
  "team": "${TEAM}",
  "project": "${PROJECT}",
  "pipeline": "${PIPELINE}",
  "scan_date": "${DATE}",
  "vulnerabilities": {
    "critical": ${CRITICAL},
    "high": ${HIGH},
    "medium": ${MEDIUM},
    "low": ${LOW}
  }
}
EOF

echo ${OUTPUT_FILE}
