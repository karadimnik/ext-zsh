# Workspace

#### For containerized changes/development

Clone the repository.
Make changes in `Dockerfile` and/or `docker-compose.yml` along with any configuration needed in scripts. 

    $ docker compose build  [ builds the image - if needed ]
    $ docker compose up -d  [ creates and starts a container ]

---

#### For local installation

Clone the repository.

    $ chmod u+x setup-zsh.sh
    $ ./setup-zsh.sh
