	local VampzLib = require(game.ReplicatedStorage:WaitForChild("VampzLibModule"))

	local ui = VampzLib:CreateWindow({
		Title = "Painel do Vampz"
	})

	local main = ui:AddSection("Menu Principal")

	ui:AddButton(main, "Fazer Algo", function()
		print("Botão clicado!")
		ui:ShowNotification("Você clicou no botão!", Color3.fromRGB(0,255,0), 3)
	end)

	ui:AddToggle(main, "Ativar algo", false, function(state)
		print("Toggle:", state)
	end)

	ui:AddSlider(main, "Volume", 0, 100, 50, function(val)
		print("Volume:", val)
	end)

	ui:AddDropdown(main, "Escolher", {"Opção A", "Opção B", "Opção C"}, function(opt)
		print("Escolheu:", opt)
	end)
