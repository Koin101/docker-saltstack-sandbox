# 🧂 Docker-SaltStack Sandbox

A streamlined Docker Compose environment designed to spin up a **Salt Master** and **Minions** for testing and development.

## 📋 Prerequisites

Ensure you have the following installed on your system:

* **Docker**
* **Docker Compose**

---

## 🚀 Getting Started

1. **Launch the environment:**

    ```bash
    docker compose up -d
    ```

2. **Access the Salt Master:**

    ```bash
    docker compose exec salt-master bash
    ```

3. **Verify the connection:**
Once inside the master's shell, run:

    ```bash
    salt '*' test.ping
    ```

*Note: You can watch the live log output in your initial terminal window to see the master/minion handshake in real-time.*

---

## 🛠️ Configuration & Scaling

### Running Multiple Minions

To scale your infrastructure and test multi-node configurations, use the `--scale` flag:

```bash
docker compose up -d --scale salt-minion=2
```

### Managing Hostnames

By default, Salt uses container IDs as hostnames. To make them more readable (e.g., `minion-1`, `minion-2`), run the provided helper script:

```bash
./rename_minions.sh <number_of_minions>
```

---

## 📖 Learning Scenarios

Looking for practice? Check out the `Scenarios` folder. These exercises were generated to help you master Salt states and orchestration.
*Status: 🏗️ Work in Progress.*

---

## ⚠️ Important Note on Persistence

> **Warning:** This environment is currently **ephemeral**.
> Any changes made directly inside the containers will be lost when they are removed. Always save your `.sls` state files and configuration changes to your local machine to ensure you can resume your work later.
