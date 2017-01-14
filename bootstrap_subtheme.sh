#!/bin/bash

# Check we are in docroot and bootstrap theme exists.
if [ ! -d "themes/contrib/bootstrap" ]; then
  echo "This must be run from Drupal docroot.";
  echo "This script assumes this path exists:  themes/contrib/bootstrap";
  exit
fi

# Prompts for the sitename.com if not entered.
bootstrap_subtheme_enter_machine_name() {
  echo "Requires theme machine_name and Title. Example:"
  echo "bootstrap_subtheme my_theme 'My Theme'"
  read -r -p "Enter [machine_name]: " machine_name
  if [ -z "$machine_name" ]; then
    bootstrap_subtheme_enter_machine_name
  fi
}

# Prompts for the sitename.com if not entered.
bootstrap_subtheme_enter_theme_name() {
  echo "Requires theme machine_name and Title. Example:"
  echo "bootstrap_subtheme my_theme 'My Theme'"
  read -r -p "Enter ['My Theme Title']: " theme_title
  if [ -z "$theme_title" ]; then
    bootstrap_subtheme_enter_theme_name
  fi
}

# Ensure machine_name.
machine_name=$1;
if [ -z "$machine_name" ]; then
  bootstrap_subtheme_enter_machine_name
fi

# Ensure theme_title.
theme_title=$2;
if [ -z "$theme_title" ]; then
  bootstrap_subtheme_enter_theme_name
fi

# Make a subtheme from bootstrap core.
mkdir -p themes/custom
cp themes/contrib/bootstrap/starterkits/cdn themes/custom/"$machine_name" -af
find ./themes/custom/"$machine_name"/ -name "*.yml" -type f -exec sed -i "s/THEMENAME/$machine_name/g" {} \;
find ./themes/custom/"$machine_name"/ -name "*.yml" -type f -exec sed -i "s/THEMETITLE/$theme_title/g" {} \;

# Rename THEMENAME.files
echo "Renaming THEMENAME.* files to $machine_name.*:";
#echo `find ./themes/custom/"$machine_name"/ -name "THEMENAME.*" -type f`;

# This comes close to working, but the $machine_name var is lost in the new bash session.
#find ./themes/custom/"$machine_name"/ -depth -name "THEMENAME.*" -type f -exec bash -c 'mv "$1" `echo "$1" | sed s/THEMENAME/"$machine_name"/g`' bash {} \;

# Move them a very boring and unimpressive way :(
#mv ./themes/custom/"$machine_name"/THEMENAME.libraries.yml ./themes/custom/"$machine_name"/"$machine_name".libraries.yml
#mv ./themes/custom/"$machine_name"/THEMENAME.starterkit.yml ./themes/custom/"$machine_name"/"$machine_name".info.yml
#mv ./themes/custom/"$machine_name"/config/install/THEMENAME.settings.yml ./themes/custom/"$machine_name"/config/install/"$machine_name".settings.yml
#mv ./themes/custom/"$machine_name"/config/schema/THEMENAME.schema.yml ./themes/custom/"$machine_name"/config/schema/"$machine_name".schema.yml
#mv ./themes/custom/"$machine_name"/THEMENAME.theme ./themes/custom/"$machine_name"/"$machine_name".theme

# New approach to move them:
for file in $(find ./themes/custom/"$machine_name"/ -name "THEMENAME.*" -type f)
  do
    echo ' Move ' "$file" 'to' `echo "$file" | sed s/THEMENAME/"$machine_name"/g`
    mv "$file" `echo "$file" | sed s/THEMENAME/"$machine_name"/g`
  done

# Now move the info file to proper name.
mv ./themes/custom/"$machine_name"/"$machine_name".starterkit.yml ./themes/custom/"$machine_name"/"$machine_name".info.yml
