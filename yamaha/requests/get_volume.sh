#!/bin/bash

./send.sh getstatus | tail -n +5 - | xmllint --xpath "//Volume/Lvl/Val/text()" -
