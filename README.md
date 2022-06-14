# Replay

A simple PowerShell script to replay submitting jobs to a hotfolder, based on a timestamp in the filename.

## Description

The project contains the script itself `timecopy-files.ps1`, an additional script for generating mockup data files with a timestamp in their name, and some test data generated with that script.

The use case for this script is to replay a workload from an automation tool. If input files are saved with a timestamp in their name when captured, they can be replayed at a different moment, and even in a different environment. Useful for reproducing issues that require a certain workload, and chain of event.

## Getting Started

### Dependencies

* PowerShell 5.1

### Installing

* Just download the script and run it from the command-line or your favorite automation tool.

### Running

The script takes 4 parameters, but only one is mandatory:
* Destination (mandatory) - the destination folder to copy files to.
* Source (optional) - the source folder to look for files with a timestamp in their name; default: current working directory.
* FilenamePattern (optional) - regular expression that all files should match, *must* include a capturing group for the timestamp; default: `input-(2022[0-9]{4}-[0-9]{6}-[0-9]{3}).txt`.
* TimestampFormat (optional) - format specifier for date and time in the Microsoft .NET Framework format; default: `yyyyMMdd-HHmmss-fff`.

## Help

The script will copy files from the source folder, so they are not removed.

The timestamp in the filenames is used to determine how much time is taken in between copying the next file. The timestamp does not determine when copying starts, copying starts immediately.

Files that don't fit the pattern are skipped, as are files that don't have a timestamp that matches the format. This triggers a warning for each file.

## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details
