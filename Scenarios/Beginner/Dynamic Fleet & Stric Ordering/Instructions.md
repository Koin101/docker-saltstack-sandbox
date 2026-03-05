# Scenario: Dynamic Fleet & Strict Ordering

**The Mission:**
Update your existing state file so that the web page dynamically displays the specific Minion's ID, and add strict dependency mapping so your states are connected.

## The Requirements

1. Dynamic Content: Change your index.html source file on the master so that instead of just saying "Hello World!", it says "Hello World from [Minion-ID]!" (e.g., Hello World from minion-1!).

2. Enable Templating: You will need to tell your index_html_nginx state to process the file using a templating engine before pushing it.

3. Strict Ordering (Requisites): Update your start_nginx service state so it explicitly requires the install_nginx package state to complete successfully before it even attempts to run.
