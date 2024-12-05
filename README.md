Minimal Data-Oriented Programming (DOP) Vulnerable Server + Exploits
-------------------------------------------------------------
![GitHub](https://img.shields.io/github/license/mayanez/min-dop)

This is a fork of https://github.com/mayanez/min-dop, modified to use (and exploit) stack variables as opposed to global variables, primarily for the purpose of demonstrating the use of [Stackato](https://github.com/naveen-u/cse-583-project). This version does not support finding the required variable offsets with `gdb` as variables are no longer global.

## Description
Refer the [README file for the original repo](README_ORIGINAL.md) for details about the server, vulnerabilities, and exploits. The version of the server on this branch is a modified version in which all global variables have been modified to be stack variables. The original version used global variables so that relative offsets of variables could be conveniently discovered using `gdb` for testing and demonstration. This version was created for demonstrating the use of [Stackato](https://github.com/naveen-u/cse-583-project), an LLVM pass that adds runtime-random padding in between stack variables to prevent DOP attacks which rely on static relative distances between variables.

## Build
The project includes two Docker environments that contains all the necessary dependencies. The first, described in [`Dockerfile.vuln`](Dockerfile.vuln), runs the vulnerable server as is. The second, described in [`Dockerfile.hardened`](Dockerfile.hardened), builds the server using [Stackato](https://github.com/naveen-u/cse-583-project), thereby thwarting exploit attempts on the server.

To launch the docker containers, run the following from the root of the repository
```console
$ docker-compose up -d
```
This builds both containers and starts the respective servers. In order to see server logs, simply attach to the respective running container:
```console
$ docker attach min-dop-vuln
```
for the vulnerable server and 
```console
$ docker attach min-dop-hardened
```
for the [Stackato](https://github.com/naveen-u/cse-583-project)-hardened server respectively.

## Running the Exploit
`gdb` support is turned off in this branch as global variables have been changed to stack variables. Therefore, it is necessary to first "guess" relative distances between variables and populate these values in the `exploit.py` file. Note that these offsets may change based on the system.

The `exploit_runner.py` script has been modified in this version to remove the `--gdb` option. The script also makes `--mode` optional and defaults its value to `4` (the [Secret Leak / Exfiltrate](README_ORIGINAL.md#secret-leak--exfiltrate) exploit).

With the correct offsets, the vulnerable server in the `min-dop-vuln` container can be exploited. 
```console
$ docker exec -it min-dop-hardened bash
(min-dop-hardened)$ ./exploit_runner.py
```

However, exploit attempts in the hardened server will continue to fail or give garbage values since the relative distances are run-time random.
```console
$ docker exec -it min-dop-hardened bash
(min-dop-hardened)$ ./exploit_runner.py
```