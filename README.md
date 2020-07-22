# NAPTIME

REST Library for the IBM i

## Building the objects

1. `CRTLIB NAPTIME`
2. `CRTLIB MACHINIC`
3. Clone the repository in the IFS
   1. Use git if you have it installed, or
   2. Upload via FTP (make sure to [set namefmt](https://www.mcpressonline.com/it-infrastructure-other/general/the-one-as400-ftp-command-you-must-understand))
4. Building
   1. Run `gmake` via an SSH shell.
   2. `CALL QP2TERM`, cd to the source directory on the IFS, run `/QOpenSys/pkgs/bin/gmake`.
5. To create a save file of the release libraries, run `/QOpenSys/pkgs/bin/gmake savf`.

## Requirements:

* `gmake` can be installed with yum: `yum install make-gnu.ppc64`.
  * Install yum using the [ibmi/opensource bootscript](https://bitbucket.org/ibmi/opensource/src/bcdc13fd89f64b74f669eb1ca77126a60be2edf6/docs/yum/#markdown-header-installation).
* `base64` can be installed with yum: `yum install coreutils-gnu.ppc64`

## Use

* `CHGJOB CCSID(37)`
* `SENDREQ`
* `DUPPDFCHK`

File size limit: 5MB (both files together. Add an extra 30% to account for base64 encoding).
