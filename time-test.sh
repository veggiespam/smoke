#!/bin/sh

# Run with:    ./time-test.sh > outname.txt  2>&1

# Then ...
#  Parsing ... grep real speed-test-* | perl -p -e 's/ +/\t/g' > xls.txt
#  Parsing ... grep real 25GB-* | perl -p -e 's/ +/\t/g' > xls.txt
#  Parsing ... grep maximum 25GB-* | cut -c12-21

#  Copy into xls for averages

# You need to set this to what you use.  These are installers provided
# by a client for testing.
big_file="$HOME/z-No-Backup/Big-File-1.7z"   ; #  4.2 GB
big_file="$HOME/z-No-Backup/Big-File-2.7z"   ; # 24.0 GB

test_file=$big_file
#test_file=t123

# Time Command
tc="/usr/bin/time -l"
#tc=time

# These are the OS X versions of the hashing commands with the assumption the
# Homebrew GNU utils are installed using the "g" prefix, update for your
# situations.  Also, update accordingly for Linux.

$tc md5 -r $test_file
echo
$tc shasum -b $test_file
echo
$tc shasum -b -a 512 $test_file
echo
$tc gmd5sum -b $test_file
echo
$tc gsha1sum -b $test_file
echo
$tc gsha512sum -b $test_file
echo
$tc ./smoke.py $test_file




# Use these to produce 5 runs.
if [ 0 == 1 ]; then

for i in  1 2 3 4 5  ; do
	echo $i
	./time-test.sh > 24GB-$i.txt  2>&1
done

fi

