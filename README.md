# Loot chests by Edazpotato

[Video](https://youtu.be/G2LA07Z1tI0)

Datapack compiled using [mc-build](https://github.com/mc-build/mc-build)

## How to download

Go to the releases tab, select the latest relase and click on the zip file. DO NOT click where it says source code.

## Usage

### Trigger commands

Trigger commands will create something in the block the executor is standing in, or will modify a loot chest very close to the executor.

> These commands are only available in creative mode.

-   `/trigger new_loot_chest_s` Creates a new loot chest source.
-   `/trigger del_loot_chest_s` Removes a loot chest source.
-   `/trigger new_loot_chest` Creates a new loot chest.
-   `/trigger del_loot_chest` Removes a loot chest.
-   `/trigger loot_chest_type set <number>` Sets a loot chest source's type or a loot chest's type to the specified number. Any number above `0` can be used. Loot chest sources and loot chests have a type of `1` by default.
-   `/trigger fill_loot_chests [set <number>]` Refills the loot in all of the loot chests of that type. The type can be omitted to target loot chests of type `1`.

### Other functions

> These commands can only be used by operators.

-   `/function loot_chests:get_chest_type` Outputs the current type of a loot chest.
-   `/function loot_chests:uninstall` Removes all scoreboards and deletes all loot chests.
-   `/scoreboard players set @r fill_loot_chests <number>` Refills the loot in all of the loot chests of the type specified. Performs the same function as `/trigger fill_loot_chests`, but can be used inside command blocks or functions.
