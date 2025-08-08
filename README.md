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
2. Within that folder, clone this repository into a folder called `Metafiles`: `git clone https://github.com/learnweb/moodledocker.git Metafiles`.
3. Create a symbolic link to Moodledocker/Scripts/moodledocker, e.g. `ln -s ~/Moodledocker/Metafiles/Scripts/moodledocker ~/bin/moodledocker`.

## First use

1. Check out a Moodle git respository somewhere (NOT below `~/Moodledocker`!).
2. Choose a name `NAME` that you recognise. Navigate into the repository and enter `moodledocker createhere NAME`.  That command will create the necessary files and folder structure. It will also create a `config.php` for you, if you like (on first start, you should!).
3. Start the instance by invoking `moodledocker control NAME up`. If the nginx proxy server is not running yet, the output will tell you how to start it.

(Optionally, you might want to use `sudo docker container exec -it _containerName_ /bin/bash` (where `containerName` can be found with `docker ps`) to have a normal shell for the container.)
## Optional configuration

# Sending emails

The PHP containers provide an msmtp installation. It assumes that an MTA is installed and configured on the Docker host.

You can very easily view outgoing emails without actually sending them, by using mailhog:

`docker run -d -p 25:25 -p 8025:8025 -e MH_SMTP_BIND_ADDR=0.0.0.0:25 --name mailhog mailhog/mailhog`

Otherwise, on Ubuntu, take e.g. postfix. Some useful hints for configuration on Ubuntu:

* Installation: https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-ubuntu-16-04 (you can use `dpkg-reconfigure postfix` to get to the configuration screen after installing postfix. This generates the `main.cf` that you'll need in the following.
* Permit connections from Docker containers: http://satishgandham.com/2016/12/sending-email-from-docker-through-postfix-installed-on-the-host/
* Configuring Postfix to relay email via GMAIL: https://leehblue.com/configure-postfix-send-email-through-gmail/
