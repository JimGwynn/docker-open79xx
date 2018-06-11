# docker-open79xx
Docker image for Open79XX
Image contains Nginx, PHP and MySQL along with the webcode and database for Open79XX.
To use run

docker run -d -p80:80 hdrider465/docker-open79xx

Open a browser and navigate to your docker host http://dockerhost

Default user is admin password is core

in the SEPMAC.cnf.xml phone files add

http://dockerserver/PhoneUI as the services URL

<servicesURL>http://dockerserver/PhoneUI/</servicesURL>
