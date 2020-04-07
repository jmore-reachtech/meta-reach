# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

alias ls='ls -FC --color=auto'

alias pc0='picocom -b 115200 /dev/ttyUSB0'
alias pc1='picocom -b 115200 /dev/ttyUSB1'
alias pc2='picocom -b 115200 /dev/ttyUSB2'
alias pc3='picocom -b 115200 /dev/ttyUSB3'
