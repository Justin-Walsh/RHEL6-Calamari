# Calamari builder for Redhat (RHEL 6)
## What it does
Creates a Calamari build for RedHat 6. As the Octopus-supplied Calamari is built against RHEL7, it uses a higher version of `glibc` than is available on RHEL6. This tool will pull down the latest tagged Calamari release and compile it to be compatible with RHEL/CentOS 6 systems.

## Using this tool
This script will need to be run on a linux machine that has:
- `git`
- `Docker` and run from a user with access to manipulate docker on the machine. Worst case, you can run the script via `sudo` (with all the usual caveats, read the scripts and know what they do etc.)

1. Ensure that the docker service is running on the machine, and the current user has access to the docker engine.
2. Verify the version of Calamari your Octopus server uses, performing a healthcheck on the target will reveal this data.
3. `git clone` this repo onto the machine.
4. Set the `GIT_VERSION` environmental variable to the calamari version you need.
4. Run `./build.sh`
5. When the script finishes, you should find the file in the `artifacts-history` folder, named `calamari-rhel.6-x64-<VERSION>.tar.gz`

**NOTE:** If the filename does not have a valid version, and is just named `calamari-rhel.6-x64-.tar.gz`, it's very likely something has gone wrong with the script (Docker service not running, user doesn't have access etc.). Please be sure to look at the logs and rectify what's wrong.

## Using the compiled Calamari package.
1. Create an SSH target in the Octopus server for your RHEL 6 server.
2. Do a sample deployment, which will fail due to the shipped Calamari version not being compatible. This will build all of the directory structure.
3. Copy/scp the output file of the script onto the server.
4. Navigate to `~/.octopus/OctopusServer/Tools/Calamari.linux-x64/<VERSION>/` for the SSH user that Octopus uses, and delete the Calamari install there.
5. Extract the custom version to the directory in the previous step and `touch Success.txt` to generate this file.
6. Enjoy deploying to RHEL 6!

## What could go wrong?
- Calamari core dumps not being able to file ICU libraries.

Assuming you followed the directions [Microsoft's instructions](https://github.com/dotnet/core/commit/0b1a1631593d6d379fbdfe2b23597a5c25ea4fc9), you will likely need to add the `export LD_LIBRARY_PATH=/usr/local/lib` to your `.bashrc` file.

- I updated Octopus, and now my deployments are failing!

You will likely need to repeat the steps for the new version of Calamari that ships with your upgraded version. 


