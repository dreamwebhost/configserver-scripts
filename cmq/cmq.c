/*
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
*/
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <pwd.h>
#include <grp.h>

int main(void)
{
	FILE *adminFile;
	uid_t ruid;
	char name[100];
	struct passwd *pw;
	struct stat target_stat;
	int admin = 0;
	char *const argv[] = {"/usr/local/directadmin/plugins/cmq/exec/da_cmq.cgi", NULL};

	ruid = getuid();
	pw = getpwuid(ruid);
	if (pw == NULL)
	{
		fprintf(stderr, "Permission denied [UID:%u]\n", (unsigned int)ruid);
		return EXIT_FAILURE;
	}

	adminFile=fopen ("/usr/local/directadmin/data/admin/admin.list","r");
	if (adminFile!=NULL)
	{
		while(fgets(name,100,adminFile) != NULL)
		{
			int end = strlen(name) - 1;
			if (end >= 0 && name[end] == '\n') name[end] = '\0';
			//printf("Name [%s]\n", name);
			if (strcmp(pw->pw_name, name) == 0) admin = 1;
		}
		fclose(adminFile);
	}
	if (admin == 1)
	{
		if (lstat(argv[0], &target_stat) != 0 || !S_ISREG(target_stat.st_mode) ||
			target_stat.st_uid != 0 || (target_stat.st_mode & (S_IWGRP | S_IWOTH)) != 0)
		{
			fprintf(stderr, "Security error: unsafe CMQ executable\n");
			return EXIT_FAILURE;
		}

		if (setgroups(0, NULL) != 0 || setgid(0) != 0 || setuid(0) != 0)
		{
			perror("Unable to acquire root privileges");
			return EXIT_FAILURE;
		}

		unsetenv("PERL5LIB");
		unsetenv("PERL5OPT");
		unsetenv("PERLLIB");
		unsetenv("LD_PRELOAD");
		unsetenv("LD_LIBRARY_PATH");
		unsetenv("BASH_ENV");
		unsetenv("ENV");
		unsetenv("CDPATH");
		unsetenv("IFS");
		if (setenv("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", 1) != 0)
		{
			perror("Unable to set a safe PATH");
			return EXIT_FAILURE;
		}

		execv(argv[0], argv);
		perror("Unable to execute CMQ");
		return EXIT_FAILURE;
	} else {
		printf("Permission denied [User:%s UID:%u]\n", pw->pw_name, (unsigned int)ruid);
	}
	return EXIT_FAILURE;
}
