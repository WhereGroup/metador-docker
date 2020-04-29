# Metador

## Installation

```bash
# Clone repository
git clone https://github.com/WhereGroup/metador-docker.git
cd metador-docker

# Docker Image erstellen
docker build --build-arg var_user=www-data  --tag "metador-image:latest" .

# Docker Container erstellen
docker run --name metador-container \
    --detach --restart=always \
    --env APACHE_RUN_USER=www-data \
    --env APACHE_RUN_GROUP=www-data \
    --publish 8000:8000 metador-image
```

Aufruf im Browser [localhost:8000](http://localhost:8000)
- Login: `root`  
- Passwort: `metadordemo`  


## Deinstallation

```bash
docker rm --force metador-container && docker image rm --force metador-image
```

## Eine Shell öffnen

```bash
docker exec -it metador-container /bin/bash
```

# Docker Installation

- [Debian](https://docs.docker.com/engine/install/debian/)
- [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
