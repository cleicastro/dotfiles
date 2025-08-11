#!/bin/bash
for dir in */
do
	if [ "$dir" = "var/" ]; then
        continue
    fi

	stow --adopt ${dir%/}; 
done
