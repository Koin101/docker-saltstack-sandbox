# Solution

Below a possible solution is shown. Note that there are lots of ways to reach the same goal. I will also show some issues I ran into when solving the scenario. Possible in the future automated ways to check if solution is correct.

## State File

```yaml
install_nginx:
    pkg.installed:
    - pkgs:
        - nginx

start_nginx:
    service.running:
    - name: nginx
    - enable: True

index_html_nginx:
    file.managed:
    - name: /var/www/html/index.html
    - source: salt://nginx/index.html 
```

## Verification

You can run `salt minion-[12] cmd.run 'cat /var/www/html/index.html'` to check whether the html files are correclty placed on the minions.

## Possible Issues

### Applying the State

I tried to run `salt minion-[12] state.nginx` but this wil fail. It should be `salt minion-[12] state.apply nginx`.

### Source File Error

I encounterd the following error: `Comment: Source file salt://nginx/index.html not found in saltenv 'base'` Gemini provided the following explanation:

> Understanding the salt:// Protocol
>
> In your nginx.sls file, you likely have a line that looks something like this:
> source: salt://nginx/index.html
>
> The salt:// prefix is a special protocol that tells the minion to ask the Salt Master's built-in file server for the file.
>
> By default, salt:// maps directly to your base file server root, which is /srv/salt/.
>
>Therefore, when Salt sees salt://nginx/index.html, it is looking for this exact path on your Salt Master's local filesystem:
> /srv/salt/nginx/index.html
