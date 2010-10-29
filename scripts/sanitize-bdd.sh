#!/bin/bash

#@file
# dump Drupal database, import in temporary base and clean sensitive information before redump
#
# IMPORTANT
# You need to create a mutlisite named as $tmpsite in sites/ and set a valid settings.php on the $tmpsite databases
#
#@author Guillaume Bec <guillaume.bec@gmail.com>

tmpsite=sandfr
exportfile="/home/drupalfr/export/sandfr-$(date +%F).sql"
drupal=/home/drupalfr/www/
sansql=/home/drupalfr/scripts/sanitize.sql
confdrush=/home/drupalfr/scripts/drushrc.php
DRUSH=`which drush`

$DRUSH sql-sync -y -r $drupal -c $confdrush --structure-tables-key=sanitize --create-db default $tmpsite
$DRUSH -y -r $drupal -l $tmpsite sql-cli < $sansql
$DRUSH -y -r $drupal -l $tmpsite sql-dump > $exportfile
