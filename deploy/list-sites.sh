#!/bin/sh
cd ../orchestration/per-server/$1/sites
for i in *; do
  echo $i
done
