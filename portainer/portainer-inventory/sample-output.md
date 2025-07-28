# Internal Infrastructure

This report contains a live snapshot of Docker containers deployed across all environments managed by Portainer.

**Confidential** – For internal use only.

# Portainer Inventory Report
Generated on 28/07/2025
Script version: v1.2.0

## Environment: host1.example.com (ID: 2)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|-------|-------------|----|---------|----------|
| calibre-web | linuxserver/calibre-web:latest | running | 8083:8083/tcp, 8083:8083/tcp | host1.example.com | db1befe5e4f5 | /books, /config | bridge |
| portainer | portainer/portainer-ce | running | null:9443/tcp, 8000:8000/tcp, 8000:8000/tcp, 9000:9000/tcp, 9000:9000/tcp | host1.example.com | fb2dd5650fb5 | /var/run/docker.sock, /data | bridge |
| Calibre | ghcr.io/linuxserver/calibre | running | null:3000/tcp, null:3001/tcp, 7080:8080/tcp, 7080:8080/tcp, 7081:8081/tcp, 7081:8081/tcp | host1.example.com | 15793c3a50f5 | /books, /books-autoimport, /config, /shared | calibre_default |

---
## Environment: host2.example.com (ID: 3)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|-------|-------------|----|---------|----------|
| portainer_agent | portainer/agent:lts | running | 9001:9001/tcp, 9001:9001/tcp | host2.example.com | a3469bfebfab | /var/lib/docker/volumes, /var/run/docker.sock | bridge |
| hosting-master_plausible_1 | ghcr.io/plausible/community-edition:v2.1.5 | running | 8000:8000/tcp, 8000:8000/tcp | host2.example.com | 5d373ed1df6d | /var/lib/plausible | hosting-master_default |
| hosting-master_plausible_events_db_1 | clickhouse/clickhouse-server:24.3.3.102-alpine | running | null:8123/tcp, null:9000/tcp, null:9009/tcp | host2.example.com | 152ac052e1d4 | /etc/clickhouse-server/config.d/logging.xml, /etc/clickhouse-server/users.d/logging.xml, /var/lib/clickhouse | hosting-master_default |
| hosting-master_plausible_db_1 | postgres:12 | running | null:5432/tcp | host2.example.com | 4a645e265e7e | /var/lib/postgresql/data | hosting-master_default |
| hosting-master_mail_1 | bytemark/smtp | running | null:25/tcp | host2.example.com | 2c8ff996b746 | (none) | hosting-master_default |

---
## Environment: host3.example.com (ID: 4)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|-------|-------------|----|---------|----------|
| Catt-Bedroom | ryanbarrett/catt-chromecast:latest | running | (none) | host3.example.com | ab93865fff32 | (none) | bridge |
| Catt-Bar | ryanbarrett/catt-chromecast:latest | running | (none) | host3.example.com | 1987579261b2 | (none) | bridge |
| Catt-LivingRoom | ryanbarrett/catt-chromecast:latest | running | (none) | host3.example.com | 0c29afbd9b63 | (none) | bridge |
| portainer_agent | portainer/agent:lts | running | 9001:9001/tcp, 9001:9001/tcp | host3.example.com | 731b3bf9e0e2 | /var/lib/docker/volumes, /var/run/docker.sock | bridge |
| ts-subnet-router-homelab | tailscale/tailscale | running | (none) | host3.example.com | 88034a8f785e | /dev/net/tun, /var/lib | host |
| Caddy | erfianugrah/caddy-cfdns:v1.3.4-2.7.6 | running | 2019:2019/tcp, 2019:2019/tcp, 443:443/tcp, 443:443/tcp, null:443/udp, 80:80/tcp, 80:80/tcp | host3.example.com | 0f769c29e984 | /config, /data, /etc/caddy/Caddyfile | bridge |

---
## Environment: host4.example.com (ID: 5)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|-------|-------------|----|---------|----------|
| pihole | pihole/pihole:latest | running | (none) | host4.example.com | 0dd2bf70ccb6 | /etc/pihole | host |
| unbound | klutchell/unbound:latest | running | 5353:53/tcp, 5353:53/tcp, 5353:53/udp, 5353:53/udp | host4.example.com | 147163cfd950 | /etc/unbound/custom.conf.d | bridge |
| ts-pihole01 | tailscale/tailscale | running | (none) | host4.example.com | 308c28974468 | /var/lib, /dev/net/tun | host |
| nebula-sync | ghcr.io/lovelaze/nebula-sync:latest | running | (none) | host4.example.com | 720a63232157 | (none) | pi-hole-nebula-sync_default |
| portainer_agent | portainer/agent:lts | running | 9001:9001/tcp, 9001:9001/tcp | host4.example.com | cd384a1229dd | /var/lib/docker/volumes, /var/run/docker.sock | bridge |
| barassistant_webserver_1 | nginx:alpine | running | 3000:3000/tcp, 3000:3000/tcp, null:80/tcp | host4.example.com | 91da84fdb84c | /etc/nginx/conf.d/default.conf | barassistant_default |
| barassistant_salt-rim_1 | barassistant/salt-rim:v2 | running | null:8080/tcp, null:80/tcp | host4.example.com | 30b695968535 | (none) | barassistant_default |
| barassistant_bar-assistant_1 | barassistant/server:v3 | running | null:3000/tcp, null:9000/tcp | host4.example.com | 2b7fe316b78a | /var/www/cocktails/storage/bar-assistant | barassistant_default |
| barassistant_redis_1 | redis | running | null:6379/tcp | host4.example.com | f4a4ebd7aad5 | /data | barassistant_default |
| barassistant_meilisearch_1 | getmeili/meilisearch:v1.4 | running | null:7700/tcp | host4.example.com | e38ba69b2aed | /meili_data | barassistant_default |

### Stopped Containers

| Name | Image | Status | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|-------|-------------|----|---------|----------|
| homepage | sha256:d9d412e6487d10a092a9848ec3db1a110840a4b3a585fb1190576575a668f416 | exited | (none) | host4.example.com | e7a6ade89571 | /app/config, /var/run/docker.sock | homepage_default |
| SimpleHTTP | visualjeff/simple-http-server:0.0.1 | exited | (none) | host4.example.com | 149e2a596d98 | /data | bridge |
| CoreDNS | coredns/coredns:latest | exited | (none) | host4.example.com | 181751bf9fa3 | /config | bridge |

---
## Environment: host5.example.com (ID: 6)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|-------|-------------|----|---------|----------|
| portainer_agent | portainer/agent:lts | running | 9001:9001/tcp, 9001:9001/tcp | host5.example.com | 4c7798fc0815 | /var/lib/docker/volumes, /var/run/docker.sock | bridge |
| gitlab | gitlab/gitlab-ee:17.6.4-ee.0 | running | null:22/tcp, null:443/tcp, 80:80/tcp, 80:80/tcp | host5.example.com | 80a6e6d20706 | /var/log/gitlab, /var/opt/gitlab, /data/gitlab, /data/gitlab/log, /data/gitlab/opt, /etc/gitlab | gitlab_default |

---
## Environment: host6.example.com (ID: 7)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|-------|-------------|----|---------|----------|
| pihole | pihole/pihole:latest | running | (none) | host6.example.com | 92c1a3dd7ae6 | /etc/pihole | host |
| unbound | klutchell/unbound:latest | running | 5353:53/tcp, 5353:53/tcp, 5353:53/udp, 5353:53/udp | host6.example.com | 8ab8488c042b | /etc/unbound/custom.conf.d | bridge |
| portainer_agent | portainer/agent:lts | running | 9001:9001/tcp, 9001:9001/tcp | host6.example.com | 88b773a560f1 | /var/lib/docker/volumes, /var/run/docker.sock | bridge |
| netalertx | ghcr.io/jokob-sk/netalertx:latest | running | (none) | host6.example.com | 48d91857bb00 | /app/api, /app/config, /app/db, /app/log | host |
| ddns-updater | qmcgaw/ddns-updater | running | 8000:8000/tcp, 8000:8000/tcp | host6.example.com | 4d56e67756b4 | /updater/data | bridge |

### Stopped Containers

| Name | Image | Status | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|-------|-------------|----|---------|----------|
| threadfin | fyb3roptik/threadfin | exited | (none) | host6.example.com | 8c9b6c43b5a3 | /home/threadfin/conf, /tmp/threadfin | threadfin_default |

---
