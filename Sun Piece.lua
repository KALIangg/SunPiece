local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt"))()
local HttpService = game:GetService("HttpService")
local plr = game.Players.LocalPlayer

local win = DiscordLib:Window("🥷Hypex Revamp V3 - Sun Piece")
local MainS = win:Server("Sun Piece⚔️", "v2.0")

local MainTab = MainS:Channel("Main")
local SkillsTab = MainS:Channel("Skills / Abillity⚔️")
local AutoFarmTab = MainS:Channel("Missions📜")
local AdminTab = MainS:Channel("Admin🛡️")

------------------------------------
-- CONFIGS MAIN DO MENU
------------------------------------

MainTab:Seperator()
MainTab:Label("Creditos: Feito por GomesDev, vulgo Hypex.")

local function sendAnnounce(text, color, duration)
	local announces = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Announces")
	if not announces then return end

	local frame = announces:FindFirstChild("Frame")
	local template = announces:FindFirstChild("TextLabel")

	if not frame or not template then return end

	local msg = template:Clone()
	msg.Parent = frame
	msg.Visible = true
	msg.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	msg.Text = text
	wait(duration or 3)
	msg:Destroy()
end

sendAnnounce("💻 Bem vindo(a) ao painel Hypex Revamp! Seu script premium para <Sun Piece>.", Color3.fromRGB(255, 255, 255), 4)

MainTab:Seperator()

------------------------------------
-- NO COOLDOWN
------------------------------------

SkillsTab:Button("🔥 No Cooldown - Frutas & Espadas", function()
    local plr = game.Players.LocalPlayer
    local activeFruit = nil
    local activeSword = nil
    local keys = {"Z", "X", "C", "V"}

    -- Buscar fruta
    local fruitFolder = game:GetService("ReplicatedStorage"):WaitForChild("FruitSkills")
    local fruitNames = {}
    for _,f in pairs(fruitFolder:GetChildren()) do
        table.insert(fruitNames, f.Name)
    end

    for _,v in pairs(plr.Backpack:GetChildren()) do
        if table.find(fruitNames, v.Name) then
            activeFruit = v.Name
        end
    end

    for _,v in pairs(plr.Character:GetChildren()) do
        if table.find(fruitNames, v.Name) then
            activeFruit = v.Name
        end
    end

    -- Buscar espada
    local swordFolder = game:GetService("ReplicatedStorage"):WaitForChild("SwordSkills")
    local swordNames = {}
    for _,s in pairs(swordFolder:GetChildren()) do
        table.insert(swordNames, s.Name)
    end

    for _,v in pairs(plr.Backpack:GetChildren()) do
        if table.find(swordNames, v.Name) then
            activeSword = v.Name
        end
    end

    for _,v in pairs(plr.Character:GetChildren()) do
        if table.find(swordNames, v.Name) then
            activeSword = v.Name
        end
    end

    -- Aplicar NoCooldown na fruta detectada
    if activeFruit then
        local fruitSkills = fruitFolder:FindFirstChild(activeFruit)
        if fruitSkills then
            for _,k in pairs(keys) do
                local skill = fruitSkills:FindFirstChild(k)
                if skill and skill:FindFirstChild("Cooldown") then
                    skill.Cooldown.Value = 0
                end
            end
        end
    end

    -- Aplicar NoCooldown na espada detectada
    if activeSword then
        local swordSkills = swordFolder:FindFirstChild(activeSword)
        if swordSkills then
            for _,k in pairs(keys) do
                local skill = swordSkills:FindFirstChild(k)
                if skill and skill:FindFirstChild("Cooldown") then
                    skill.Cooldown.Value = 0
                end
            end
        end
    end

    DiscordLib:Notification("Notification - Sun Piece", "🔥 No Cooldown aplicado nas frutas e espadas!", "GG")
end)


SkillsTab:Button("🔥 Puxar Haki da Observação - Habilidades", function()
    local Ken = game:GetService("Players").LocalPlayer.values.Ken
    if not Ken then
        print('Something went wrong. - Error: Ken not found.')
        return
    end

    if Ken then
        print("ESP - Built In (Enabled)")
        Ken.Value = 1
        DiscordLib:Notification("Haki da Observação", "Puxado e spoofado com sucesso.", "GG!")
    end
end)


------------------------------------
-- CRASH SERVER FE SUPREME
------------------------------------
local crashFruit = "TenShadows"
local crashMode = "Normal"
local crashDelay = 0.1
local crashing = false
local crashConn

local fruitsAvailable = {}
for _,fruit in pairs(game.ReplicatedStorage.FruitSkills:GetChildren()) do
    table.insert(fruitsAvailable, fruit.Name)
end

AdminTab:Seperator()
AdminTab:Label("Crash Server [FE] Supreme 💀")

AdminTab:Dropdown("Selecionar Fruta:", fruitsAvailable, function(a) crashFruit = a end)
AdminTab:Dropdown("Modo Crash:", {"Normal","Global","RandomMap"}, function(a) crashMode = a end)
AdminTab:Slider("Delay entre skills:", 0.01, 0.5, 0.1, function(a) crashDelay = a end)

AdminTab:Button("Start Crash", function()
    if crashing then return end
    crashing = true
    local skillFolder = game.ReplicatedStorage.FruitSkills:FindFirstChild(crashFruit)
    if not skillFolder then return end
    local z = skillFolder:FindFirstChild("Z")
    if not z then return end


    crashConn = game:GetService("RunService").RenderStepped:Connect(function()
        if crashMode == "Normal" then
            z:FireServer(plr.Name)
        elseif crashMode == "Global" then
            for _,target in pairs(game.Players:GetPlayers()) do
                if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    z:FireServer(plr.Name, target.Character.HumanoidRootPart.Position)
                end
            end
        elseif crashMode == "RandomMap" then
            local rpos = plr.Character.HumanoidRootPart.Position + Vector3.new(math.random(-100,100),0,math.random(-100,100))
            z:FireServer(plr.Name, rpos)
        end
        task.wait(crashDelay)
    end)
end)

AdminTab:Button("Stop Crash", function()
    if crashing then
        crashing = false
        if crashConn then crashConn:Disconnect() end
        DiscordLib:Notification("Notification - Sun Piece", "Crash Parado!", "GG")
    end
end)


AdminTab:Seperator()
AdminTab:Label("Crash Supreme Mode 💀")

local supremeCrashing = false
local supremeConn

AdminTab:Button("Ativar Crash Supreme 💀", function()
    if supremeCrashing then
        DiscordLib:Notification("Notification - Sun Piece", "Crash Supreme já está ativo!", "Oops")
        return
    end


    if not crashFruit then
        DiscordLib:Notification("Notification - Sun Piece", "Selecione uma fruta primeiro!", "Oops")
        return
    end

    local skillFolder = game.ReplicatedStorage.FruitSkills:FindFirstChild(crashFruit)
    if not skillFolder then
        DiscordLib:Notification("Notification - Sun Piece", "Fruta não encontrada!", "Oops")
        return
    end

    local z = skillFolder:FindFirstChild("Z")
    if not z then
        DiscordLib:Notification("Notification - Sun Piece", "Skill Z não encontrada!", "Oops")
        return
    end

    if crashFruit == "Dragon" then
        z = skillFolder:FindFirstChild("C")
    end

    supremeCrashing = true
    DiscordLib:Notification("Notification - Sun Piece", "Modo Crash Supreme Ativado! 💀 CUIDADO!", "GG")

    supremeConn = game:GetService("RunService").RenderStepped:Connect(function()
        z:FireServer(plr.Name)
        task.wait(0.0001) -- PURE POWER
    end)
end)

AdminTab:Button("Parar Crash Supreme 🛑", function()
    if supremeCrashing then
        supremeCrashing = false
        if supremeConn then supremeConn:Disconnect() end
        DiscordLib:Notification("Notification - Sun Piece", "Crash Supreme Parado!", "GG")
    else
        DiscordLib:Notification("Notification - Sun Piece", "Nenhum Crash Supreme ativo!", "Oops")
    end
end)







------------------------------------
-- INVENTORY MANAGER SUPREME V3
------------------------------------

local InventoryTab = MainS:Channel("Inventory Manager 🧰")

InventoryTab:Seperator()
InventoryTab:Label("Auto Load Perfil 🗂️")

local autoLoadProfile = [[
{}
]]

if plr:FindFirstChild("values") then
    local loaded = HttpService:JSONDecode(autoLoadProfile)
    for name, value in pairs(loaded) do
        local v = plr.values:FindFirstChild(name)
        if v then
            v.Value = value
        end
    end
    sendAnnounce("💾 Save: todos seus itens foram carregados!", Color3.fromRGB(0, 255, 0), 4)
end

InventoryTab:Seperator()
InventoryTab:Label("Espadas 🔪")

for i = 1, 20 do
    InventoryTab:Button("Ativar Sword"..i, function()
        local v = plr.values:FindFirstChild("Sword"..i)
        if v then
            v.Value = 1
            local swordClone = game:GetService("ReplicatedStorage").Weapons:FindFirstChild("Sword"..i)
            if swordClone then
                swordClone:Clone().Parent = plr.Backpack
            end
        end
        DiscordLib:Notification("Notification - Sun Piece", "Sword"..i.." ativada e clonada!", "GG")
    end)
end

InventoryTab:Button("Ativar Todas Swords", function()
    for i = 1, 20 do
        local v = plr.values:FindFirstChild("Sword"..i)
        if v then
            v.Value = 1
            local swordClone = game:GetService("ReplicatedStorage").Weapons:FindFirstChild("Sword"..i)
            if swordClone then
                swordClone:Clone().Parent = plr.Backpack
            end
        end
    end
    DiscordLib:Notification("Notification - Sun Piece", "Todas Swords ativadas e clonadas!", "GG")
end)

InventoryTab:Seperator()
InventoryTab:Label("Acessórios 🎭")

for i = 1, 10 do
    InventoryTab:Button("Ativar Acc"..i, function()
        local v = plr.values:FindFirstChild("Acc"..i)
        if v then
            v.Value = 1
            local accClone = game:GetService("ReplicatedStorage").Accessories:FindFirstChild("Acc"..i)
            if accClone then
                accClone:Clone().Parent = plr.Backpack
            end
        end
        DiscordLib:Notification("Notification - Sun Piece", "Acc"..i.." ativado e clonado!", "GG")
    end)
end

InventoryTab:Button("Ativar Todos Accs", function()
    for i = 1, 10 do
        local v = plr.values:FindFirstChild("Acc"..i)
        if v then
            v.Value = 1
            local accClone = game:GetService("ReplicatedStorage").Accessories:FindFirstChild("Acc"..i)
            if accClone then
                accClone:Clone().Parent = plr.Backpack
            end
        end
    end
    DiscordLib:Notification("Notification - Sun Piece", "Todos Accs ativados e clonados!", "GG")
end)

InventoryTab:Seperator()
InventoryTab:Label("Gerenciamento Perfil 🗂️")

InventoryTab:Button("Salvar Perfil (Copy JSON)", function()
    local valuesFolder = plr:FindFirstChild("values")
    if valuesFolder then
        local data = {}
        for _,v in pairs(valuesFolder:GetChildren()) do
            data[v.Name] = v.Value
        end
        setclipboard(HttpService:JSONEncode(data))
        DiscordLib:Notification("Notification - Sun Piece", "Perfil Copiado!", "GG")
    end
end)

InventoryTab:Button("Carregar Perfil (Paste JSON)", function()
    local valuesFolder = plr:FindFirstChild("values")
    if valuesFolder then
        local input = DiscordLib:Prompt("Colar JSON do Perfil", "Insira seu JSON aqui:")
        if input then
            local loaded = HttpService:JSONDecode(input)
            for name, value in pairs(loaded) do
                local v = valuesFolder:FindFirstChild(name)
                if v then
                    v.Value = value
                end
            end
            DiscordLib:Notification("Notification - Sun Piece", "Perfil Carregado!", "GG")
        end
    end
end)

InventoryTab:Button("Visualizar Todos Values", function()
    local valuesFolder = plr:FindFirstChild("values")
    if valuesFolder then
        print("====== VALORES ATUAIS ======")
        for _,v in pairs(valuesFolder:GetChildren()) do
            print(v.Name.." = "..v.Value)
        end
        DiscordLib:Notification("Notification - Sun Piece", "Check console para lista!", "GG")
    end
end)



-------- fruits tab -------------

local farming = false
local CurrentLevel = game.Players.LocalPlayer.values.Level.Value
local selectedType = nil
local selectedEnemy = nil -- Mantido para compatibilidade futura
local selectedSkill = "Click"
local currentTarget = nil
local autofarmConnection

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

local function tweenToTarget(targetModel)
	local destinationPosition
	if targetModel:IsA("Model") then
		destinationPosition = targetModel.PrimaryPart and targetModel.PrimaryPart.Position
		if not destinationPosition and targetModel:FindFirstChild("HumanoidRootPart") then
			destinationPosition = targetModel.HumanoidRootPart.Position
		end
	elseif targetModel:IsA("BasePart") then
		destinationPosition = targetModel.Position
	end

	if not destinationPosition then
		warn("Destino inválido para tween!")
		return
	end

	local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local floatOffset = Vector3.new(0, 20, 0)
	local targetCFrame = CFrame.new(destinationPosition + floatOffset)

	local distance = (destinationPosition - root.Position).Magnitude
	local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

	local tween = ts:Create(root, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
end

local function aimAt(target)
	local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	local targetRoot = target:FindFirstChild("HumanoidRootPart")
	if root and targetRoot then
		root.CFrame = CFrame.new(root.Position, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))
	end
end

local function expandHitbox(model)
	local hrp = model:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Size = Vector3.new(60, 60, 60)
		hrp.CanCollide = false
		hrp.Transparency = (selectedSkill == "Click") and 0.5 or 1
	end
end

local function resetHitbox(model)
	local hrp = model:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Size = Vector3.new(2, 2, 1)
		hrp.Transparency = 1
	end
end

local function findValidTool(toolType)
	local sourceFolder = (toolType == "Fruits") and rs:FindFirstChild("Fruits") or rs:FindFirstChild("Swords")
	if not sourceFolder then return nil end

	local validNames = {}
	for _, v in pairs(sourceFolder:GetChildren()) do
		table.insert(validNames, v.Name)
	end

	for _, tool in pairs(plr.Backpack:GetChildren()) do
		if table.find(validNames, tool.Name) then
			return tool
		end
	end

	for _, tool in pairs(plr.Character:GetChildren()) do
		if table.find(validNames, tool.Name) then
			return tool
		end
	end

	return nil
end

local function getNextTarget()
	local list = {}
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart")
			and obj.Humanoid.Health > 0 then

			local npcLevel = tonumber(obj.Name:match("%[Lvl%s?(%d+)%]"))
			if npcLevel and npcLevel <= CurrentLevel and npcLevel + 10 >= CurrentLevel then
				table.insert(list, obj)
			end
		end
	end

	table.sort(list, function(a, b)
		local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return false end
		return (a.HumanoidRootPart.Position - hrp.Position).Magnitude < (b.HumanoidRootPart.Position - hrp.Position).Magnitude
	end)

	return list[1]
end

local function startFarm()
	farming = true
	currentTarget = nil

	autofarmConnection = runService.RenderStepped:Connect(function()
		if not selectedType then return end

		local tool = findValidTool(selectedType)
		if not tool then return end
		if tool.Parent ~= plr.Character then
			tool.Parent = plr.Character
		end

		if not currentTarget or not currentTarget:FindFirstChild("Humanoid") or currentTarget.Humanoid.Health <= 0 then
			currentTarget = getNextTarget()
		end

		if not currentTarget then return end

		expandHitbox(currentTarget)

		local hrp = currentTarget:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		aimAt(currentTarget)
		tweenToTarget(currentTarget)

		if selectedSkill == "Click" then
			tool:Activate()
		else
			local folder = (selectedType == "Fruits") and rs.FruitSkills or rs.SwordSkills
			local skillFolder = folder:FindFirstChild(tool.Name)
			if skillFolder then
				local skill = skillFolder:FindFirstChild(selectedSkill)
				if skill then
					skill:FireServer()
				end
			end
		end

		task.wait(2)
	end)
end

local function stopFarm()
	farming = false
	if autofarmConnection then
		autofarmConnection:Disconnect()
	end
	if currentTarget then
		resetHitbox(currentTarget)
	end
	currentTarget = nil
end

local allEnemies = {}
local function scanAllEnemies()
	allEnemies = {}
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name:match("%[Lvl%s?%d+%]") then
			table.insert(allEnemies, obj.Name)
		end
	end
end
scanAllEnemies()

AutoFarmTab:Seperator()
AutoFarmTab:Label("⚔️ Tipo de Ferramenta")
AutoFarmTab:Dropdown("Tipo de Ataque", {"Fruits", "Swords"}, function(opt)
	selectedType = opt
end)

AutoFarmTab:Label("🌀 Skill para usar")
AutoFarmTab:Dropdown("Skill", {"Click", "Z", "X", "C", "V"}, function(option)
	selectedSkill = option
end)

AutoFarmTab:Seperator()
AutoFarmTab:Toggle("Ativar AutoFarm", false, function(state)
	if state then
		startFarm()
	else
		stopFarm()
	end
end)




--------------------------------
-------    NPCS MENUS    -------
--------------------------------


local NPCGuiTab = MainS:Channel("📜 NPC Menus")

local plr = game.Players.LocalPlayer
local npcsFolder = plr:WaitForChild("PlayerGui"):WaitForChild("Npc's")

NPCGuiTab:Seperator()
NPCGuiTab:Label("🍇 Fruta / Perms")

NPCGuiTab:Toggle("FruitDealer 🍇", false, function(state)
	local gui = npcsFolder:FindFirstChild("FruitDealer")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("EatFruit 🍏", false, function(state)
	local gui = npcsFolder:FindFirstChild("EatFruit")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("UsePerm 🎁", false, function(state)
	local gui = npcsFolder:FindFirstChild("UsePerm")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Seperator()
NPCGuiTab:Label("🗡️ Espadas / Acessórios")

NPCGuiTab:Toggle("SwordDealer 🗡️", false, function(state)
	local gui = npcsFolder:FindFirstChild("SwordDealer")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("Accessories 🎭", false, function(state)
	local gui = npcsFolder:FindFirstChild("Accessories")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("AccDealer1 🎭", false, function(state)
	local gui = npcsFolder:FindFirstChild("AccDealer1")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("EmmaDealer 🗡️", false, function(state)
	local gui = npcsFolder:FindFirstChild("EmmaDealer")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("ArmorDealer1 🛡️", false, function(state)
	local gui = npcsFolder:FindFirstChild("ArmorDealer1")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("ArmorDealer2 🛡️", false, function(state)
	local gui = npcsFolder:FindFirstChild("ArmorDealer2")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("ArmorDealer3 🛡️", false, function(state)
	local gui = npcsFolder:FindFirstChild("ArmorDealer3")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Seperator()
NPCGuiTab:Label("🌌 Raças / Awakenings")

NPCGuiTab:Toggle("RaceAwakener 🌌", false, function(state)
	local gui = npcsFolder:FindFirstChild("RaceAwakener")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("RaceAwakenerV3 💠", false, function(state)
	local gui = npcsFolder:FindFirstChild("RaceAwakenerV3")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("DragonRaceDealer 🐲", false, function(state)
	local gui = npcsFolder:FindFirstChild("DragonRaceDealer")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("LeviathanRaceDealer 🌊", false, function(state)
	local gui = npcsFolder:FindFirstChild("LeviathanRaceDealer")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("SpinRace 🎡", false, function(state)
	local gui = npcsFolder:FindFirstChild("SpinRace")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Seperator()
NPCGuiTab:Label("⚔️ Haki / Estilos")

NPCGuiTab:Toggle("KenTeacher 👁️", false, function(state)
	local gui = npcsFolder:FindFirstChild("KenTeacher")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("DrachHaki 🐉", false, function(state)
	local gui = npcsFolder:FindFirstChild("DrachHaki")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("HakiColor 🌈", false, function(state)
	local gui = npcsFolder:FindFirstChild("HakiColor")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("MonkeyStyleDealer 🐒", false, function(state)
	local gui = npcsFolder:FindFirstChild("MonkeyStyleDealer")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("DarkStepDealer 👣", false, function(state)
	local gui = npcsFolder:FindFirstChild("DarkStepDealer")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("DragonTalonDealer 🔥", false, function(state)
	local gui = npcsFolder:FindFirstChild("DragonTalonDealer")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("ScientistCook 🍳", false, function(state)
	local gui = npcsFolder:FindFirstChild("ScientistCook")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Seperator()
NPCGuiTab:Label("🌀 Portais / Áreas / Exploração")

NPCGuiTab:Toggle("GetBackToFirst 🌍", false, function(state)
	local gui = npcsFolder:FindFirstChild("GetBackToFirst")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("GetBackToSecond 🌊", false, function(state)
	local gui = npcsFolder:FindFirstChild("GetBackToSecond")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("SecondSeaExpert 🌊", false, function(state)
	local gui = npcsFolder:FindFirstChild("SecondSeaExpert")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("ThirdSeaExpert 🌋", false, function(state)
	local gui = npcsFolder:FindFirstChild("ThirdSeaExpert")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("MirrorWorldDealer 🪞", false, function(state)
	local gui = npcsFolder:FindFirstChild("MirrorWorldDealer")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("IceDoor1 ❄️", false, function(state)
	local gui = npcsFolder:FindFirstChild("IceDoor1")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("Shenron 🐉", false, function(state)
	local gui = npcsFolder:FindFirstChild("Shenron")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("OkarunNPC 👻", false, function(state)
	local gui = npcsFolder:FindFirstChild("OkarunNPC")
	if gui then gui.Enabled = state end
end)

NPCGuiTab:Toggle("Snowman ☃️", false, function(state)
	local gui = npcsFolder:FindFirstChild("Snowman")
	if gui then gui.Enabled = state end
end)




----------------------------
------CMD-X SYSTEM--------
----------------------------
local TextChatService = game:GetService("TextChatService")
local plr = game.Players.LocalPlayer

local CmdTab = MainS:Channel("💻 CMD SYSTEM V2.5 [CORRIGIDO]")
CmdTab:Label("Use o chat novo ou caixa abaixo 👇")
CmdTab:Seperator()

-- FIXED: Textbox com string como placeholder
CmdTab:Textbox("Executar Comando", "Digite o comando aqui...", function(cmd)
	if commands[cmd] then
		pcall(commands[cmd])
	else
		DiscordLib:Notification("CMD System", "❌ Comando inválido ou não encontrado!", "Erro")
	end
end)

-- Lista de comandos
CmdTab:Label("📜 Comandos:")
CmdTab:Label("!g Ken, !g NoCooldown, !g AllSwords, !g AllAccs, /crash")

-- COMANDOS
local function crash()
	local fruit = nil
	for _,v in pairs(plr.Backpack:GetChildren()) do
		for _,f in pairs(game.ReplicatedStorage.Fruits:GetChildren()) do
			if v.Name == f.Name then
				fruit = f.Name
			end
		end
	end

	local skill = game.ReplicatedStorage.FruitSkills:FindFirstChild(fruit)
	if skill and skill:FindFirstChild("Z") then
		while true do
			skill.Z:FireServer(plr.Name)
			task.wait(0.001)
		end
	end
end


local function resetserver()
	local fruit2 = nil
	for _,v2 in pairs(plr.Backpack:GetChildren()) do
		for _,f2 in pairs(game.ReplicatedStorage.Fruits:GetChildren()) do
			if v2.Name == f2.Name then
				fruit2 = f2.Name
			end
		end
	end

	local skill2 = game.ReplicatedStorage.FruitSkills:FindFirstChild(fruit2)
	if skill2 and skill:FindFirstChild("Z") then
		while true do
			skill2.Z:FireServer(plr.Name)
			task.wait(0.0000001)
		end
	end
end





local function giveKen()
	local ken = plr:FindFirstChild("values") and plr.values:FindFirstChild("Ken")
	if ken then
		ken.Value = 1
	else
		DiscordLib:Notification("CMD", "❌ Ken não encontrado!", "ERRO")
	end
end

local function noCooldown()
	local fruit = nil
	for _,v in pairs(plr.Backpack:GetChildren()) do
		for _,f in pairs(game.ReplicatedStorage.Fruits:GetChildren()) do
			if v.Name == f.Name then fruit = f.Name end
		end
	end
	if not fruit then
		for _,v in pairs(plr.Character:GetChildren()) do
			for _,f in pairs(game.ReplicatedStorage.Fruits:GetChildren()) do
				if v.Name == f.Name then fruit = f.Name end
			end
		end
	end
	local skillFolder = game.ReplicatedStorage.FruitSkills:FindFirstChild(fruit)
	local keys = {"Z", "X", "C", "V"}
	if skillFolder then
		for _,k in pairs(keys) do
			local s = skillFolder:FindFirstChild(k)
			if s and s:FindFirstChild("Cooldown") then
				s.Cooldown.Value = 0
			end
		end
	end

	for _,sword in pairs(plr.Backpack:GetChildren()) do
		local skill = game.ReplicatedStorage.SwordSkills:FindFirstChild(sword.Name)
		if skill then
			for _,k in pairs(keys) do
				local s = skill:FindFirstChild(k)
				if s and s:FindFirstChild("Cooldown") then
					s.Cooldown.Value = 0
				end
			end
		end
	end
end

local function allSwords()
	for _,v in pairs(plr.values:GetChildren()) do
		if v.Name:match("^Sword%d+") then
			v.Value = 1
		end
	end
end

local function allAccs()
	for _,v in pairs(plr.values:GetChildren()) do
		if v.Name:match("^Acc%d+") then
			v.Value = 1
		end
	end
end


local function FruitNotifier()
	for _, fruit in pairs(game.ReplicatedStorage.Fruits:GetChildren()) do
		local fruitdrop = fruit.Name
		local fruitInWorld = workspace:FindFirstChild(fruitdrop .."Fruit")
		if fruitInWorld then
			sendAnnounce("🍈 [Notificador de Fruta]: Uma fruta foi dropada! Fruta: "..fruitdrop, Color3.fromRGB(0, 255, 0), 2)

			-- Highlight
			local highlight = Instance.new("Highlight")
			highlight.Name = "FruitHighlight"
			highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
			highlight.FillColor = Color3.fromRGB(226, 0, 0)
			highlight.FillTransparency = 0.3
			highlight.OutlineTransparency = 0
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.Parent = fruitInWorld

			-- BillboardGui
			local billboard = Instance.new("BillboardGui")
			billboard.AlwaysOnTop = true
			billboard.Size = UDim2.new(0, 150, 0, 20)
			billboard.MaxDistance = math.huge
			billboard.Adornee = fruitInWorld:FindFirstChild("Head") or fruitInWorld.PrimaryPart
			billboard.Parent = fruitInWorld

			-- TextLabel
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 1, 0)
			label.Position = UDim2.new(0, 0, 0, 0)
			label.BackgroundTransparency = 1
			label.TextScaled = true
			label.TextSize = 14
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			label.TextStrokeTransparency = 0.5
			label.Text = fruit.Name
			label.Parent = billboard
		end
	end
end


-- CMD Dictionary
commands = {
	["/crash"] = crash,
    ["!rs"] = resetserver,
	["!g Ken"] = giveKen,
	["!g NoCooldown"] = noCooldown,
	["!g AllSwords"] = allSwords,
	["!g AllAccs"] = allAccs,
	["!notifier"] = FruitNotifier,
}

-- Novo Chat 🔥
TextChatService.OnIncomingMessage = function(msg)
	local content = msg.Text
	if commands[content] then
		pcall(commands[content])
	end
end
