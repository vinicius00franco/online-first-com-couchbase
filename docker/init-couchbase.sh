#!/bin/bash

# Aguardar Couchbase iniciar
echo "Aguardando Couchbase iniciar..."
until curl -f http://localhost:8091/ui/index.html; do
  echo "Couchbase ainda não está pronto, aguardando..."
  sleep 5
done

echo "Couchbase pronto. Inicializando cluster..."

# Inicializar cluster
curl -X POST http://localhost:8091/clusterInit \
  -d clusterName=ChecklistCluster \
  -d username=Administrator \
  -d password=password \
  -d services=kv,index,n1ql,fts \
  -d memoryQuota=256 \
  -d indexMemoryQuota=256 \
  -d ftsMemoryQuota=256

# Aguardar
sleep 10

# Criar bucket
curl -X POST http://Administrator:password@localhost:8091/pools/default/buckets \
  -d name=checklist_db \
  -d bucketType=couchbase \
  -d ramQuotaMB=100 \
  -d authType=sasl \
  -d saslPassword=

echo "Couchbase inicializado."