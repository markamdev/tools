# UserMover - save and restore Linux user account

*UserMover* is a simple bash-based tool that simplifies moving Linux user accounts between machines.

Currently the tool is able to:

* check user's id and home dir
* save full user's home dir in .tar.gz file
* save user's password (hashed value from /etc/shadow) to be used on new machine
* save list of user groups

## Installation

As this tool is just a bunch of scripts there's no need to install it.
User just has to download it from the git repository:

```bash
git clone http://github.com/markamdev/user-mover
```

## Usage

### Saving user data

### Restoring user data on new system

**TODO** put some usage examples

## Planned extensions

*TODO* list for project contains following items:

* restoring user groups
* checking/saving *sudo* permissions
* multiple users saving at one `save-user.sh` call
* output path configuration

## Author

If you need to contact me feel free to write me an email:
[markamdev.84#dontwantSPAM#gmail.com](maitlo:)
