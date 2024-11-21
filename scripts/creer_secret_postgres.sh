#!/bin/bash

# Variables
NAMESPACE="postgres"

NAME_SCRET="pg-secrets"

# secrets from .env
POSTGRES_DB=$(grep POSTGRES_DB .env | cut -d '=' -f2)
POSTGRES_USER=$(grep POSTGRES_USER .env | cut -d '=' -f2)
POSTGRES_PASSWORD=$(grep POSTGRES_PASSWORD .env | cut -d '=' -f2)

# Créer le secret pour TS_AUTHKEY
echo "🔒 Création du secret PG-SECRET .."
kubectl create secret generic ${NAME_SCRET} \
  --namespace=${NAMESPACE} \
  --from-literal=POSTGRES_DB=${POSTGRES_DB} \
  --from-literal=POSTGRES_USER=${POSTGRES_USER} \
  --from-literal=POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
  --dry-run=client -o yaml | kubectl apply -f -