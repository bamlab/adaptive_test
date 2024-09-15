## 0.5.1

* feat: add support for skipping tests instead of failing them based on the enforced target platform defined in the `AdaptiveTestConfiguration` class.

## 0.5.0

**Breaking changes**

* Remove the semi colon in golden file names to support using the package on a Windows machine. 
  
  This is a breaking change for users who have generated golden files with the previous version of the library. The golden file names will now be `preview/${windowConfig.name}-${name.snakeCase}$localSuffix.png` instead of `preview/${windowConfig.name}:${name.snakeCase}$localSuffix.png`.

  To resolve this, you can either rename the golden files manually or regenerate them.

  To ease the migration, we provide a script that will rename your goldens files to the new format:
  ```bash
  #!/bin/bash

  # Function to rename files in directories named "preview"
  rename_files_in_preview() {
      # Find directories named "preview"
      find . -type d -name "preview" | while read -r dir; do
          echo "Processing directory: $dir"
          # Find files within these directories
          find "$dir" -type f | while read -r file; do
              # New filename by replacing ':' with '-'
              new_name=$(echo "$file" | sed 's/:/-/g')
              if [ "$file" != "$new_name" ]; then
                  mv "$file" "$new_name"
                  echo "Renamed $file to $new_name"
              fi
          done
      done
  }

  # Call the function
  rename_files_in_preview()
  ```

  You can add the script in a `.sh` file and run it from your project root directory.

## 0.4.1

* fix: Update broken link on README.md

## 0.4.0

* fix: add support for flutter >=3.10.0
* fix: add support for dart >=3.0.5

## 0.3.2

* feat: add the `loadFontsFromPackage` method to load fonts from a package which name does not match the corresponding folder name
* example: add multi-packages example to showcase loading fonts from a separate package

## 0.3.1

* fix: replace iterable with a list in the await image method.

## 0.3.0

**Breaking changes**

* Remove the space in golden file names. 
  
  This is a breaking change for users who have generated golden files with the previous version of the library. The golden file names will now be `preview/${windowConfig.name}:${name.snakeCase}$localSuffix.png` instead of `preview/${windowConfig.name}: ${name.snakeCase}$localSuffix.png`.

  To resolve this, you can either rename the golden files manually or regenerate them.

## 0.2.3

* fix: set the image precaching to true by default

## 0.2.2

* feat: add an option to disable the image precaching

## 0.2.1

* fix: runtime platform check.
## 0.2.0

* fix: font loader with package not working.
* feat: create is runtime platform extension.
## 0.1.0

* Add .pubignore to reduce package size.
## 0.0.2

* Improve pub.dev page presentation.

## 0.0.1

* Initial release.
