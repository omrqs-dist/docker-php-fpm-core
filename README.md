# Docker file

This project has the docker-files for core (api) omrqs project

## Steps to upgrade
### Local
* Do change on Dockerfile
* Run build
```
docker build -t omrqs:{any-name} .
```

* Set your environment to {any-name} was build  on docker-compose and test your application.
* If reproduced all steps without any problem, create a new tag and push.
* Check automated build on organization hub.docker .

### Pushing to Docker hub (logged)
docker build -t omrqs/php-core .
docker push omrqs/php-core:{latest|tag}
## References

### Change uid and gid on build and running
```
docker run -p 9000:9000 omrqs:{any-name}
```
