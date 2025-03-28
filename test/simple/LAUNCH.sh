#!/bin/bash

echo "================"
../../src/LAUNCH echo foo  || echo expect-this

echo "================"
env TOP=../.. ../../src/LAUNCH echo foo

echo "================"
env TOP=../.. ../../src/LAUNCH -- ocamlfind camlp5-buildscripts/LAUNCH${EXE} -- echo bar

echo "================"
echo "DONE"
