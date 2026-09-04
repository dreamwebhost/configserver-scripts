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

cp -avf Modules /etc/cmq/
cp -avf cmqversion.txt /etc/cmq/
/bin/rm -f /etc/cmq/downloadservers
cp -avf INSTALL.txt /etc/cmq/
cp -avf uninstall.sh /etc/cmq/
chmod 700 /etc/cmq/uninstall.sh

mkdir -p /usr/local/directadmin/plugins/cmq/
chmod 711 /usr/local/directadmin/plugins/cmq/
cp -avf da/* /usr/local/directadmin/plugins/cmq/
mkdir -p /usr/local/directadmin/plugins/cmq/images/
cp -avf cmq/* /usr/local/directadmin/plugins/cmq/images/

gcc -Wall -Wextra -Werror -o /usr/local/directadmin/plugins/cmq/exec/cmq cmq.c || exit 1
find /usr/local/directadmin/plugins/cmq/ -type d -exec chmod -v 755 {} \;
find /usr/local/directadmin/plugins/cmq/ -type f -exec chmod -v 644 {} \;
chown -Rv root:root /usr/local/directadmin/plugins/cmq
chmod -v 755 /usr/local/directadmin/plugins/cmq/admin/index.html
chmod -v 755 /usr/local/directadmin/plugins/cmq/admin/index.raw
chmod -v 755 /usr/local/directadmin/plugins/cmq/exec/da_cmq.cgi
chmod -v 755 /usr/local/directadmin/plugins/cmq/scripts/*
chown -v root:root /usr/local/directadmin/plugins/cmq/exec/cmq
chmod -v 4755 /usr/local/directadmin/plugins/cmq/exec/cmq

echo "ConfigServer Mail Queues has been installed."
exit
