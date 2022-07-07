#!/bin/sh

mkdir CLEANUP
mv * CLEANUP/
mv CLEANUP/packages/next-app/out/* .
rm -rf CLEANUP