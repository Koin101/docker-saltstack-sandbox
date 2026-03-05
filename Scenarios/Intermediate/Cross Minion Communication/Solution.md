# Solution & Verification

Here is how you can implement the Salt Mine and Grains.

## 1. Pillar Updates (`/srv/pillar/`)

We add the mine configuration to the common Pillar so all minions send their data. Let's create a `common.sls` and add it to our `top.sls`.

**`/srv/pillar/top.sls`** (Updated)

```yaml
base:
  '*':
    - common
  'minion-[1-2]':
    - web_prod
  'minion-3':
    - web_dev
  'minion-4':
    - db_dev

```

**`/srv/pillar/common.sls`** (New)

```yaml
mine_functions:
  network.ip_addrs: []

```

*Run this to apply and populate the mine:* 1. `salt '*' saltutil.refresh_pillar`
2. `salt '*' mine.update`

## 2. State Updates (`/srv/salt/`)

**`/srv/salt/top.sls`** (Updated)

```yaml
base:
  '*':
    - common
  'role:web':
    - match: pillar
    - nginx
  'role:db':
    - match: pillar
    - db

```

**`/srv/salt/common/init.sls`** (New)

```yaml
set_datacenter_grain:
  grains.present:
    - name: datacenter
    - value: amsterdam

```

**`/srv/salt/db/init.sls`** (New)

```yaml
mariadb_pkg:
  pkg.installed:
    - name: mariadb-server

mariadb_service:
  service.running:
    - name: mariadb
    - enable: True
    - require:
      - pkg: mariadb_pkg

```

**`/srv/salt/nginx/init.sls`** (Appended)

```yaml
# ... (Previous Nginx states remain here) ...

manage_app_config:
  file.managed:
    - name: /etc/app_config.yml
    - source: salt://nginx/app_config.yml.jinja
    - template: jinja

```

**`/srv/salt/nginx/app_config.yml.jinja`** (New)

```jinja
{% set db_ips = salt['mine.get']('role:db', 'network.ip_addrs', tgt_type='pillar') %}
{% set db_ip = '127.0.0.1' %} {# Default fallback #}

{% for minion_id, ip_list in db_ips.items() %}
  {% if ip_list %}
    {% set db_ip = ip_list[0] %}
  {% endif %}
{% endfor %}

database_connection:
  host: {{ db_ip }}
  port: 3306

```

*(Note: The Jinja loop safely extracts the IP regardless of the specific minion ID returned by the mine).*

*Run this to apply:* `salt '*' state.apply`

## 3. Verification Commands

Run these on the Salt Master to verify:

**Check the Grains:**

```bash
salt '*' grains.item datacenter

```

*(Should return `datacenter: amsterdam` for all minions).*

**Check the Mine Data:**

```bash
salt 'minion-1' cmd.run 'cat /etc/app_config.yml'

```

*(Should return the YAML file with minion-4's actual IP address).*

---