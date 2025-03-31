$numberOfInstances = 2

for ($i = 1; $i -le $numberOfInstances; $i++) {
    $instanceName = "olimiada$i"
    Write-Host "Tworzenie instancji $instanceName..."
    
    gcloud workbench instances create $instanceName `
    --project=lauren-intern-nonprod `
    --location=europe-west1-b `
    --container-repository=europe-west4-docker.pkg.dev/lauren-intern-nonprod/olimiada-vertex/olimpiada-vertex  `
    --container-tag=v5 `
    --machine-type=n1-standard-4 `
    --accelerator-type=NVIDIA_TESLA_T4 `
    --accelerator-core-count=1 `
    --boot-disk-size=150 `
    --data-disk-size=100 `
    --network=projects/lauren-intern-nonprod/global/networks/default `
    --subnet=projects/lauren-intern-nonprod/regions/europe-west1/subnetworks/europe-west1-subnet `
    --tags=olimiada-workbench `
    --install-gpu-driver `
    --service-account-email=olimpiada-workbench@lauren-intern-nonprod.iam.gserviceaccount.com `
    --metadata=google-logging-enabled=true,proxy-mode=service_account,disable-swap-binaries=true,enable-oslogin=TRUE,idle-timeout-seconds=1800 `
    --async
    
    Write-Host "Utworzono instancję $instanceName"
}

