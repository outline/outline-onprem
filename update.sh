#!/bin/bash

sudo docker-compose pull outline
sudo docker-compose run --rm outline yarn sequelize db:migrate --env=production-ssl-disabled
