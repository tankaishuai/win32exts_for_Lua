// C++ wrapper for LuaJIT header files.

extern "C" {
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "luajit.h"
}

int  lua_next_v3(lua_State *L, int idx, int cmp);
void lua_pop_v3(lua_State *L);
int  lua_objlen_v3(lua_State *L, int idx);

int  lua_next_key_index(lua_State *L);
int  lua_next_start(lua_State *L, int idx, int cmp);
void lua_next_pop(lua_State *L);
