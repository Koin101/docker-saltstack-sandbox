## Solution & Verification

Here is one valid way to solve this scenario. Remember, in Salt, there are often multiple ways to structure your files, but this approach follows best practices for Pillar/State separation.

---

### 1. Pillar Configuration (`/srv/pillar/`)

**`/srv/pillar/top.sls`**

```yaml
base:
  'minion-[1-2]':
    - web_prod
  'minion-3':
    - web_dev
  'minion-4':
    - db_dev

```

**`/srv/pillar/web_prod.sls`**

```yaml
role: web
environment: prod

```

**`/srv/pillar/web_dev.sls`**

```yaml
role: web
environment: dev

```

**`/srv/pillar/db_dev.sls`**

```yaml
role: db
environment: dev

```

> [!TIP]
> **Apply Pillar Changes:** Run this on the master to update the minions:
> `salt '*' saltutil.refresh_pillar`

---

### 2. State Configuration (`/srv/salt/`)

**`/srv/salt/top.sls`**

```yaml
base:
  'role:web':
    - match: pillar
    - nginx

```

**`/srv/salt/nginx/init.sls`**

```yaml
nginx_pkg:
  pkg.installed:
    - name: nginx

nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: nginx_pkg
    - watch:
      - file: manage_index_html

manage_index_html:
  file.managed:
    - name: /var/www/html/index.html
    - source: salt://nginx/index.html.jinja
    - template: jinja
    - require:
      - pkg: nginx_pkg

```

**`/srv/salt/nginx/index.html.jinja`**

```html
Hello from {{ grains['id'] }}! I am a {{ pillar['role'] }} server in the {{ pillar['environment'] }} environment.

```

> [!TIP]
> **Apply States:** Run this on the master to deploy:
> `salt '*' state.apply` (or `state.highstate`)

---

### 3. Verification Script

You can run this simple bash loop on the Salt Master to verify the end goal.

```bash
#!/bin/bash
echo "Testing Web Servers (Should succeed):"
for i in {1..3}; do
  echo "--- minion-$i ---"
  salt "minion-$i" cmd.run 'curl -s http://localhost'
done

echo ""
echo "Testing Database Server (Should fail/return empty):"
salt 'minion-4' cmd.run 'curl -s http://localhost'

```

#### Expected Output

```text
Testing Web Servers (Should succeed):
--- minion-1 ---
minion-1:
    Hello from minion-1! I am a web server in the prod environment.
--- minion-2 ---
minion-2:
    Hello from minion-2! I am a web server in the prod environment.
--- minion-3 ---
minion-3:
    Hello from minion-3! I am a web server in the dev environment.

Testing Database Server (Should fail/return empty):
minion-4:
    curl: (7) Failed to connect to localhost port 80: Connection refused

```

---
