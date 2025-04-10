$numberOfInstances = 1
$projectId = "lauren-intern-nonprod"
$location = "europe-west4-a"
$reservationType = "RESERVATION_SPECIFIC"  # Można zmienić na RESERVATION_SPECIFIC jeśli potrzebna konkretna rezerwacja
$reservationName = "test-reservation-20250410-074402"  # Wypełnij jeśli używasz RESERVATION_SPECIFIC

# Funkcja do tworzenia instancji z rezerwacją
function Create-InstanceWithReservation {
    param (
        [string]$instanceName,
        [string]$projectId,
        [string]$location
    )

    $requestBody = @{
        "gce_setup" = @{
            "machine_type" = "n1-standard-4"
            "reservation_affinity" = @{
                "consume_reservation_type" = $reservationType
                "key" = "compute.googleapis.com/reservation-name"
                "values" = @($reservationName)
            }
            "container_image" = @{
                "repository" = "europe-west4-docker.pkg.dev/lauren-intern-nonprod/olimiada-vertex/olimpiada-vertex"
                "tag" = "v6"
            }
            "network_interfaces" = @(
                @{
                    "network" = "projects/$projectId/global/networks/default"
                    "subnet" = "projects/$projectId/regions/europe-west4/subnetworks/europe-west4-subnet"
                }
            )
            "service_accounts" = @(
                @{
                    "email" = "olimpiada-workbench@$projectId.iam.gserviceaccount.com"
                }
            )
        }
    }

    $requestBodyJson = $requestBody | ConvertTo-Json -Depth 10

    Write-Host "Tworzenie instancji $instanceName..."
    Write-Host "Request body:"
    Write-Host $requestBodyJson
    
    $url = "https://notebooks.googleapis.com/v2/projects/$projectId/locations/$location/instances?instanceId=$instanceName"
    
    Write-Host "URL: $url"
    Write-Host "Authorization: Bearer $(gcloud auth print-access-token)"
    
    try {
        $response = Invoke-RestMethod -Method Post -Uri $url `
            -Headers @{
                "Authorization" = "Bearer $(gcloud auth print-access-token)"
                "Content-Type" = "application/json"
            } `
            -Body $requestBodyJson

        Write-Host "Utworzono instancje $instanceName"
        Write-Host "Response:"
        Write-Host ($response | ConvertTo-Json -Depth 10)
    }
    catch {
        Write-Host "`n=== SZCZEGOLY BLEDU ==="
        Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
        Write-Host "Status Description: $($_.Exception.Response.StatusDescription)"
        Write-Host "`nTresc bledu API:"

        try {
            # Sprawdź, czy odpowiedź błędu istnieje
            if ($_.Exception.Response -ne $null) {
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $errorBody = $streamReader.ReadToEnd()
                $streamReader.Close()

                # Spróbuj sparsować jako JSON dla ładniejszego wyświetlenia
                try {
                    $errorJson = $errorBody | ConvertFrom-Json
                    Write-Host ($errorJson | ConvertTo-Json -Depth 10)
                }
                catch {
                    # Jeśli nie JSON, wyświetl surową treść
                    Write-Host $errorBody
                }
            }
            else {
                # Jeśli nie ma odpowiedzi, wyświetl ogólny komunikat wyjątku
                Write-Host $_.Exception.Message
            }
        }
        catch {
            # Awaryjnie, jeśli odczyt strumienia lub inne operacje zawiodą
            Write-Host "Nie można odczytać szczegółów błędu API. Wyświetlanie podstawowego błędu:"
            Write-Host $_.Exception.Message
            Write-Host "`nStack Trace:"
            Write-Host $_.Exception.StackTrace
        }
        
        Write-Host "`n=== KONIEC SZCZEGOLOW BLEDU ===`n"
    }
}

# Tworzenie instancji
for ($i = 1; $i -le $numberOfInstances; $i++) {
    $instanceName = "olimp-west4$i"
    Create-InstanceWithReservation -instanceName $instanceName -projectId $projectId -location $location
}
