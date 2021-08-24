dir z_internals {
    function say_no_loot_chests_found {
        tellraw @s [{"text": "!! ", "color": "red"}, {"text": "No loot chests found within a block.", "color": "gray"}]
    }

    function create_physical_loot_chest_block_at_current_location {
        setblock ~ ~ ~ minecraft:chest{CustomName:'{"text":"Loot Chest","color":"gold"}'}
    }
    function create_physical_loot_chest_source_block_at_current_location {
        setblock ~ ~ ~ minecraft:chest{CustomName:'{"text":"Loot Chest source","color":"aqua"}'}
    }
}

function load {
    scoreboard objectives add LOOT_CHESTS_INT dummy "Loot Chests Internals"
    scoreboard objectives add loot_chest_type trigger
    scoreboard objectives add _loot_chest_type dummy
    scoreboard objectives add fill_loot_chests trigger

    scoreboard objectives add new_loot_chest trigger
    scoreboard objectives add del_loot_chest trigger
    scoreboard objectives add new_loot_chest_s trigger
    scoreboard objectives add del_loot_chest_s trigger

    tellraw @a[gamemode=creative] [{"text": "Loot chests", "color": "aqua", "clickEvent": {"action": "open_url", "value": "https://github.com/edazpotato/loot-chests-datapack"}}, {"text": " by ", "color": "gray"}, {"text": "Edazpotato", "color": "dark_red", "clickEvent": {"action": "open_url", "value": "https://edaz.codes"}}, {"text": " successfully loaded.", "color": "gray"}]

    execute (if entity @e[tag=loot_chest, type=minecraft:armor_stand]) {
        tellraw @a[gamemode=creative] "It seems like you still have an old version of Loot Chests installed. Please run /function <%config.namespace%>:uninstall and then /reload to upgrade."
    }
    execute (if entity @e[tag=loot_chest_source, type=minecraft:armor_stand]) {
        tellraw @a[gamemode=creative] "It seems like you still have an old version of Loot Chests installed. Please run /function <%config.namespace%>:uninstall and then /reload to upgrade."
    }
}


function uninstall {
    scoreboard objectives remove LOOT_CHESTS_INT
    scoreboard objectives remove loot_chest_type
    scoreboard objectives remove _loot_chest_type
    scoreboard objectives remove fill_loot_chests

    scoreboard objectives remove new_loot_chest
    scoreboard objectives remove del_loot_chest
    scoreboard objectives remove new_loot_chest_s
    scoreboard objectives remove del_loot_chest_s
    
    execute at @e[tag=loot_chest] run function <%config.namespace%>:remove_loot_chest
    execute at @e[tag=loot_chest_source] run function <%config.namespace%>:remove_loot_chest_source

    tellraw @a[gamemode=creative] [{"text": "Loot chests", "color": "aqua", "clickEvent": {"action": "open_url", "value": "https://github.com/edazpotato/loot-chests-datapack"}}, {"text": " has been successfully uninstalled. You can now safely delete the datapack files.", "color": "gray"}]
}

function get_chest_type {
    execute (at @e[tag=loot_chest, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest]) {
        tellraw @s [{"text": "Loot chest type is ", "color": "gray"}, {"score":{"name":"@e[tag=loot_chest, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest]","objective":"_loot_chest_type"}, "color": "aqua"}, {"text":".", "color": "gray"}]
    } else execute (at @e[tag=loot_chest_source, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest]) {
        tellraw @s [{"text": "Loot chest source type is ", "color": "gray"}, {"score":{"name":"@e[tag=loot_chest_source, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest]","objective":"_loot_chest_type"}, "color": "aqua"}, {"text":".", "color": "gray"}]
    }
}

function create_loot_chest {
    execute (unless entity @e[tag=loot_chest, type=minecraft:marker, distance=..1.2]) {
        execute align xyz positioned ~0.5 ~0.5 ~0.5 run summon marker ~ ~ ~ {NoGravity:1b,Invulnerable:1b,Tags:["loot_chest"]}
        execute (as @e[tag=loot_chest, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest] at @s) {
            scoreboard players set @s _loot_chest_type 1
            function <%config.namespace%>:z_internals/create_physical_loot_chest_block_at_current_location
        }
        tellraw @s [{"text": "Created loot chest. Run ", "color": "gray"}, {"text": "/trigger loot_chest_type set ", "color": "white"}, {"text":"X","color": "aqua"}, {"text": " to set the loot chest source type.", "color": "gray"}]
    } else {
        tellraw @s [{"text": "!! ", "color": "red"}, {"text": "There is already a loot chest within a block.", "color": "gray"}]
    }
}

function remove_loot_chest {
    execute (if entity @e[tag=loot_chest, type=minecraft:marker, distance=..1.2]) {
        execute (as @e[tag=loot_chest, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest] at @s) {
            setblock ~ ~ ~ air
            kill @s
            tellraw @p {"text": "Successfully removed loot chest.", "color": "gray"}
        }
    } else {
        function <%config.namespace%>:z_internals/say_no_loot_chests_found
    }
}

function create_loot_chest_source {
    execute (unless entity @e[tag=loot_chest_source, type=minecraft:marker, distance=..1.2]) {
        execute align xyz positioned ~0.5 ~ ~0.5 run summon marker ~ ~ ~ {NoGravity:1b,Invulnerable:1b,Tags:["loot_chest_source"]}
        execute (as @e[tag=loot_chest_source, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest] at @s) {
            scoreboard players set @s _loot_chest_type 1
            function <%config.namespace%>:z_internals/create_physical_loot_chest_source_block_at_current_location
        }
        tellraw @s [{"text": "Created loot chest source. Run ", "color": "gray"}, {"text": "/trigger loot_chest_type set ", "color": "white"}, {"text":"X","color": "aqua"},{"text": " to set the loot chest source type.", "color": "gray"}]
    } else {
        tellraw @s [{"text": "!! ", "color": "red"}, {"text": "There is already a loot source chest within a block.", "color": "gray"}]
    }
}

function remove_loot_chest_source {
    execute (if entity @e[tag=loot_chest_source,type=minecraft:marker, distance=..1.2]) {
        execute (as @e[tag=loot_chest_source, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest] at @s) {
            setblock ~ ~ ~ air
            kill @s
            tellraw @p {"text": "Successfully removed loot chest source.", "color": "gray"}
        }
    } else {
        function <%config.namespace%>:z_internals/say_no_loot_chests_found
    }
}

function tick {
    scoreboard players enable @a[gamemode=creative] loot_chest_type
    scoreboard players reset @a[gamemode=!creative] loot_chest_type
    scoreboard players enable @a[gamemode=creative] fill_loot_chests
    scoreboard players reset @a[gamemode=!creative] fill_loot_chests

    scoreboard players enable @a[gamemode=creative] new_loot_chest
    scoreboard players reset @a[gamemode=!creative] new_loot_chest
    scoreboard players enable @a[gamemode=creative] del_loot_chest
    scoreboard players reset @a[gamemode=!creative] del_loot_chest
    scoreboard players enable @a[gamemode=creative] new_loot_chest_s
    scoreboard players reset @a[gamemode=!creative] new_loot_chest_s
    scoreboard players enable @a[gamemode=creative] del_loot_chest_s
    scoreboard players reset @a[gamemode=!creative] del_loot_chest_s

    execute (as @a[scores={new_loot_chest=1..}] at @s) {
        function <%config.namespace%>:create_loot_chest
        scoreboard players set @s new_loot_chest 0
    }
    execute (as @a[scores={del_loot_chest=1..}] at @s) {
        function <%config.namespace%>:remove_loot_chest
        scoreboard players set @s del_loot_chest 0
    }
    execute (as @a[scores={new_loot_chest_s=1..}] at @s) {
        function <%config.namespace%>:create_loot_chest_source
        scoreboard players set @s new_loot_chest_s 0
    }
    execute (as @a[scores={del_loot_chest_s=1..}] at @s) {
        function <%config.namespace%>:remove_loot_chest_source
        scoreboard players set @s del_loot_chest_s 0
    }

    execute (as @a[scores={loot_chest_type=1..}] at @s) {
        
        execute (if entity @e[tag=loot_chest, type=minecraft:marker, distance=..1.2] at @e[tag=loot_chest, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest]) {
            execute unless block ~ ~ ~ #<%config.namespace%>:chest run function <%config.namespace%>:z_internals/create_physical_loot_chest_block_at_current_location
            execute store result score @e[tag=loot_chest, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest] _loot_chest_type run scoreboard players get @s loot_chest_type
            tellraw @s [{"text": "Set loot chest type to ", "color": "gray"}, {"score":{"name":"@s","objective":"loot_chest_type"}, "color": "aqua"}, {"text":".", "color": "gray"}]
        } else execute (if entity @e[tag=loot_chest_source,type=minecraft:marker, distance=..1.2] at @e[tag=loot_chest_source, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest]) {
            execute unless block ~ ~ ~ #<%config.namespace%>:chest run function <%config.namespace%>:z_internals/create_physical_loot_chest_source_block_at_current_location
            execute store result score @e[tag=loot_chest_source, type=minecraft:marker, distance=..1.2, limit=1, sort=nearest] _loot_chest_type run scoreboard players get @s loot_chest_type
            tellraw @s [{"text": "Set loot chest source type to ", "color": "gray"}, {"score":{"name":"@s","objective":"loot_chest_type"}, "color": "aqua"}, {"text":".", "color": "gray"}]
        } else {
            function <%config.namespace%>:z_internals/say_no_loot_chests_found
        }
        
        scoreboard players set @s loot_chest_type 0
    }

    execute (as @a[scores={fill_loot_chests=1..}]) {
        execute store result score __filling_loot_chest_type LOOT_CHESTS_INT run scoreboard players get @s fill_loot_chests

        execute (as @e[tag=loot_chest, type=minecraft:marker] if score @s _loot_chest_type = __filling_loot_chest_type LOOT_CHESTS_INT) {
            execute (at @e[tag=loot_chest_source, type=minecraft:marker, sort=random] if score @e[tag=loot_chest_source, type=minecraft:marker, limit=1, sort=nearest] _loot_chest_type = __filling_loot_chest_type LOOT_CHESTS_INT) {
                data modify storage <%config.namespace%>:loot_chests_temp items set from block ~ ~ ~ Items
                execute at @s run data modify block ~ ~ ~ Items set from storage <%config.namespace%>:loot_chests_temp items
            }
        }

        scoreboard players set @s fill_loot_chests 0
    }
}
