#!/bin/sh

# ---- TEMPLATE ----

# Hook for modifcation stuff right after
#          piratebox/bin/install  ... part2 
# is run.

if [ !  -f $1 ] ; then
  echo "Config-File $1 not found..."
  exit 255
fi

#Load config
. $1

# You can uncommend this line to see when hook is starting:
echo "------------------ Running $0 ------------------"

echo "Switching hostname to the.wrong.lan"
/opt/piratebox/bin/install_piratebox.sh hostname $(hostname)


