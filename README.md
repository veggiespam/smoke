# Smoke - Modern Hash Digest Encapsulation

# Introduction 

**`Smoke`** - A unified means of generating, transmitting, encapsulating, and validating multiple hash digests simultaneously to replace existing stand-alone hash digest software.  The software generates digests in parallel and is notably faster than using individual algorithms serially on large files.  Smoke operates much the same way as existing hash digest tools, like md5sum, and Smoke designed to be a full replacement.

Please see the announcement article at https://veggiespam.com/smoke-announce/ for full details.


# Usage

Smoke generates hash digests, just like existing tools such as md5sum or shasum.  It also validates digest checksum files, like the other tools.  Smoke's full command line options are:


```shell
$ ./smoke --help
usage: smoke [-h] [--stdout] [--smoke-file]
                [--smoke-file-name SMOKE_FILE_NAME] [--digest-per-file]
                [--multiple-smokes] [--multiple-sums-digests]
                [--hash-hashed-files] [--ignore-unknown-algs] [-c CHECKFILE]
                [--debug] [--verbose] [--show-algs] [--show-defaults] [-O]
                [-a USE_ALGS] [--version] [--print-config]
                [files [files ...]]

Smoke - A unified means of generating and validating hash digests. Author: Jay
Ball @veggiespam. Command line arguments are beta and subject to change.

optional arguments:
  -h, --help            show this help message and exit

Hash generation destinations:
  Results are sent to stdout by default; can send to specified multiple
  destinations, both files and stdout

  --stdout              Output smoked hash for all files to stdout
  --smoke-file          Save smoked hash to single sums file, SMOKESUMS
  --smoke-file-name SMOKE_FILE_NAME
                        Name of smoked hash file, default SMOKESUMS
  --digest-per-file     Output digests per file, filename.md5, filename.sha1,
                        etc
  --multiple-smokes     Output a smoke for each file, filename1.smoke,
                        filename2.smoke
  --multiple-sums-digests
                        Output multiple digest summaries per algorithm,
                        SHA1SUMS, MD5SUMS, etc.
  --hash-hashed-files   Normally, SMOKESUMS, f.smoke, MD5SUMS, f.md5, f.sha1,
                        etc are ignored; this hashes them anyway

Hash validation:
  --ignore-unknown-algs
                        ignore unknown algs in SUMS file or command line
  -c CHECKFILE, --check CHECKFILE
                        check file to validate against or "-" for stdin
  --debug               debug info to stderr
  --verbose             verbose info to stderr

Options for both:
  --show-algs           Show all supported algorithms and exit
  --show-defaults       Show default used algorithms and exit
  -O, --use-only-algs   Only use algs specified with --use-algs, do not append
                        defaults
  -a USE_ALGS, --use-algs USE_ALGS
                        Algorithms to use, appends to defaults unless --use-
                        only-algs is present
  --version             show program's version number and exit
  --print-config        Print debug configuration and exit
  files                 Files to smoke

$ ./smoke --version
smoke 0.8-beta-1
```

# Sample Runs & Recipes


```shell
# Start with the basics:
$ ls -lg
total 64
-rwxr-xr-x  1 staff  16399 Jan  1 00:01 smoke
-rw-r--r--  1 staff      4 Jan 10 08:23 t123
-rw-r--r--  1 staff      4 Jan 10 08:23 t456

# Our sample data files do not contain a newline:
$ cat t123
t123$ cat t456

$ cat t456
t456$

# From stdin
$ ./smoke  < t123
sha1=05ec834345cbcf1b86f634f11fd79752bf3b01f3;sha512=5c7b8e44d46c535ee4c0caedde5cb4e4dc70826e274ab63f49c4f036e9e337a4b6e4de5a874fe5a2962dc7e603308edbcbd3494ac7ceabdecad057f6596aac4c;md5=cfd12d74bca9357022eb7d8367bcab26	-

# From two files
$ ./smoke t123 t456
sha1=05ec834345cbcf1b86f634f11fd79752bf3b01f3;sha512=5c7b8e44d46c535ee4c0caedde5cb4e4dc70826e274ab63f49c4f036e9e337a4b6e4de5a874fe5a2962dc7e603308edbcbd3494ac7ceabdecad057f6596aac4c;md5=cfd12d74bca9357022eb7d8367bcab26	t123
sha1=c632f2ea2a88f9778276bdc6830f04be67695464;sha512=d9e46b597862a7ecb9489304c0b5b27ef5ce38ca6c0c9193cbdd6cdb888b5fdde9395d54d746051f5010490910fceb0c1dc4e8e0ce2c5b2b9f0a32f9d589c923;md5=1dbdd8f9093b0a0ea51f2a27a2b0b8b3	t456

# Generate only sha256
$ ./smoke -O -a sha256 t123 
#WARN: Only one algorithm specified
sha256=f6b6d0d62eb661c6d3fd7e35e972a8ed44b4aa2fd6c87b449b82b1b7b1a2319f	t123

# Generate both md4 & sha256  (some long options)
$ ./smoke -O -a sha256 --use-algs=md4   t123 
sha256=f6b6d0d62eb661c6d3fd7e35e972a8ed44b4aa2fd6c87b449b82b1b7b1a2319f;md4=4379d075715bd0d0e1187e2e027c98fa	t123



# Hash files and output standard SUMS files (mixed long and short options)
$ ./smoke --multiple-sums-digests --use-only-algs --use-algs=md5,sha1 -a sha256 --smoke-file t123 t456

$ ls -lg
total 128
-rw-r--r--  1 staff     76 Jan 15 09:25 MD5SUMS
-rw-r--r--  1 staff     92 Jan 15 09:25 SHA1SUMS
-rw-r--r--  1 staff    140 Jan 15 09:25 SHA256SUMS
-rw-r--r--  1 staff    320 Jan 15 09:25 SMOKESUMS
-rwxr-xr-x  1 staff  16399 Jan  1 00:01 smoke
-rw-r--r--  1 staff      4 Jan 10 08:23 t123
-rw-r--r--  1 staff      4 Jan 10 08:23 t456

$ head *SUMS
==> MD5SUMS <==
cfd12d74bca9357022eb7d8367bcab26	t123
1dbdd8f9093b0a0ea51f2a27a2b0b8b3	t456

==> SHA1SUMS <==
05ec834345cbcf1b86f634f11fd79752bf3b01f3	t123
c632f2ea2a88f9778276bdc6830f04be67695464	t456

==> SHA256SUMS <==
f6b6d0d62eb661c6d3fd7e35e972a8ed44b4aa2fd6c87b449b82b1b7b1a2319f	t123
7837f643a7b8f50f921383810e7971b4e6283d434b357a594f9358372a909bfd	t456

==> SMOKESUMS <==
sha256=f6b6d0d62eb661c6d3fd7e35e972a8ed44b4aa2fd6c87b449b82b1b7b1a2319f;md5=cfd12d74bca9357022eb7d8367bcab26;sha1=05ec834345cbcf1b86f634f11fd79752bf3b01f3	t123
sha256=7837f643a7b8f50f921383810e7971b4e6283d434b357a594f9358372a909bfd;md5=1dbdd8f9093b0a0ea51f2a27a2b0b8b3;sha1=c632f2ea2a88f9778276bdc6830f04be67695464	t456



# Hash and store digest in individual files
$ ./smoke -O -a whirlpool -a md5 --multiple-smokes --digest-per-file   t123 t456

$ ls -lg
-rwxr-xr-x  1 staff  16399 Jan  1 00:01 smoke
-rw-r--r--  1 staff      4 Jan 10 08:23 t123
-rw-r--r--  1 staff     33 Jan 15 12:45 t123.md5
-rw-r--r--  1 staff    181 Jan 15 12:45 t123.smoke
-rw-r--r--  1 staff    129 Jan 15 12:45 t123.whirlpool
-rw-r--r--  1 staff      4 Jan 10 08:23 t456
-rw-r--r--  1 staff     33 Jan 15 12:45 t456.md5
-rw-r--r--  1 staff    181 Jan 15 12:45 t456.smoke
-rw-r--r--  1 staff    129 Jan 15 12:45 t456.whirlpool

$ head t???.*
==> t123.md5 <==
cfd12d74bca9357022eb7d8367bcab26

==> t123.smoke <==
whirlpool=e308efd94ab1810cfe44ea4b368f050b260ffc49c6f47a7ef8d58533a70e8e4bdfb0ff983f883ed2bc8dc08dad2e545e1cdf7da9ac4b400bd45bdf439a09fd0a;md5=cfd12d74bca9357022eb7d8367bcab26	t123

==> t123.whirlpool <==
e308efd94ab1810cfe44ea4b368f050b260ffc49c6f47a7ef8d58533a70e8e4bdfb0ff983f883ed2bc8dc08dad2e545e1cdf7da9ac4b400bd45bdf439a09fd0a

==> t456.md5 <==
1dbdd8f9093b0a0ea51f2a27a2b0b8b3

==> t456.smoke <==
whirlpool=5aa927dbaebfb0a1bdfe76eeee0863404647f2a491f45685111c21a4d83563bfb231befaf9f969f1ac175d4200baad20ee11e6ea5835b9b850a3859c19db0303;md5=1dbdd8f9093b0a0ea51f2a27a2b0b8b3	t456

==> t456.whirlpool <==
5aa927dbaebfb0a1bdfe76eeee0863404647f2a491f45685111c21a4d83563bfb231befaf9f969f1ac175d4200baad20ee11e6ea5835b9b850a3859c19db0303




# Kitchen Sick output 

$ ./smoke -O -a streebog512 -a ripemd160 --multiple-sums-digests --multiple-smokes --digest-per-file --smoke-file  t123 t456

$ ls -lg
total 288
-rw-r--r--  1 staff     92 Jan 15 12:52 RIPEMD160SUMS
-rw-r--r--  1 staff    394 Jan 15 12:52 SMOKESUMS
-rw-r--r--  1 staff    268 Jan 15 12:52 STREEBOG512SUMS
-rwxr-xr-x  1 staff  16399 Jan 15 12:26 smoke
-rw-r--r--  1 staff      4 Jan 10 08:23 t123
-rw-r--r--  1 staff     41 Jan 15 12:52 t123.ripemd160
-rw-r--r--  1 staff    197 Jan 15 12:52 t123.smoke
-rw-r--r--  1 staff    129 Jan 15 12:52 t123.streebog512
-rw-r--r--  1 staff      4 Jan 10 08:23 t456
-rw-r--r--  1 staff     41 Jan 15 12:52 t456.ripemd160
-rw-r--r--  1 staff    197 Jan 15 12:52 t456.smoke
-rw-r--r--  1 staff    129 Jan 15 12:52 t456.streebog512

$ head *SUMS t???.*
==> RIPEMD160SUMS <==
22150c08e4d0431bed36e60b0436c6078235c669	t123
ed80f0f02c441c6c408066885e1f114eaada6b9e	t456

==> SMOKESUMS <==
streebog512=f42f9820d136832079514096a7a538b037829308daa638a527c7d477bd67a07bc850fbafe47cd3ec2135b211691ba79bef442d1d41cb0f9fdee5ca69f482cc9f;ripemd160=22150c08e4d0431bed36e60b0436c6078235c669	t123
streebog512=d480fad9f4d36ec9102428d2183ad93d42b92c2db6be9f616d98ba3f175eb96d30bb7ec7abf19b2cbc40b69afcafc80f819cd80f7b2a8ba9f3900f8587023939;ripemd160=ed80f0f02c441c6c408066885e1f114eaada6b9e	t456

==> STREEBOG512SUMS <==
f42f9820d136832079514096a7a538b037829308daa638a527c7d477bd67a07bc850fbafe47cd3ec2135b211691ba79bef442d1d41cb0f9fdee5ca69f482cc9f	t123
d480fad9f4d36ec9102428d2183ad93d42b92c2db6be9f616d98ba3f175eb96d30bb7ec7abf19b2cbc40b69afcafc80f819cd80f7b2a8ba9f3900f8587023939	t456

==> t123.ripemd160 <==
22150c08e4d0431bed36e60b0436c6078235c669

==> t123.smoke <==
streebog512=f42f9820d136832079514096a7a538b037829308daa638a527c7d477bd67a07bc850fbafe47cd3ec2135b211691ba79bef442d1d41cb0f9fdee5ca69f482cc9f;ripemd160=22150c08e4d0431bed36e60b0436c6078235c669	t123

==> t123.streebog512 <==
f42f9820d136832079514096a7a538b037829308daa638a527c7d477bd67a07bc850fbafe47cd3ec2135b211691ba79bef442d1d41cb0f9fdee5ca69f482cc9f

==> t456.ripemd160 <==
ed80f0f02c441c6c408066885e1f114eaada6b9e

==> t456.smoke <==
streebog512=d480fad9f4d36ec9102428d2183ad93d42b92c2db6be9f616d98ba3f175eb96d30bb7ec7abf19b2cbc40b69afcafc80f819cd80f7b2a8ba9f3900f8587023939;ripemd160=ed80f0f02c441c6c408066885e1f114eaada6b9e	t456

==> t456.streebog512 <==
d480fad9f4d36ec9102428d2183ad93d42b92c2db6be9f616d98ba3f175eb96d30bb7ec7abf19b2cbc40b69afcafc80f819cd80f7b2a8ba9f3900f8587023939

```

# Algorithms

The algorithms supported will vary depending on your OS, version of Python, version of OpenSSL.  As a minimum, Smoke supports md5, sha1, and sha512.  To see the full list of algorithms on your system, do:

```shell
$ uname -a
Darwin evil-kitten 17.3.0 Darwin Kernel Version 17.3.0: Thu Nov  9 18:09:22 PST 2017; root:xnu-4570.31.3~1/RELEASE_X86_64 x86_64

$ ./smoke --show-algs
['dsa', 'dsaencryption', 'dsasha', 'dsawithsha', 'ecdsawithsha1', 'gost2814789mac', 'gostmac', 'gostr34.112012(256bit)', 'gostr34.1194', 'gostr34112012(512bit)', 'md4', 'md5', 'mdgost94', 'ripemd160', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512', 'streebog256', 'streebog512', 'whirlpool']
```

# Todo List

* Add generation of CRC32, et al as those are extremely useful.  It would simply be another algorithm. 
* Get ideas for the best "short flags" on the command line.  While `--multiple-sums-digests` is needed, maybe `-M` is better.  Think this out before creating them and getting these command line flags set in stone.
* The threading in Python is lazy - it could be made faster if threads were reused between files.
* Standardized API or bindings for languages.  There is a Python class, but it is probably very non-Python-like.  
* Add support to validate non-smoke checksum files, like MD5SUMS or filename.sha1.

# Entomology

Why name this Smoke?  The `hash` command on Unix was already taken.  Simply put, hashes are smoked.  A list of hashes is smoke stack.  Transmission of them is done via smoke signal.  I'm sure there are more puns to be had.

# Author

Jay is a NYC #infosec professional who goes by @veggiespam on [Twitter](https://twitter.com/veggiespam), [GitHub](https://github.com/veggiespam), [LinkedIn](https://www.linkedin.com/in/veggiespam), and other networks while occasionally writing articles on [Personal Site](https://veggiespam.com). 
