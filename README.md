# README

To make it easy for you i make a docker compose to contain four services :
* web(rails) 
* postgres 
* redis
* sidekiq

### to run the project all you need is :
* to run `docker compose up --build`

### if you face a problem or the docker stuck at postgres container all you have to do is to stop the docker and run again `docker compose up --build`

### if you want to to run rspec test :
* run `docker exec -it <web_container_name> bash `
* then run `bundle exec rspec spec/<path_to_rspec_file>`
