# Hints

**Jinja Templating:**
Salt uses Jinja2 by default. You can inject Salt variables into your files. Research how to access Salt Grains (specifically the id grain) inside a Jinja template. It looks something like `{{ salt['grains.get']('id') }}` or just using the grains dictionary directly.

**The template argument:**
Look at the documentation for the file.managed state. You need to pass an argument that tells it to render the file as a Jinja template.

**Requisites:**
Look up Salt's require statement. You'll add this to your service.running block to link it to your pkg.installed block.