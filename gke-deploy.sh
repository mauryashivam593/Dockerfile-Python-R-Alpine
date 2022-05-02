#!/usr/bin/env bash
set -e

echo "#############################################################################################"
echo "Executing Python code to deploy in Promote"

echo ${cloud_build_key} > /tmp/key.json
gcloud auth activate-service-account ${service_account} --key-file=/tmp/key.json --project=${gcp_project}
gcloud beta container clusters get-credentials ${gke_cluster} --region=us-central1 --project=${gke_project}

echo '########'
#echo ${image_tag}
echo 'Deploying gke batch yaml'
echo '########'

kubectl apply --namespace ${gke_namespace} -f ${application_repo}/ci/tasks/textflag-deployment.yaml
sleep 10
kubectl patch deployment textflag-gke-dep --namespace ${gke_namespace} -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"
echo 'COMPLETED DEPLOYMENT'
