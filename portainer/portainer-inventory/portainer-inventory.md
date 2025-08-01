# Internal Infrastructure

This report contains a live snapshot of Docker containers deployed across all environments managed by Portainer.

**Confidential** – For internal use only.

# Portainer Inventory Report
Generated on 01/08/2025
Script version: v1.2.3

## Environment: stor-syn-02.home.local (ID: 2)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|--------|-------|-------------|----|---------|----------|
| calibre-web | linuxserver/calibre-web:latest | running | 17d 4h | 8083:8083/tcp, 8083:8083/tcp | stor-syn-02.home.local | db1befe5e4f5 | /books, /config | bridge |
| portainer | portainer/portainer-ce | running | 17d 4h | 8000:8000/tcp, 8000:8000/tcp, 9000:9000/tcp, 9000:9000/tcp, null:9443/tcp | stor-syn-02.home.local | fb2dd5650fb5 | /var/run/docker.sock, /data | bridge |
| Calibre | ghcr.io/linuxserver/calibre | running | 26d 5h | null:3000/tcp, null:3001/tcp, 7080:8080/tcp, 7080:8080/tcp, 7081:8081/tcp, 7081:8081/tcp | stor-syn-02.home.local | 15793c3a50f5 | /books, /books-autoimport, /config, /shared | calibre_default |
| tautulli-tautulli1 | tautulli/tautulli:latest | running | 26d 5h | 49156:8181/tcp, 49156:8181/tcp | stor-syn-02.home.local | e0a5ea6ccc7a | /config | bridge |

---
## Environment: dmz.vninja.com (ID: 3)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|--------|-------|-------------|----|---------|----------|
| portainer_agent | portainer/agent:lts | running | 29d 3h | 9001:9001/tcp, 9001:9001/tcp | dmz.vninja.com | a3469bfebfab | /var/lib/docker/volumes, /var/run/docker.sock | bridge |
| hosting-master_plausible_1 | ghcr.io/plausible/community-edition:v2.1.5 | running | 29d 3h | 8000:8000/tcp, 8000:8000/tcp | dmz.vninja.com | 5d373ed1df6d | /var/lib/plausible | hosting-master_default |
| hosting-master_plausible_events_db_1 | clickhouse/clickhouse-server:24.3.3.102-alpine | running | 29d 3h | null:8123/tcp, null:9000/tcp, null:9009/tcp | dmz.vninja.com | 152ac052e1d4 | /etc/clickhouse-server/config.d/logging.xml, /etc/clickhouse-server/users.d/logging.xml, /var/lib/clickhouse | hosting-master_default |
| hosting-master_plausible_db_1 | postgres:12 | running | 29d 3h | null:5432/tcp | dmz.vninja.com | 4a645e265e7e | /var/lib/postgresql/data | hosting-master_default |
| hosting-master_mail_1 | bytemark/smtp | running | 29d 3h | null:25/tcp | dmz.vninja.com | 2c8ff996b746 | (none) | hosting-master_default |

---
## Environment: docker01.home.local (ID: 4)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|--------|-------|-------------|----|---------|----------|
| portainer_agent | portainer/agent:lts | running | 7d 8h | 9001:9001/tcp, 9001:9001/tcp | docker01.home.local | 731b3bf9e0e2 | /var/lib/docker/volumes, /var/run/docker.sock | bridge |
| ts-subnet-router-homelab | tailscale/tailscale | running | 7d 8h | (none) | docker01.home.local | 88034a8f785e | /dev/net/tun, /var/lib | host |
| Caddy | erfianugrah/caddy-cfdns:v1.3.4-2.7.6 | running | 7d 8h | 80:80/tcp, 80:80/tcp, 2019:2019/tcp, 2019:2019/tcp, 443:443/tcp, 443:443/tcp, null:443/udp | docker01.home.local | 0f769c29e984 | /etc/caddy/Caddyfile, /config, /data | bridge |

### Stopped Containers

| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|--------|-------|-------------|----|---------|----------|
| Catt-Bedroom | ryanbarrett/catt-chromecast:latest | exited | 13h 20m | (none) | docker01.home.local | ab93865fff32 | (none) | bridge |
| Catt-Bar | ryanbarrett/catt-chromecast:latest | exited | 13h 29m | (none) | docker01.home.local | 1987579261b2 | (none) | bridge |
| Catt-LivingRoom | ryanbarrett/catt-chromecast:latest | exited | 1d 14h | (none) | docker01.home.local | 0c29afbd9b63 | (none) | bridge |

---
## Environment: docker02.home.local (ID: 5)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|--------|-------|-------------|----|---------|----------|
| pihole | pihole/pihole:latest | running | 15d 8h | (none) | docker02.home.local | 0dd2bf70ccb6 | /etc/pihole | host |
| unbound | klutchell/unbound:latest | running | 15d 8h | 5353:53/udp, 5353:53/udp, 5353:53/tcp, 5353:53/tcp | docker02.home.local | 147163cfd950 | /etc/unbound/custom.conf.d | bridge |
| ts-pihole01 | tailscale/tailscale | running | 15d 8h | (none) | docker02.home.local | 308c28974468 | /var/lib, /dev/net/tun | host |
| nebula-sync | ghcr.io/lovelaze/nebula-sync:latest | running | 30d 4h | (none) | docker02.home.local | 720a63232157 | (none) | pi-hole-nebula-sync_default |
| portainer_agent | portainer/agent:lts | running | 33d 10h | 9001:9001/tcp, 9001:9001/tcp | docker02.home.local | cd384a1229dd | /var/lib/docker/volumes, /var/run/docker.sock | bridge |
| barassistant_webserver_1 | nginx:alpine | running | 33d 10h | 3000:3000/tcp, 3000:3000/tcp, null:80/tcp | docker02.home.local | 91da84fdb84c | /etc/nginx/conf.d/default.conf | barassistant_default |
| barassistant_salt-rim_1 | barassistant/salt-rim:v2 | running | 33d 10h | null:80/tcp, null:8080/tcp | docker02.home.local | 30b695968535 | (none) | barassistant_default |
| barassistant_bar-assistant_1 | barassistant/server:v3 | running | 33d 10h | null:9000/tcp, null:3000/tcp | docker02.home.local | 2b7fe316b78a | /var/www/cocktails/storage/bar-assistant | barassistant_default |
| barassistant_redis_1 | redis | running | 33d 10h | null:6379/tcp | docker02.home.local | f4a4ebd7aad5 | /data | barassistant_default |
| barassistant_meilisearch_1 | getmeili/meilisearch:v1.4 | running | 33d 10h | null:7700/tcp | docker02.home.local | e38ba69b2aed | /meili_data | barassistant_default |
| xteve-streamlink | ghcr.io/seansusmilch/xteve-streamlink | running | 33d 10h | 34400:34400/tcp, 34400:34400/tcp | docker02.home.local | 203ef2f527d8 | /tmp/xteve, /config, /root/.xteve | xteve_default |
| deluge | lscr.io/linuxserver/deluge:latest | running | 33d 10h | 6881:6881/udp, 6881:6881/udp, 8112:8112/tcp, 8112:8112/tcp, 58846:58846/tcp, 58846:58846/tcp, null:58946/tcp, null:58946/udp, 6881:6881/tcp, 6881:6881/tcp | docker02.home.local | c0698e921abb | /config, /downloads | arr_default |
| overseerr | sctx/overseerr:latest | running | 33d 10h | 5055:5055/tcp, 5055:5055/tcp | docker02.home.local | 8449e69faf35 | /app/config | arr_default |
| prowlarr | lscr.io/linuxserver/prowlarr:latest | running | 33d 10h | 9696:9696/tcp, 9696:9696/tcp | docker02.home.local | 47d57f71d06e | /config | arr_default |
| bazarr | ghcr.io/hotio/bazarr:latest | running | 33d 10h | 6767:6767/tcp, 6767:6767/tcp | docker02.home.local | ff01e7f51f28 | /config, /data/media, /etc/localtime | arr_default |
| sonarr | ghcr.io/hotio/sonarr:latest | running | 33d 10h | 8989:8989/tcp, 8989:8989/tcp | docker02.home.local | 9fa4c4dba46e | /config, /data, /etc/localtime, /tvshows | arr_default |
| radarr | ghcr.io/hotio/radarr:latest | running | 33d 10h | 7878:7878/tcp, 7878:7878/tcp | docker02.home.local | 6d64fd775b6b | /config, /data, /etc/localtime, /movies | arr_default |

### Stopped Containers

| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|--------|-------|-------------|----|---------|----------|
| homepage | sha256:d9d412e6487d10a092a9848ec3db1a110840a4b3a585fb1190576575a668f416 | exited | 128d 0h | (none) | docker02.home.local | e7a6ade89571 | /app/config, /var/run/docker.sock | homepage_default |
| SimpleHTTP | visualjeff/simple-http-server:0.0.1 | exited | 156d 7h | (none) | docker02.home.local | 149e2a596d98 | /data | bridge |
| CoreDNS | coredns/coredns:latest | exited | 659d 21h | (none) | docker02.home.local | 181751bf9fa3 | /config | bridge |

---
## Environment: docker03.home.local (ID: 6)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|--------|-------|-------------|----|---------|----------|
| portainer_agent | portainer/agent:lts | running | 73d 7h | 9001:9001/tcp, 9001:9001/tcp | docker03.home.local | 4c7798fc0815 | /var/lib/docker/volumes, /var/run/docker.sock | bridge |
| gitlab | gitlab/gitlab-ee:17.6.4-ee.0 | running | 156d 16h | 80:80/tcp, 80:80/tcp, null:22/tcp, null:443/tcp | docker03.home.local | 80a6e6d20706 | /etc/gitlab, /var/log/gitlab, /var/opt/gitlab, /data/gitlab, /data/gitlab/log, /data/gitlab/opt | gitlab_default |

---
## Environment: docker04.home.local (ID: 7)

_No stacks found for this environment._

## Orphan Containers (Not in Any Stack)

### Running Containers

| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|--------|-------|-------------|----|---------|----------|
| pihole | pihole/pihole:latest | running | 15d 8h | (none) | docker04.home.local | 92c1a3dd7ae6 | /etc/pihole | host |
| unbound | klutchell/unbound:latest | running | 15d 8h | 5353:53/tcp, 5353:53/tcp, 5353:53/udp, 5353:53/udp | docker04.home.local | 8ab8488c042b | /etc/unbound/custom.conf.d | bridge |
| portainer_agent | portainer/agent:lts | running | 29d 3h | 9001:9001/tcp, 9001:9001/tcp | docker04.home.local | 88b773a560f1 | /var/run/docker.sock, /var/lib/docker/volumes | bridge |
| netalertx | ghcr.io/jokob-sk/netalertx:latest | running | 33d 10h | (none) | docker04.home.local | 48d91857bb00 | /app/api, /app/config, /app/db, /app/log | host |
| ddns-updater | qmcgaw/ddns-updater | running | 29d 3h | 8000:8000/tcp, 8000:8000/tcp | docker04.home.local | 4d56e67756b4 | /updater/data | bridge |

### Stopped Containers

| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |
|------|-------|--------|--------|-------|-------------|----|---------|----------|
| threadfin | fyb3roptik/threadfin | exited | 77d 1h | (none) | docker04.home.local | 8c9b6c43b5a3 | /home/threadfin/conf, /tmp/threadfin | threadfin_default |

---
# Summary

- Total Containers: 43
- Running Containers: 36
- Stopped Containers: 7

