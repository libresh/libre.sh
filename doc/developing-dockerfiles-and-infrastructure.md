# Developing Dockerfiles and infrastructure

## Developing Dockerfiles

To develop Dockerfiles, you can use a server that's not serving any live domains, use `docker` locally on your laptop, or use the `vagrant up` instructions to run the infrastructure inside vagrant.

## Developing infrastructure

To develop the infrastructure, create a branch on the infrastructure repo and specify that branch at the end of the deploy command, for instance:

```bash
sh ./deploy/deploy.sh k4 dev
```

Will deploy a server at whatever IP address "k4" points to in your /etc/hosts, using the "dev" branch of https://github.com/indiehosters/infrastructure.

## Testing new Dockerfiles in the infrastructure

To test the infrastructure with a changed Dockerfile, you need to take several steps:

* Develop the new Dockerfiles as described above at "Developing Dockerfiles"
* When you're happy with the result, publish this new Dockerfile onto the docker hub registry under your own username (e.g. michielbdejong/haproxy-with-http-2.0)
* Now create a branch on the infrastructure repo (e.g. "dev-http-2.0")
* In this branch, grep for the Dockerfile you are updating, and replace its name with the experimental one everywhere:
  * the `docker pull` statement in scripts/setup.sh
  * the `docker run` statement in the appropriate systemd service file inside unit-files/
* Push the branch to the https://github.com/indiehosters/infrastructure repo
* Now deploy a server from your experimental infrastructure branch (which references your experimental Docker image), as described above at "Developing infrastructure"
