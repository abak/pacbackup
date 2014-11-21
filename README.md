pacbackup
=========

Arch is a great system, and pacman is a greate package mananger. However, Arch being a rolling release distro, updates can break things. Arch being a DIY distro *you* can break things. If most of the time, you can fix things, it can happen that your installed is broken beyond all repair and the solution is to start again from a clean install.

If you're like me, your data is usually safe and backed-up a gazillion times to prvent this> One problem I had though, is that I couldn't back-up the list of packages I had installed, whether from the official repo, or from AUR. Pacbackup provides this.


## What pacbackup provides

### pacbackup.py

Pacbackup consists of two components. First there is a deamon that regularly queries pacman database to keep track of all explicitly installed packages. It saves this list in a user supplied folder and manage a local git repository in that directory to keep an history of when what was installed.

###pacrestore.sh

The second component is a shell script, stored alongside the package list that performs the restoration. This script will read the package list, restore all packages from the official repos, and then will restore all packages from AUR, including their dependencies.

### systemd integration

The package also includes systemd unit and timer files to perform regular backups. These will be installed under ````/etc/systemd/user```` and are *not* enabled by default since you might want to edit them beforehand.


## What pacbackup does *not* provide

###Offsite backups

pacbackup does not directly provides offsite backup facilities. However, ther are several solutions readily available:

  * Include pacbackup target folder in your regular backup, which I'm sure you do the right way.

  * tell pacbackup to target a remote/cloud based folder (Dropbox-like)

  * edit the managed git repo to perform post-commit push to a remote

###Snapshot restoration

As far as I know, due to the rolling nature of Arch, it is not directly possible to install a specific version of a package if you don't have the corresponding tarball. My first concern with pacbackup was to get my machine up and running in a catastrophic event, so it's not really possible to assume that specific versions of software are locally available.

## How to install

Pacbackup is available on the [AUR](https://aur.archlinux.org/packages/pacbackup/), you can also clone this repo to install it manually via 

    python setup.py install

