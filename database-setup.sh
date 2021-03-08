#!/bin/bash

sudo docker-compose run --rm outline yarn sequelize db:setup --env=production-ssl-disabled
sudo docker-compose run --rm outline yarn sequelize db:migrate --env=production-ssl-disabled
