# Hints

To solve this, you'll want to look up the documentation for the following Salt concepts and modules:

**Targeting:**
How to match specific minion IDs from the master using the command line (e.g., using globbing or lists).

**The File Server:**
By default, Salt looks for state files in /srv/salt/ on the master. You'll need to create this directory if it doesn't exist.

**State Modules:**

- pkg.installed: To handle the package installation.

- service.running: To handle the service state.

- file.managed: To handle pushing the HTML file.

**Execution Modules** (for testing):

- test.ping: To check connectivity.

- cmd.run: A quick way to run a shell command (like cat /var/www/html/index.html) on a minion from the master.
