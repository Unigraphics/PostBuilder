// post_builder.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

#include <stdio.h>
#include <process.h>


int main(int argc, char* argv[])
{
	char str[256]=""; 
	int err;
	sprintf(str,"%%PB_HOME%%\\app\\Postino.exe \"%s\" %s \0", "!$%^(@*#&)","UG_POST_MILL");
	err=system(str);
	printf("%d=%s",err,str);
	return 0;
}

