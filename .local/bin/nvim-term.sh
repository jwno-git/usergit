#!/bin/bash
terminator -x bash -c "nvim \"$1\"; exec bash"

