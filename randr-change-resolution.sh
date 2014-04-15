#!/bin/sh

echo "xrandr:"
xrandr

display=$(xrandr | grep connected | awk '{ print $1 }')
echo "Display: $display"

modeLine=$(cvt $1 $2 | awk 'match($0, /Modeline (\"(.*)\".*)/, matches) { print matches[1] }')
echo "Mode line: $modeLine"

modeLinePieces=()
argIndex=0
for arg in $(echo $modeLine | grep -Po "\S+")
do
  modeLinePieces[$((argIndex++))]=$arg
done

nameWithQuotes=${modeLinePieces[0]}
name=${nameWithQuotes//\"/}
echo "name: $name"

clock=${modeLinePieces[1]}
echo "clock MHz: $clock"

hDisp=${modeLinePieces[2]}
echo "hdisp: $hDisp"

hSyncStart=${modeLinePieces[3]}
echo "hsync-start: $hSyncStart"

hSyncEnd=${modeLinePieces[4]}
echo "hsync-end: $hSyncEnd"

hTotal=${modeLinePieces[5]}
echo "htotal: $hTotal"

vDisp=${modeLinePieces[6]}
echo "vdisp: $vDisp"

vSyncStart=${modeLinePieces[7]}
echo "vsync-start: $vSyncStart"

vSyncEnd=${modeLinePieces[8]}
echo "vsync-end: $vSyncEnd"

vTotal=${modeLinePieces[9]}
echo "vtotal: $vTotal"

hSync=${modeLinePieces[10]}
echo "hSync: $hSync"

vSync=${modeLinePieces[11]}
echo "vSync: $vSync"

echo "Cleanup modes if it already exists"
xrandr --delmode $display $name
xrandr --rmmode $name

echo "Create mode"
xrandr --newmode $name $clock $hDisp $hSyncStart $hSyncEnd $hTotal $vDisp $vSyncStart $vSyncEnd $vTotal $hSync $vSync
xrandr --addmode $display $name

echo "Set display output"
xrandr --output $display --mode $name

