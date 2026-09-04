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

mkdir -p /etc/cmq
chmod 700 /etc/cmq

mkdir -p /usr/local/cpanel/whostmgr/docroot/cgi/configserver
chmod 700 /usr/local/cpanel/whostmgr/docroot/cgi/configserver
mkdir -p /usr/local/cpanel/whostmgr/docroot/cgi/configserver/cmq
chmod 700 /usr/local/cpanel/whostmgr/docroot/cgi/configserver/cmq

cp -avf cpanel/cmq.cgi /usr/local/cpanel/whostmgr/docroot/cgi/configserver/cmq.cgi
if [ -e "/usr/local/cpanel/3rdparty/bin/perl" ]; then
    sed -i '1s%^#\!/usr/bin/perl%#\!/usr/local/cpanel/3rdparty/bin/perl%' /usr/local/cpanel/whostmgr/docroot/cgi/configserver/cmq.cgi
fi
chmod -v 700 /usr/local/cpanel/whostmgr/docroot/cgi/configserver/cmq.cgi

cp -avf Modules /etc/cmq/
cp -avf cmqversion.txt /etc/cmq/
/bin/rm -f /etc/cmq/downloadservers
cp -avf INSTALL.txt /etc/cmq/
cp -avf uninstall.sh /etc/cmq/
chmod 700 /etc/cmq/uninstall.sh

cp -avf cmq/ /usr/local/cpanel/whostmgr/docroot/cgi/configserver/
cp -avf cpanel/cmq.conf /etc/cmq/cmq.conf
cp -avf upgrade.sh /etc/cmq/upgrade.sh
chmod 700 /etc/cmq/upgrade.sh
cp -af cmq/cmq.png /usr/local/cpanel/whostmgr/docroot/addon_plugins/
cp -af cpanel/cmq.tmpl /usr/local/cpanel/whostmgr/docroot/templates/

/usr/local/cpanel/bin/register_appconfig /etc/cmq/cmq.conf

/bin/rm -f /usr/local/cpanel/whostmgr/docroot/cgi/addon_cmq.cgi
/bin/rm -f /usr/local/cpanel/whostmgr/docroot/cgi/cmqversion.txt
/bin/rm -Rf /usr/local/cpanel/whostmgr/docroot/cgi/cmq

echo "ConfigServer Mail Queues has been installed."
exit
