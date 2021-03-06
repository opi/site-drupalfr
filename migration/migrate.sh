#!/bin/bash
set -xe


# Synchronize files.
#rm -Rf ../www7/sites/default/files
#cp -r ../files ../www7/sites/default
#find ../www7/sites/default/files -type d -print0 | xargs -0 chmod g+rwxs
#find ../www7/sites/default/files -type f -print0 | xargs -0 chmod g+rw

# Clean-up the database.
drush sqlc < ../migration/sql/pre-import.sql

# Import the D6 database.
cat ../export/drupalfr-live-sanitized.sql | sed -e 's/^) ENGINE=InnoDB/) ENGINE=MyISAM/' | drush sqlc

# Fix some of the properties of the D6 database.
drush sqlc < ../migration/sql/pre-migration.sql

# Try a migration.
drush updatedb -y --verbose

# enable modules
drush en -y drupalfr_user
drush en -y content_migrate
drush en -y dfr_migration
drush en -y markdown
drush en -y dfr_documentation
drush en -y toolbar
drush en -y token
drush en -y contextual
drush en -y image
drush en -y rdf
drush en -y shortcut
drush en -y codefilter
drush en -y entity
drush en -y diff
drush en -y mollom
drush en -y pathauto
drush en -y redirect
drush en -y strongarm
drush en -y views views_ui
drush en -y features
drush en -y email link node_reference user_reference
drush en -y flag 
drush en -y rules rules_admin
drush en -y phone

drush cc all
drush updatedb -y --verbose
drush en -y dfr_format
drush cc all
drush en -y migrate
drush -y content-migrate-fields
drush cc all

echo "aller sur la page admin/migration et lancer la migration\n";
