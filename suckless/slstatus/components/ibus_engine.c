#include <stdio.h>
#include <string.h>

#include "../util.h"

char *
get_engine(void)
{
	FILE *pf;
	char command[20];
	char data[512];
	char *engine;

	sprintf(command, "ibus engine");
	pf = popen(command, "r");
	fgets(data, 512, pf);

	data[strlen(data) - 1] = '\0';

	if (pclose(pf) != 0)
	{
		engine = (char *)bprintf("%s", "error");
	}
	else
	{
		engine = (char *)bprintf("%s", data);
	}

	return engine;
}

const char *
ibus_engine(void)
{
	char *engine;

	engine = get_engine();

	if(strcmp(engine, "xkb:us::eng") == 0)
	{
		return (char *)bprintf("%s", "en");
	}
	else if(strcmp(engine, "OpenBangla") == 0)
	{
		return (char *)bprintf("%s", "bn");
	}

	return engine;
}
