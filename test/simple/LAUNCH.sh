#!/bin/bash

echo "================"
../../src/LAUNCH echo foo  || echo expect-this

echo "================"
../../src/LAUNCH.PL echo foo  || echo expect-this-too

echo "================"
env TOP=../.. ../../src/LAUNCH echo foo

echo "================"
env TOP=../.. ../../src/LAUNCH.PL echo foo

echo "================"
env TOP=../.. ../../src/LAUNCH -- ocamlfind camlp5-buildscripts/LAUNCH${EXE} -- echo bar

echo "================"
env TOP=../.. ../../src/LAUNCH.PL ocamlfind camlp5-buildscripts/LAUNCH${EXE} echo bar2

echo "================"
BSDIR=`env TOP=../.. ../../src/LAUNCH.PL ocamlfind query camlp5-buildscripts`
env TOP=../.. ${BSDIR}/LAUNCH.PL echo bar3

echo "================"
env TOP=../.. ../../src/LAUNCH.PL ocamlfind camlp5-buildscripts/LAUNCH.PL echo bar4

echo "================"
echo "DONE"
