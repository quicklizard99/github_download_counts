#!/usr/bin/env python3
import argparse
import csv
import sys

from collections import namedtuple

import requests

URL = 'https://api.github.com/repos/{user}/{repo}/releases'

AssetInfo = namedtuple('AssetInfo', ['type', 'os', 'bits'])


def asset_info(name):
    """Returns an instance of AssetInfo, making a lot of sweeping assumptions
    about the format of the asset name.
    """
    if name.endswith('-amd64.msi'):
        return AssetInfo('Installer', 'Windows', '64')
    elif name.endswith('-win32.msi'):
        return AssetInfo('Installer', 'Windows', '32')
    elif name.endswith('.dmg'):
        return AssetInfo('Installer', 'Mac OS X', '64')
    else:
        return None


def print_github_downloads(user, repo):
    releases = requests.get(URL.format(user=user, repo=repo)).json()
    writer = csv.writer(sys.stdout, lineterminator='\n')
    writer.writerow((
        'tag_name', 'created_at', 'name', 'type', 'os', 'bits',
        'download_count'
    ))
    for release in releases:
        for asset in release['assets']:
            info = asset_info(asset['name'])
            if info:
                writer.writerow((
                    release['tag_name'], release['created_at'], asset['name'],
                    info.type, info.os, info.bits, asset['download_count']
                ))


def main(args):
    parser = argparse.ArgumentParser(
        description='Prints dowload counts for a github repo'
    )
    parser.add_argument("user")
    parser.add_argument("repo")
    args = parser.parse_args(args)
    print_github_downloads(args.user, args.repo)


if __name__ == '__main__':
    main(sys.argv[1:])
