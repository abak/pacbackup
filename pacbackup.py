#!/usr/bin/python

import argparse

import pyalpm
from pycman import config

def pkg_info_str(pkg):
  return str(pkg.name + "\t" + pkg.version)

class PacBackup:
  def __init__(self, options):
    self.handle = config.init_with_config_and_options(options)
    self.backup_file_path = options.backup_config
    self.verbosity = options.verbose

  def retrieve_pkg_lists(self):
    syncpkgs = set()
    for db in self.handle.get_syncdbs():
      syncpkgs |= set(p.name for p in db.pkgcache)

    db = self.handle.get_localdb()

    self.native_pkg = [x for x in db.pkgcache if x.reason == pyalpm.PKG_REASON_EXPLICIT and x.name in syncpkgs]
    self.aur_pkg    = [x for x in db.pkgcache if x.reason == pyalpm.PKG_REASON_EXPLICIT and x.name not in syncpkgs]

    if self.verbosity :
      print("native : ")
      for pkg in self.native_pkg:
        print("\t" + pkg_info_str(pkg))

      print("AUR : ")
      for pkg in self.aur_pkg:
        print("\t" + pkg_info_str(pkg))

  def backup_pkg_lists(self):

def main():

  parser = config.make_parser(description='Backs-up the list of pacman-installed packages on the system.', 
    prog = 'pacbackup')

  group = parser.add_argument_group("Backup options")
  group.add_argument('--backup-config', metavar='<path>', default='~/.config/pacbackup/pkglist', 
    help = "specifies the backup file location, default : ~/.config/pacbackup/pkglist")
  # group.add_argument('--verbose', '-v', action='store_true', help="verbose output")

  backup = PacBackup(parser.parse_args())
  backup.retrieve_pkg_lists()


if __name__ == '__main__':
  main()