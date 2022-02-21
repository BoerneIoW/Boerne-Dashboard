FROM rocker/tidyverse:latest
# FROM rocker/rstudio:4.0.3

MAINTAINER Kyle Onda "kyle.onda@duke.edu"
 
USER root

# Install dependencies
RUN apt-get update 
RUN apt-get install -y cron 
RUN apt-get install -y nano 
RUN cron start


# install R packages
RUN R -e "install.packages(c('readxl','httr', 'parsedate', 'jsonlite', 'cronR', 'rstudioapi', 'readxl', 'sf', 'rgdal', 'spData', 'raster', 'tidycensus', 'tidyverse', 'lubridate', 'rmapshaper', 'geojsonio', 'rvest', 'purrr', 'stringr','dataRetrieval', 'leaflet', 'EGRET'), dependencies = TRUE)"
	

# copy folder which contains cronfile, RScript 
COPY /src    /src  
WORKDIR /src


# make all app files readable, gives rwe permisssion (solves issue when dev in Windows, but building in Ubuntu)
RUN chmod -R 755 /src
#RUN chmod 0744 /src/R-Docker-Post-test.R

# Apply cron job
RUN touch /src/cron.log
#RUN (crontab -l ; echo "* * * * * /usr/local/bin/Rscript '/src/run.R'  >> /var/log/cron.log") | crontab

RUN crontab /src/cronjob
ENTRYPOINT ["cron", "-f"]
#CMD cron && tail -f /var/log/cron.log
#CMD /usr/local/bin/Rscript /src/R-Docker-Post-test.R

# Run the command on container startup with extra touch as https://stackoverflow.com/questions/43802109/output-of-tail-f-at-the-end-of-a-docker-cmd-is-not-showing/43807880#43807880. Otherwise if seperate RUN touch recipe layer the output does not get appenended.
# CMD echo "cronjob gets started" && (cron) && echo "now touch n' tail" && touch /var/log/cron.log && tail -f /var/log/cron.log
