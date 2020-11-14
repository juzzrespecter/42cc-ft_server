# ft_server
Part of 42 common-core cursus: introduction to Docker and system administration.
This project consists on installing, using Docker, a complete web server on a container ready to work, running Wordpress, phpMyAdmin and a SQL database with nginx.
## Installing the server
To build and set up the server:
```
docker build . -t ft_server
docker run -p80:80 -p443:443 --name ft_server ft_server
```
Use --env AIENV=off when building the container to set off autoindex on nginx.
