# Salt Intermediate Exercise Part 2: Cross-Minion Communication

## Scenario

Your web servers are successfully serving their dynamic pages, but the development team just dropped a new requirement. The web application needs to connect to the database server (`minion-4`).

The application expects a configuration file located at `/etc/app_config.yml` on every web server. This file must contain the IP address of the database server.

Because we are building in a cloud environment where IP addresses can change, **you cannot hardcode the database IP address**. You must use the **Salt Mine** so the database server can announce its IP, and the web servers can dynamically look it up during state execution. Additionally, the infrastructure team wants to tag all servers with their physical location using a custom Salt Grain.

## Your Fleet Assignments (Unchanged)

* **minion-1**: Role = `web`, Environment = `prod`
* **minion-2**: Role = `web`, Environment = `prod`
* **minion-3**: Role = `web`, Environment = `dev`
* **minion-4**: Role = `db`, Environment = `dev`

## Tasks

1. **Manage a Custom Grain:**
* Create a new state (e.g., `common/init.sls`) that applies to *all* minions.
* Use a state module to ensure a custom grain named `datacenter` with the value `amsterdam` is present on all minions.


2. **Configure the Salt Mine:**
* Update your Pillar data to configure the Salt Mine.
* Instruct **all** minions to push their IP addresses to the mine using the `network.ip_addrs` execution module. (Set the mine interval to something short for this exercise, or trigger a manual mine update).


3. **Install the Database:**
* Create a `db/init.sls` state.
* Write a state to install the `mariadb-server` package and ensure the `mariadb` service is running and enabled.
* Update your `top.sls` to apply this state only to servers with the `db` role.


4. **Create the App Configuration State:**
* Update your `nginx` state (or create a new `app` state) to manage the file `/etc/app_config.yml`.
* This must be a Jinja template.


5. **Mine Data Retrieval via Jinja:**
* Inside `/etc/app_config.yml.jinja`, use Jinja to query the Salt Mine for the IP address of the server with the pillar role `db`.
* The output of `/etc/app_config.yml` on the web servers should look exactly like this:
```yaml
database_connection:
  host: <IP_ADDRESS_OF_MINION_4>
  port: 3306

```




6. **Apply and Verify:**
* Update the mine manually.
* Apply the highstate.
* Verify the web servers have the correct IP in their config file.



## End Goal

When you cat `/etc/app_config.yml` on `minion-1`, it dynamically displays the actual IP address of `minion-4`.

---
