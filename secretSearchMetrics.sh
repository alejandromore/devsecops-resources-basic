#!/bin/bash

TEAM=""
PROJECT=""
PIPELINE=""
BRANCH=""
BUILD=""

while getopts "a:p:t:b:n:" opt; do
  case $opt in
    a) TEAM=$OPTARG ;;
    p) PROJECT=$OPTARG ;;
    t) PIPELINE=$OPTARG ;;
    b) BRANCH=$OPTARG ;;
    n) BUILD=$OPTARG ;;
  esac
done

REPORT="secrets-report-${PROJECT}-${BUILD}.json"

echo "Generating consolidated report..."

# Combina resultados de herramientas
ISSUES=$(jq -s '[.[][]]' gitleaks-report.json whispers-report.json detectsecrets-report.json 2>/dev/null)

cat <<EOF > $REPORT
{
  "team": "$TEAM",
  "project": "$PROJECT",
  "pipeline": "$PIPELINE",
  "branch": "$BRANCH",
  "build": "$BUILD",
  "issues": $ISSUES
}
EOF

echo "Report generated: $REPORT"

# Jenkins espera el nombre del archivo
echo $REPORT
