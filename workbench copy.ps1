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
                "subnet" = "projects/$projectId/regions/europe-west4/subnetworks/default"
            }
        )
        "service_accounts" = @(
            @{
                "email" = "olimpiada-workbench@$projectId.iam.gserviceaccount.com"
            }
        )
    }
} 