#!/bin/bash

sudo docker-compose run --rm outline yarn sequelize db:create --env=production-ssl-disabled
sudo docker-compose run --rm outline yarn sequelize db:migrate --env=production-ssl-disabled
