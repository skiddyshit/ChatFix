if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(1)

local Players = game:GetService("Players")

local CoreGui = game:GetService("CoreGui")
local ExperienceChat = CoreGui:WaitForChild("ExperienceChat")
local appLayout = ExperienceChat:WaitForChild("appLayout")
local InputBar = appLayout:WaitForChild("chatInputBar")
local bottomBorder = appLayout:WaitForChild("bottomBorder")

getgenv().ChatFix = {}

local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

local internalData = {
    Visible = InputBar.Visible,
    Connection = nil
}

local function exitLogic()
    if internalData.Connection then
        internalData.Connection:Disconnect()
        internalData.Connection = nil
    end

    setmetatable(getgenv().ChatFix, nil) 
    table.clear(getgenv().ChatFix)

    print("ChatFix: Logic stopped and cleaned up.")
end

local ChatFix_MT = {
    __newindex = function(self, key, value)
        if key == "Visible" then
            internalData.Visible = value
            InputBar.Visible = value
        else
            rawset(self, key, value)
        end
    end,
    __index = function(self, key)
        if key == "Visible" then
            return InputBar.Visible
        elseif key == "Exit" then
            return exitLogic
        end
        return rawget(self, key)
    end
}

setmetatable(getgenv().ChatFix, ChatFix_MT)

local function syncVisibility()
    getgenv().ChatFix.Visible = bottomBorder.Visible
end

internalData.Connection = bottomBorder:GetPropertyChangedSignal("Visible"):Connect(syncVisibility)

syncVisibility()

print("ChatFix initialized. Use ChatFix:Exit() to stop.")

local TeleportCheck = false -- infinite yield queueteleport

Players.LocalPlayer.OnTeleport:Connect(function(State)
	if (not TeleportCheck) and queueteleport then
		TeleportCheck = true
		queueteleport("loadstring(game:HttpGet'https://raw.githubusercontent.com/skiddyshit/ChatFix')()")
	end
end)
