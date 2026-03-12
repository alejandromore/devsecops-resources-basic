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

# Combinar resultados de scanners
ISSUES=$(jq -s '[.[][]]' gitleaks-report.json whispers-report.json detectsecrets-report.json | jq '
map(select(
  (.severity != "Low") and
  (.rule_id != "file-known")
))
')

# Filtrar falsos positivos comunes
ISSUES=$(echo "$ISSUES" | jq '
  map(select(
    (.key != "sonar.projectKey") and
    (.file | contains(".git") | not) and
    (.file | contains("devsecops-resources") | not) and
    (.file | contains("gitleaks-report.json") | not) and
    (.file | contains("whispers-report.json") | not)
  ))
')

# Generar reporte final
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

# IMPORTANTE: Jenkins espera SOLO el nombre del archivo
echo $REPORT
