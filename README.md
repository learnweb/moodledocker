Moodledocker development environment
------------------------------------

This is the current docker-based development environment.

## It allows

* easy provisioning of new development instances (simple commands to create a docker-compose configuration for a given Moodle Git repository
* data separation between instances (no one can accidentally conflict with / overwrite another)
* selective starting and stopping of development instances (esp.: memory of my development machine is not polluted with an always-running postgres server)
* prevention of clashing namespaces
* 

## Installation

1. Create a dedicated folder that will contain all instances. Mine is located at `~/Moodledocker`.
2. Within that folder, clone this repository into a folder called `Metafiles`: `git clone https://github.com/Dagefoerde/Moodledocker.git Metafiles`.
3. Create a symbolic link to Moodledocker/Scripts/moodledocker, e.g. `ln -s ~/Moodledocker/Metafiles/Scripts/moodledocker ~/bin/moodledocker`.
4. Also, clone a customised nginx-proxy that will manage redirection to the correct instance: `git clone git@github.com:tobiasreischmann/nginx-proxy.git`.
5. Enter `nginx-proxy` and build the image: `docker build -t jwilder/nginx-proxy .`.

## First use

1. Check out a Moodle git respository somewhere (NOT below `~/Moodledocker`!).
2. Choose a name `NAME` that you recognise. Navigate into the repository and enter `moodledocker createhere NAME`.  That command will create the necessary files and folder structure. It will also create a `config.php` for you, if you like (on first start, you should!).
3. Start the instance by invoking `moodledocker control NAME up`. If the nginx proxy server is not running yet, the output will tell you how to start it.
