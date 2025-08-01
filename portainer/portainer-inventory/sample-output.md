# Internal Infrastructure

This report contains a live snapshot of Docker containers deployed across all environments managed by Portainer.

**Confidential** – For internal use only.

# Portainer Inventory Report  
Generated on 01/08/2025  
Script version: v1.2.4

## Environment: host01.example.com (ID: 1)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name       | Image                     | Status  | Uptime | Ports            | Environment        | ID     | Volumes                        | Networks |
|------------|---------------------------|---------|--------|-------------------|---------------------|--------|--------------------------------|----------|
| app-web    | example/app-web:latest    | running | 12d 3h | 8080:8080/tcp     | host01.example.com  | abc123 | /web-data                      | bridge   |
| app-db     | example/app-db:latest     | running | 12d 3h | 5432:5432/tcp     | host01.example.com  | def456 | /db-data                       | bridge   |
| portainer  | portainer/portainer-ce    | running | 15d 4h | 9000:9000/tcp     | host01.example.com  | ghi789 | /var/run/docker.sock, /data   | bridge   |

---

## Environment: host02.example.com (ID: 2)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name          | Image                          | Status  | Uptime | Ports                    | Environment        | ID     | Volumes                        | Networks |
|---------------|---------------------------------|---------|--------|---------------------------|---------------------|--------|--------------------------------|----------|
| proxy         | example/proxy:stable            | running | 20d 6h | 80:80/tcp, 443:443/tcp   | host02.example.com  | jkl012 | /proxy-config, /ssl-certs     | bridge   |
| metrics-agent | example/metrics-agent:latest    | running | 20d 6h | 9100:9100/tcp            | host02.example.com  | mno345 | /metrics-config               | bridge   |

### Stopped Containers

| Name         | Image                         | Status | Uptime | Ports  | Environment        | ID     | Volumes         | Networks |
|--------------|-------------------------------|--------|--------|--------|---------------------|--------|-----------------|----------|
| old-backend  | example/old-backend:v1        | exited | (n/a)  | (none) | host02.example.com  | pqr678 | /old-backend    | bridge   |

---

## Environment: host03.example.com (ID: 3)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name       | Image                        | Status  | Uptime | Ports         | Environment        | ID     | Volumes            | Networks |
|------------|------------------------------|---------|--------|----------------|---------------------|--------|---------------------|----------|
| monitoring | example/monitoring:latest    | running | 30d 12h| 3000:3000/tcp | host03.example.com  | stu901 | /monitoring-data    | bridge   |

---

## Summary

- **Total Environments**: 3  
- **Total Running Containers**: 6  
- **Total Stopped Containers**: 1  
- **Total Stacks Found**: 0  
- **Total Orphan Containers**: 7
