#!/bin/bash
for dir in */
do
	stow --adopt ${dir%/}; 
done
