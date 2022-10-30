# Workspace

### For containerized development/testing

Make changes in `Dockerfile` and/or `docker-compose.yml` along with any configuration needed in scripts then 

##### rebuilt image
    
    docker compose build

##### run the image in a container
  
    docker compose up -d

##### attach a shell session and test the setup

    docker exec -it script-testbench /usr/bin/zsh

---

### For local installation

##### clone the repo

    git clone git@github.com:karadimnik/shell-setup-automation.git

##### enter the directory   
    
    cd shell-setup-automation

##### run the main script

    ./setup-zsh.sh

*permissions might need fixing for the \*.sh files*
