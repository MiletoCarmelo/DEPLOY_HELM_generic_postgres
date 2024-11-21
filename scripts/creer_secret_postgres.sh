#!/bin/bash

# Variables
NAMESPACE="postgres"

NAME_SCRET="postgres-secrets"

# secrets from .env
POSTGRES_DB=$(grep POSTGRES_DB .env | cut -d '=' -f2)
POSTGRES_USER=$(grep POSTGRES_USER .env | cut -d '=' -f2)
POSTGRES_PASSWORD=$(grep POSTGRES_PASSWORD .env | cut -d '=' -f2)

# Vérifier si le namespace existe
if ! kubectl get namespace ${NAMESPACE} >/dev/null 2>&1; then
    echo "🔄 Création du namespace ${NAMESPACE}..."
    kubectl create namespace ${NAMESPACE}
else
    echo "✅ Le namespace ${NAMESPACE} existe déjà"
fi

# Créer ou mettre à jour le secret
echo "🔄 Création/mise à jour du secret ${NAME_SCRET} dans le namespace ${NAMESPACE}..."
kubectl create secret generic ${NAME_SCRET} \
  --namespace=${NAMESPACE} \
  --from-literal=POSTGRES_DB=${POSTGRES_DB} \
  --from-literal=POSTGRES_USER=${POSTGRES_USER} \
  --from-literal=POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
  --dry-run=client -o yaml | kubectl apply -f -