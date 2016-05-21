#include <luajit-2.0/luajit.h>
#include <luajit-2.0/lauxlib.h>
#include <luajit-2.0/lualib.h>

#define mydo(L,what,result) \
    do { \
        result = luaL_dofile(L, what); \
        if (result) \
            if (lua_isstring(L, -1)) \
                fprintf(stderr, "%s\n", lua_tostring(L, -1)); \
    } while (0)

int do_a_thing(const char *thingly)
{
    puts(thingly);
}

int main()
{
    int result = 0;

    lua_State *L = luaL_newstate();
	if (!L) {
		fprintf(stderr, "Failed to allocate Lua state\n");
		return -1;
	}
    luaL_openlibs(L);

    mydo(L,"main.lua",result);
    luaL_dostring(L, "ffi = require \"ffi\"");
    mydo(L,"ffi.lua",result);

    lua_close(L);

    return result;
}

/* vi:set ts=4 sw=4 et syntax=c.doxygen: */
