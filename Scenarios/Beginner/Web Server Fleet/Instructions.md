# Scenario: The Web Server Fleet

**The Mission:**
Your company needs to spin up two new web servers. Your goal is to use the Salt Master to automatically install a web server on exactly two of your four minions, ensure the service is running, and deploy a custom homepage to them.

## The Requirements

- The Ping Test: Before changing anything, verify that your Salt Master can successfully communicate with all 4 minions at once.

- The State File: Create a Salt State file (usually ending in .sls) on your Salt Master. This state should do three things:

  - Install the nginx package (or apache2/httpd depending on your container OS).
  - Ensure the web server service is enabled to start on boot and is currently running.
  - Push a custom index.html file from the Salt Master to the correct web directory on the minions (e.g., /var/www/html/index.html).

- Apply this state file to only two of your minions (for example, minion1 and minion2), leaving the other two completely untouched.

**Verification:**
Verify the deployment worked by using a Salt execution command to fetch the contents of the index.html file directly from those two targeted minions.
