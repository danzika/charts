#!/usr/bin/env bash

if [[ -z "$2" ]]; then
    echo ""
    echo "Usage: $0 <minio-cluster> <command> [node] [akey] [skey]"
    echo "  supported commands: (heal)"
    echo "  if you specify node (k8s worker node), only pods on the node are healed."
    exit 1
fi

MC_FILE=/usr/local/bin/mc
MC_URL=https://dl.minio.io/client/mc/release/linux-amd64/mc

MINIO_CLUSTER="$1"
if [[ "$2" == "heal" ]]; then
    COMMAND="mc admin heal -r $MINIO_CLUSTER/vertica"
else
    echo "ERROR: Unsupported command: $2"
    exit
fi
if [[ -z "$3" ]]; then
    NODE=".*"
else
    NODE="$3"
fi
if [[ -z "$4" ]]; then
    MINIO_USER=vertica_eon_k1234567
else
    MINIO_USER="$4"
fi
if [[ -z "$5" ]]; then
    MINIO_SECRET=vertica_eon_k1234567_secret1234567890123
else
    MINIO_SECRET="$5"
fi


for POD in $(kubectl get pods --no-headers --namespace minio -l release=${MINIO_CLUSTER} -o wide | grep -iE "${NODE}" | awk '{print $1}' | sort)
do
    MC_GET="curl ${MC_URL} > ${MC_FILE} 2>/dev/null 3>&2 && chmod 775 ${MC_FILE}"
    MC_CONFIG="mc config host add $MINIO_CLUSTER http://127.0.0.1:9000 $MINIO_USER $MINIO_SECRET S3v4"
    kubectl exec -it --namespace=minio ${POD} -- sh -c "hostname && ${MC_GET} && ${MC_CONFIG} && ${COMMAND}"
done;