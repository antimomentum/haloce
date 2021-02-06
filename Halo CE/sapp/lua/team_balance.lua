-- Team balancer v2.1 by 002
-- Configuration

-- Player switched message
-- Variables: $PLAYER for the player, $TEAM for destination team
PLAYER_SWITCHED = "$PLAYER switched to the $TEAM team"

-- Teams are unbalanced message
-- Variables: $TEAM_SMALL = the name of the smaller team. $TEAM_BIG = the name of the bigger team.
TEAMS_ARE_UNBALANCED_A = "Teams are unbalanced!"
TEAMS_ARE_UNBALANCED_B = "The next to die on $TEAM_BIG team will be switched."

-- Number of seconds for the teams to be unbalanced to display message A.
TEAMS_ARE_UNBALANCED_A_DELAY = 5

-- Number of seconds for the teams to be unbalanced to display message B. Players will switch teams on death after this message.
TEAMS_ARE_UNBALANCED_B_DELAY = 5

-- Betrayals will also trigger switches.
SWITCH_FOR_BETRAYALS = false


-- End of configuration

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'],"OnTick")
    register_callback(cb['EVENT_TEAM_SWITCH'],"OnTeamSwitch")
    register_callback(cb['EVENT_DIE'],"OnPlayerDie")
    register_callback(cb['EVENT_PRESPAWN'],"OnPlayerSpawn")
end

function OnScriptUnload()

end

delay = nil
warning_a_shown = false
warning_b_shown = false

killed_by_nothing = {}

function SwitchPlayerIfPossible(PlayerIndex)
    local red = tonumber(get_var(1,"$reds"))
    local blue = tonumber(get_var(1,"$blues"))
    local bigger_team = nil
    local smaller_team = nil
    if(red > blue + 1) then
        bigger_team = "red"
        smaller_team = "blue"
    elseif(blue > red + 1) then
        bigger_team = "blue"
        smaller_team = "red"
    end
    execute_command("st " .. PlayerIndex .. " " .. smaller_team)
end

function OnTick()
    if(get_var(1,"$ffa") == "1") then return end
    local red = tonumber(get_var(1,"$reds"))
    local blue = tonumber(get_var(1,"$blues"))
    local bigger_team = nil
    local smaller_team = nil
    if(red > blue + 1) then
        bigger_team = "red"
        smaller_team = "blue"
    elseif(blue > red + 1) then
        bigger_team = "blue"
        smaller_team = "red"
    else
        delay = nil
        warning_a_shown = false
        warning_b_shown = false
        return
    end
    local time = os.clock()
    if(delay == nil) then delay = os.clock() + TEAMS_ARE_UNBALANCED_A_DELAY end
    if(os.clock() > delay and warning_a_shown == false) then
        say_all(string.gsub(string.gsub(TEAMS_ARE_UNBALANCED_A,"$TEAM_BIG",bigger_team),"$TEAM_SMALL",smaller_team))
        warning_a_shown = true
        delay = os.clock() + TEAMS_ARE_UNBALANCED_B_DELAY
    elseif(os.clock() > delay and warning_b_shown == false) then
        say_all(string.gsub(string.gsub(TEAMS_ARE_UNBALANCED_B,"$TEAM_BIG",bigger_team),"$TEAM_SMALL",smaller_team))
        warning_b_shown = true
    end
end

function OnTeamSwitch(PlayerIndex)
    if(killed_by_nothing[PlayerIndex] == true) then
        execute_command("deaths " .. PlayerIndex .. " -1")
        write_dword(get_player(PlayerIndex) + 0x2C, 0)
        killed_by_nothing[PlayerIndex] = nil
    end
    say_all(string.gsub(string.gsub(PLAYER_SWITCHED,"$TEAM",get_var(PlayerIndex,"$team")),"$PLAYER",get_var(PlayerIndex,"$name")))
end

function OnPlayerSpawn(PlayerIndex)
    killed_by_nothing[PlayerIndex] = nil
end

function OnPlayerDie(PlayerIndex, MeansOfDeath)
    if(SWITCH_FOR_BETRAYALS == false and tonumber(MeansOfDeath) > 0) then
        if(get_var(MeansOfDeath,"$team") == get_var(PlayerIndex,"$team")) then return end
    end
    if(tonumber(MeansOfDeath) == -1 and warning_a_shown) then
        killed_by_nothing[PlayerIndex] = true
    end
    if(warning_b_shown == false) then return end
    local red = tonumber(get_var(1,"$reds"))
    local blue = tonumber(get_var(1,"$blues"))
    local bigger_team = nil
    local smaller_team = nil
    if(red > blue + 1) then
        bigger_team = "red"
        smaller_team = "blue"
    elseif(blue > red + 1) then
        bigger_team = "blue"
        smaller_team = "red"
    else
        return
    end
    if(get_var(PlayerIndex,"$team") == bigger_team) then
        timer(1000,"SwitchPlayerIfPossible",PlayerIndex)
    end
end