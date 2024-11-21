# secrets from .env
POSTGRES_DB=$(grep POSTGRES_DB .env | cut -d '=' -f2)
POSTGRES_USER=$(grep POSTGRES_USER .env | cut -d '=' -f2)
POSTGRES_PASSWORD=$(grep POSTGRES_PASSWORD .env | cut -d '=' -f2)
NAMESPACE=$(grep NAMESPACE .env | cut -d '=' -f2)
NAME_SCRET=$(grep NAME_SCRET .env | cut -d '=' -f2)

# Afficher les valeurs des variables (sans le mot de passe)
echo "Variables d'environnement :"
echo "NAMESPACE=${NAMESPACE}"
echo "NAME_SCRET=${NAME_SCRET}"
echo "POSTGRES_DB=${POSTGRES_DB}"
echo "POSTGRES_USER=${POSTGRES_USER}"
echo "POSTGRES_PASSWORD=***"

 
# Vérifier que les variables requises sont définies
if [ -z "${POSTGRES_DB}" ] || [ -z "${POSTGRES_USER}" ] || [ -z "${POSTGRES_PASSWORD}" ]; then
    echo "❌ Erreur: Une ou plusieurs variables requises ne sont pas définies"
    echo "POSTGRES_DB=${POSTGRES_DB}"
    echo "POSTGRES_USER=${POSTGRES_USER}"
    echo "POSTGRES_PASSWORD=***" # On n'affiche pas le mot de passe pour la sécurité
    exit 1
fi

# Vérifier si le namespace existe
if ! kubectl get namespace ${namespace} >/dev/null 2>&1; then
    echo "🔄 Création du namespace ${namespace}..."
    kubectl create namespace ${namespace}
else
    echo "✅ Le namespace ${namespace} existe déjà"
fi

# Créer un fichier temporaire pour vérifier le YAML
echo "🔄 Génération du secret..."
kubectl create secret generic ${NAME_SCRET} \
  --namespace=${namespace} \
  --from-literal=POSTGRES_DB="${POSTGRES_DB}" \
  --from-literal=POSTGRES_USER="${POSTGRES_USER}" \
  --from-literal=POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
  --dry-run=client -o yaml > /tmp/secret.yaml

# Appliquer le secret
echo "🔄 Application du secret..."
kubectl apply -f /tmp/secret.yaml

# Nettoyer
rm /tmp/secret.yaml