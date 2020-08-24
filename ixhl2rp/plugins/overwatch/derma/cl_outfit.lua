--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}
local PLUGIN = PLUGIN

function PANEL:Init()
    local parent = self
    
    self.updateButton = self:Add("ixNewButton")
    self.updateButton:Dock(BOTTOM)
    self.updateButton:DockMargin(2,2,2,2)
    self.updateButton:SetText("Update Model")

    self.character = LocalPlayer():GetCharacter()

	self:SetSize(600, 400)
    
    self.leftDock = self:Add("DPanel")
    self.leftDock:Dock(LEFT)
    self.leftDock:SetWide(256)

    self.model = self.leftDock:Add("ixModelPanel")
    self.model:Dock(FILL)
    self.model:SetFOV(45)

    self.rightDock = self:Add("DScrollPanel")
    self.rightDock:Dock(FILL)

    local buttons = {}

    for k, v in pairs(PLUGIN.config.otaTypes) do
        local button = self.rightDock:Add("ixNewButton")
        button.model = v.model
        button:Dock(TOP)
        button:SetHeight(64)
        button:DockMargin(2,2,2,2)
        button.selected = false
        button:SetText(v.name)
        button:SetHelixTooltip(function(tooltip)
            local name = tooltip:AddRow("description")
            name:SetText(v.name)
            name:SetFont("ixPluginTooltipDescFont")
            name:SizeToContents()

            local description = tooltip:AddRow("description")
            description:SetText(v.description)
            description:SetFont("ixPluginTooltipDescFont")
            description:SizeToContents()
        end)

        function button:DoClick()    
            for k, v in pairs(buttons) do
                v.selected = false
            end

            parent.selectedModel = self.model
            parent.model:SetModel(self.model)

            self.selected = true
        end

        function button:PaintOver()
            if(self.selected) then
                surface.SetDrawColor(255, 255, 255, 25)
                surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
            end
        end

        table.insert(buttons, button)
    end
    
    function self.updateButton:DoClick()        
        if(parent.selectedModel) then
            net.Start("ixUpdateOverwatchModel")
                net.WriteString(parent.selectedModel, 32)
            net.SendToServer()
        end

        if(IsValid(ix.gui.menu)) then
            ix.gui.menu:Remove()
        end
    end
end

-- Basically a fix to remove the janky model staying on the screen when the menu is closing
function PANEL:Think()
    if(ix.gui.menu and ix.gui.menu.bClosing) then
        self.model:Remove()
    end
end

vgui.Register("ixOutfitMenu", PANEL, "DPanel")

-- Called when all of the tabs are being created.
hook.Add("CreateMenuButtons", "ixOutfitMenu", function(tabs)
    if(LocalPlayer():GetCharacter():GetFaction() == FACTION_OTA) then
        tabs["outfit"] = {
            Create = function(info, container)				
                ix.gui.outfitMenu = container:Add("ixOutfitMenu")
            end,
        }	
    end
end)