# REST glue for NWNX:EE Lua

**LICENSE:** MIT (see `LICENSE`)

## Description

This project adds a generalized REST client capability to NWNX:EE.  It supports TLS/SSL but is otherwise very basic.

## Limitations

Only JSON is supported for request and response bodies.  It currently lacks the ability to set headers and only supports request and response payloads that can fit into an NWN:EE LocalString.

## Module Preparation

**Method 1:** Add `'systems.restglue'` to the `scripts` table in `preload.lua` and in your *"on module load script"* include *"nwnx_lua"* and add this line `NWNX_Lua_RunEvent("mod_load", OBJECT_SELF);` (Step 6. from the NWNX:EE Lua Quick Start, Native instructions)

**Method 2:** In your *"on module load script"* include *"nwnx_lua"* and add this line `NWNX_Lua_EvalVoid("loadscript('systems.restglue')");` 
## Usage
```c++
#include "restcall_inc"

void doSomethingResty(object oPC) {
    json jBody = JsonObject();
    jBody = JsonObjectSet(jBody, "characterName", JsonString(GetName(oPC)));
    jBody = JsonObjectSet(jBody, "cdkey", JsonString(GetPCPublicCDKey(oPC)));
    jBody = JsonObjectSet(jBody, "arg1", JsonString("I am a value!"));

    struct JsonResponse jResp = RestCall("POST","https://example.com:3333/v1/example/8675309?askingFor=Jenny",jBody);

    if(jResp.code == -1) {
        // error making the connection
        SendMessageToPC(oPC,"REST call failed: "+jResp.error);
    } else {
        json jResults = jResp.response;

        // handle the results
    }
}
```
## Installation

You will need to enable NWNX:EE's Lua plugin and follow the installation instructions here: [NWNX:EE Lua](https://nwnxee.github.io/unified/group__lua.html) and then copy `lua/restglue.lua` to `<lua script dir>/systems/restglue.lua`

The `restglue.lua` script depends on `luasocket` and `luasec`.  I recommend installing those via [LuaRocks](https://luarocks.org/).

```sh
$ luarocks install luasocket
$ luarocks install luasec
```

**Note:** Both compile C code.  You'll need to complie those in an enviroment that's binary compatible with the one your server runs.

### Docker

Scripts have been included in the `scripts` directory to help initialize some volume mounts with the lua installation.  You'll run either `initlua.bat` for Windows hosts or `initlua.sh` for Linux hosts.  The `configurelua.sh` is run in the docker container.

You will need to add the volume mounts for `<hostpath>/lua/lib` and `<hostpath>/lua/share` to your *docker-compose.yml*.