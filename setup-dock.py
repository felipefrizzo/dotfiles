#!/usr/bin/env python
# encoding: utf-8
"""
setup-dock.py

This script configures the Dock content the
way I like it. Use with caution...

Hannes Juutilainen <hjuutilainen@mac.com>
"""

import sys
import getopt
import os
import subprocess
import plistlib
import getpass


# =======================================
# Standard Applications
# =======================================
appleApps = [
    "/System/Applications/Utilities/Terminal.app",
    "/Applications/Safari.app",
    "/System/Applications/System Preferences.app"
]

# =======================================
# Optional Applications
# Add these if they exist or "forced"==True
# =======================================
thirdPartyApps = [
    {
        "path": "/Applications/Microsoft Outlook.app",
        "args": [ "--before", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/LastPass.app",
        "args": [ "--before", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/1Password 7.app",
        "args": [ "--before", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/Authy Desktop.app",
        "args": [ "--before", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/Opera developer.app",
        "args": [ "--after", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/Firefox Developer Edition.app",
        "args": [ "--after", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/Google Chrome Canary.app",
        "args": [ "--after", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/Brave Browser.app",
        "args": [ "--after", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/PyCharm CE.app",
        "args": [ "--after", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/Visual Studio Code.app",
        "args": [ "--after", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/Sourcetree.app",
        "args": [ "--after", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/iTerm.app",
        "args": [ "--after", "Terminal" ],
        "forced": True
    },
    {
        "path": "/Applications/Skype.app",
        "args": [ "--after", "Safari" ],
        "forced": True
    },
    {
        "path": "/Applications/Slack.app",
        "args": [ "--after", "Safari" ],
        "forced": True
    },
    {
        "path": "/Applications/Spotify.app",
        "args": [ "--after", "Safari" ],
        "forced": True
    },
]

dockutilPath = ""

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def dockutilExists():
    whichProcess = ["which", "dockutil"]
    p = subprocess.Popen(whichProcess, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (path, err) = p.communicate()
    if os.path.exists(path.strip()):
        global dockutilPath
        dockutilPath = path.strip()
        return True
    else:
        return False

def removeEverything( restartDock=False ):
    dockutilProcess = [dockutilPath, "--remove", "all"]
    if not restartDock:
        dockutilProcess.append("--no-restart")
    p = subprocess.Popen(dockutilProcess, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (output, err) = p.communicate()
    pass

def dockutilAdd(aPath, args):
    dockutilProcess = [dockutilPath, "--add", aPath]
    if args:
        dockutilProcess = dockutilProcess + args
    dockutilProcess.append("--no-restart")
    p = subprocess.Popen(dockutilProcess, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (output, err) = p.communicate()
    pass

def localDisks():
    """Run diskutil list -plist """
    diskutilProcess = ["diskutil", "list", "-plist"]
    p = subprocess.Popen(diskutilProcess, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (output, err) = p.communicate()
    if output != "":
        outputPlist = plistlib.readPlistFromString(output)
        return outputPlist['VolumesFromDisks']
    else:
        return None

def addFolders():
    """
    Loop through all local disks and check if they contain:
        <Disk>/Users/username/Documents
        <Disk>/Users/username/Downloads
        or
        <Disk>/home/username/Documents
        <Disk>/home/username/Downloads

    Add everything that exists.
    """
    username = getpass.getuser()
    pathsToCheckInDisks = ["Users", "home"]
    for aDisk in localDisks():
        diskPath = os.path.join("/Volumes", aDisk)
        for aPath in pathsToCheckInDisks:
            homePath = os.path.join(diskPath, aPath, username)
            homePath = os.path.realpath(homePath)
            # documents = os.path.join(homePath, "Documents")
            downloads = os.path.join(homePath, "Downloads")
            # if os.path.exists(documents):
            #     label = "Documents"
            #     args = [
            #         "--view", "grid",
            #         "--display", "stack",
            #         "--sort", "name",
            #         "--label", label
            #     ]
            #     dockutilAdd(documents, args)
            #     print("Added %s" % documents)
            if os.path.exists(downloads):
                label = "Downloads"
                args = [
                    "--view", "grid",
                    "--display", "stack",
                    "--sort", "dateadded",
                    "--label", label
                ]
                dockutilAdd(downloads, args)
                print("Added %s" % downloads)


def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        if not dockutilExists():
            print("dockutil not found")
            print("Get it from https://github.com/kcrawford/dockutil")
            print("or run \"git clone https://github.com/kcrawford/dockutil.git\"")
            return 1

        confirmation = input("Are you sure? y/n: ").lower()
        if confirmation == 'y':
            print("Continuing...")
        elif confirmation == '' or confirmation == 'n':
            raise Usage("Exiting...")
        else:
            print('Please enter y or n.')
            return 1

        # Start with an empty Dock
        removeEverything(restartDock=False)

        # Add standard Apple apps
        for anApp in appleApps:
            dockutilAdd(anApp, None)
            print("Added %s" % anApp)

        # Add 3rd party apps
        for anApp in thirdPartyApps:
            if os.path.exists(anApp["path"]) or anApp["forced"]:
                dockutilAdd(anApp["path"], anApp["args"])
                print("Added %s" % anApp["path"])
            else:
                print("Skipped %s" % anApp["path"])

        # Add folders
        addFolders()

        print("Done. You might want to restart Dock by running \"killall Dock\"")

    except Usage as err:
        print(">> %s\n" % err, file=sys.stderr)
        return 2

if __name__ == "__main__":
    sys.exit(main())
