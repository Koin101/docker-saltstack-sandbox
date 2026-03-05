# Hints & Tips

### 1. State-Managed Grains

* **Hint:** Look at the `grains.present` state module. It is the easiest way to ensure a specific grain exists with a specific value.

### 2. Configuring the Salt Mine

* **Hint:** The Salt Mine is typically configured in Pillar data under the `mine_functions` key.
* **Hint:** To get the IP address, you want the minions to execute the `network.ip_addrs` function. Your pillar yaml should look something like:
```yaml
mine_functions:
  network.ip_addrs: []

```


* **Hint:** After updating the Pillar, you must refresh the pillar data *and* tell the minions to update the mine. Use `salt '*' mine.update`.

### 3. Querying the Mine in Jinja

* **Hint:** This is the trickiest part! You can call the mine from Jinja using `salt['mine.get'](...)`.
* **Hint:** You want to target the DB server by its pillar role. The syntax is:
`salt['mine.get']('role:db', 'network.ip_addrs', tgt_type='pillar')`
* **Hint:** The `mine.get` function returns a dictionary where the keys are the Minion IDs and the values are the result of the function (which, for `network.ip_addrs`, is a list of IPs).
* **Hint:** To extract just the first IP of the DB server without knowing its minion ID in advance, you can iterate over the dictionary in Jinja, or use `.values() | first | first` if you are comfortable with Jinja filters.

---