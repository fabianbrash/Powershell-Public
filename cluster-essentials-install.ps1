$FORCE_COLOR=0
$ns_name="tanzu-cluster-essentials"

if (-not $env:INSTALL_BUNDLE) { Write-Host "INSTALL_BUNDLE env var must not be empty" ; exit }
if (-not $env:INSTALL_REGISTRY_HOSTNAME) { Write-Host "INSTALL_REGISTRY_HOSTNAME env var must not be empty" ; exit }
if (-not $env:INSTALL_REGISTRY_USERNAME) { Write-Host "INSTALL_REGISTRY_USERNAME env var must not be empty" ; exit }
if (-not $env:INSTALL_REGISTRY_PASSWORD) { Write-Host "INSTALL_REGISTRY_PASSWORD env var must not be empty" ; exit }

Write-Host "## Creating namespace $ns_name"
kubectl create ns "$ns_name" --dry-run=client -oyaml | kubectl apply -f-
if ($LASTEXITCODE -ne 0) { Write-Host "Failed to create namespace" ; exit }

Write-Host "## Pulling bundle from $($env:INSTALL_REGISTRY_HOSTNAME) (username: $($env:INSTALL_REGISTRY_USERNAME))"
$IMGPKG_REGISTRY_HOSTNAME_0 = $env:INSTALL_REGISTRY_HOSTNAME
$IMGPKG_REGISTRY_USERNAME_0 = $env:INSTALL_REGISTRY_USERNAME
$IMGPKG_REGISTRY_PASSWORD_0 = $env:INSTALL_REGISTRY_PASSWORD

imgpkg pull -b $env:INSTALL_BUNDLE -o ./bundle/
if ($LASTEXITCODE -ne 0) { Write-Host "Failed to fetch bundle" ; exit }

$YTT_registry__server = $env:INSTALL_REGISTRY_HOSTNAME
$YTT_registry__username = $env:INSTALL_REGISTRY_USERNAME
$YTT_registry__password = $env:INSTALL_REGISTRY_PASSWORD

Write-Host "## Deploying kapp-controller"
ytt -f ./bundle/kapp-controller/config/ -f ./bundle/registry-creds/ --data-values-env YTT --data-value-yaml kappController.deployment.concurrency=10 | kbld -f- -f ./bundle/.imgpkg/images.yml | kapp deploy -a kapp-controller -n "$ns_name" -f- --yes
if ($LASTEXITCODE -ne 0) { Write-Host "Failed to deploy kapp-controller" ; exit }

Write-Host "## Deploying secretgen-controller"
ytt -f ./bundle/secretgen-controller/config/ -f ./bundle/registry-creds/ --data-values-env YTT | kbld -f- -f ./bundle/.imgpkg/images.yml | kapp deploy -a secretgen-controller -n "$ns_name" -f- --yes
if ($LASTEXITCODE -ne 0) { Write-Host "Failed to deploy secretgen-controller" ; exit }
