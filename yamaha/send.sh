#!/bin/bash

TEMPLATE=$1

cat ${TEMPLATE} | nc -w 2 10.20.30.50 80
