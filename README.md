#Docker yml setup for php, mysql and nginx and instructions for laravel setup
### Just place your php files or laravel in app/public folder and get it running
#### Use docker-compose build and docker-compose up to get it going
#### Its mapped with port 81 to access. You can change that from configurations
#### http://localhost:81/yourphpfile.php is a test url
#### dont forget to create app/public  folder. In case you want to setup laravel do keep public folder blank
 

### STEPS TO START LARAVEL

####1) docker-compose --project-name pompy up -d --build

####2) docker  exec -it pompy_php /bin/bash (get inside container)

####3) cd /app cd public (just go to the source folder where you will install laravel)

####4) curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

####(get composer -- in case composer doesnt work)

####5) composer create-project laravel/laravel . (Laravel will be installed)

####6) storage  permission for laravel

####sudo chmod -R ugo+rw storage

####7) try to run http://localhost:81/public/  

####You will see the page

####8) Other Handy commands

####docker ps

####docker-compose down --remove-orphans
