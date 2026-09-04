#!/bin/sh
###############################################################################
# Copyright (C) 2006-2025 Jonathan Michaelson
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses>.
###############################################################################
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH
umask 077

if [ "$(id -u)" -ne 0 ]; then
	echo "This installer must be run as root"
	exit 1
fi

if [ -e "/usr/local/cpanel/version" ]; then
	echo "Running cmq cPanel installer"
	echo
	sh install.cpanel.sh
elif [ -e "/usr/local/directadmin/directadmin" ]; then
	echo "Running cmq DirectAdmin installer"
	echo
	sh install.directadmin.sh
else
	echo "No supported control panel installation was found"
	exit 1
fi
