Moodledocker development environment
------------------------------------

This is the current docker-based development environment.

## It allows

* easy provisioning of new development instances (simple commands to create a docker-compose configuration for a given Moodle Git repository
* data separation between instances (no one can accidentally overwrite another)
* selective starting and stopping of development instances (esp.: memory of my development machine is not polluted with an always-running postgres server)
* prevention of clashing namespaces (on start, an instance will get an available port. Instances may wander around, but the script will help you :wink: )

## Installation

1. Create a dedicated folder that will contain all instances. Mine is located at `~/Moodledocker`.
2. Within that folder, clone this repository into a folder called `Metafiles`: `git clone https://github.com/Dagefoerde/Moodledocker.git Metafiles`.
3. Create a symbolic link to Moodledocker/Scripts/moodledocker, e.g. `ln -s ~/Moodledocker/Metafiles/Scripts/moodledocker ~/bin/moodledocker`.


