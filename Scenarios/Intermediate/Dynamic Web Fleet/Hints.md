## Hints & Tips

Stuck on a specific task? Use these hints to guide you in the right direction without giving away the exact code.

---

### 1. Pillar Data & Refreshing

* **Storage:** Pillar data is usually stored in `/srv/pillar/` (depending on your master config).
* **Targeting:** You can target specific minions in your pillar `top.sls` using standard globbing (e.g., `minion-1`).
* **Update Cycle:** After creating pillars, always remember to tell the minions to fetch the new data. Look into the `saltutil.refresh_pillar` execution module.
* **Validation:** To verify a minion has the right data before writing states, use:
`salt 'minion-1' pillar.items`

### 2. State Requirements

* **Storage:** States usually live in `/srv/salt/`.
* **Modules:** To manage Nginx, you will need three state modules:

1. `pkg.installed`
2. `service.running`
3. `file.managed`


* **Requisites:** Remember to use `require` or `watch` requisites so the service restarts if the index file changes, and ensure the file isn't placed before the package is installed.

### 3. Jinja Templating

* **Parsing:** In a `file.managed` state, you must explicitly tell Salt to parse the file as Jinja by adding `template: jinja`.
* **Grains:** To access the **Minion ID** in Jinja, you can use Salt grains: `{{ grains['id'] }}`.
* **Pillars:** To access **Pillar data** in Jinja, you can use the pillar dictionary: `{{ pillar['environment'] }}` or the salt function `{{ salt['pillar.get']('environment', 'unknown') }}`.

### 4. Targeting in the State Top File

* **Flexible Targeting:** The state `top.sls` can match minions based on pillar data, not just IDs.
* **Documentation:** Look up "Salt pillar targeting" in the documentation. In your `top.sls`, you will need to specify the match type:

```yaml
'role:web':
  - match: pillar
  - nginx

```

---
