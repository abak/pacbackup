#!/usr/bin/python

import argparse

import pyalpm
from pycman import config



def main(args):
  parser = argparse.ArgumentParser

  handle = config.init_with_config("/etc/pacman.conf")
  pyalpm.Handle("/", "/var/lib/pacman")
  syncpkgs = set()
  print(handle.get_syncdbs())
  for db in handle.get_syncdbs():
    syncpkgs |= set(p.name for p in db.pkgcache)

  db = handle.get_localdb()
  pkglist = [x for x in db.pkgcache if x.reason == pyalpm.PKG_REASON_EXPLICIT]

  native_pkg = [x for x in pkglist if x.name in syncpkgs]
  aur_pkg    = [x for x in pkglist if x.name not in syncpkgs]

  print("native : ")
  for pkg in native_pkg:
    print("\t" + pkg.name)

  print("AUR : ")
  for pkg in aur_pkg:
    print("\t" + pkg.name)

if __name__ == '__main__':
  import sys
  main(sys.argv)