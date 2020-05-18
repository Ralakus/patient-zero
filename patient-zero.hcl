job "patient-zero" {
  datacenters = ["dc1"]

  type = "service"

  reschedule {
    delay = "30s"
    delay_function = "constant"
    unlimited = true
  }

  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = true
    canary            = 0
    stagger           = "30s"
  }

  group "bot" {
    count = 1

    restart {
      interval = "10m"
      attempts = 2
      delay    = "15s"
      mode     = "fail"
    }

    task "patient-zero" {
      driver = "docker"
      config {
        image = "ralakus/patient-zero:latest"

        volumes = [
          "/home/mikhail/services/patient-zero/:/",
        ]
      }

      service {
        name = "patient-zero"
        tags = ["discord", "bot"]
      }

      resources {
        cpu    = 500 # MHz
        memory = 512 # MB
        network {
          mbits = 100
        }
      }
    }
  }
}
