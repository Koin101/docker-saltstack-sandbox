## Salt Intermediate Exercise: Dynamic Web Fleet Deployment

### Scenario

You are the lead automation engineer for a growing startup. You have just provisioned a new environment consisting of one **Salt Master** and four **minions** (`minion-1`, `minion-2`, `minion-3`, `minion-4`).

Your task is to configure these servers based on specific roles. You need to deploy a web server (**Nginx**) but only to the minions designated as web servers. Furthermore, the web servers must serve a custom index page that dynamically displays their assigned environment (**Production** or **Development**) and their **Minion ID**.

> [!IMPORTANT]
> You must not hardcode these values in your states; they must be dynamically driven by **Salt Pillars** and **Jinja templating**.

---

### Your Fleet Assignments

| Minion ID | Role | Environment |
| --- | --- | --- |
| `minion-1` | web | prod |
| `minion-2` | web | prod |
| `minion-3` | web | dev |
| `minion-4` | db | dev |

---

### Tasks

#### 1. Configure Pillar Data

* **Create pillar files** that assign the `role` and `environment` variables to the respective minions according to the fleet assignments above.
* **Create a pillar `top.sls` file** to map these variables to the correct minions.
* **Refresh the pillar data** on all minions to ensure they can see their new variables.

#### 2. Create the Web State

* Create a new state directory (e.g., `nginx`).
* **Install Nginx:** Write a state to install the `nginx` package and ensure the service is running and enabled.
* **Manage Content:** Write a state to manage the `/var/www/html/index.html` file.

#### 3. Implement Jinja Templating

* Make the `index.html` file a **Jinja template**.
* The generated HTML must output the following text dynamically:
> Hello from **\<Minion ID\>**! I am a **\<Role\>** server in the **\<Environment\>** environment.



#### 4. Create the State Top File

* Create a state `top.sls` file.
* **Targeting:** Configure it so that the `nginx` state is applied **only** to minions that have the `web` role defined in their pillar data.
* **Restriction:** Do not target them by their minion ID in the top file.

#### 5. Apply and Verify

* **Apply the highstate** to all minions.
* **Verify Web Servers:** Ensure `minion-1`, `minion-2`, and `minion-3` have Nginx installed and are serving the correct dynamic text.
* **Verify DB Server:** Ensure `minion-4` does **not** have Nginx installed.

---

### End Goal

When you run a command to fetch the web page from `minion-1`, it should return:
`Hello from minion-1! I am a web server in the prod environment.`

Running the same against `minion-4` should result in a **connection refused** or **not found** error, as it is a database server.

---
