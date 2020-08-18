--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};

-- Called when this derma is first created.
function PANEL:Init()
    self:SetTall(64)

    self.drawColor = Color(25, 25, 25, 180)
end

-- Called when we need to attach a 'recipe' object onto this derma.
function PANEL:SetRecipe(recipe)
    self.profession = recipe

    local item = ix.item.list[recipe:GetFirstResult()]

    self.icon = self:Add("SpawnIcon")
    self.icon:InvalidateLayout(true)
	self.icon:Dock(LEFT)
	self.icon:DockMargin(2, 2, 2, 2)
	self.icon:SetModel(recipe:GetModel(), recipe:GetSkin())
	self.icon.PaintOver = function(this)
		if (item and item.PaintOver) then
			local w, h = this:GetSize()

			item.PaintOver(this, item, w, h)
		end
	end

	if ((item.iconCam and !ICON_RENDER_QUEUE[item.uniqueID]) or item.forceRender) then
		local iconCam = item.iconCam
		iconCam = {
			cam_pos = iconCam.pos,
			cam_fov = iconCam.fov,
			cam_ang = iconCam.ang,
		}
		ICON_RENDER_QUEUE[item.uniqueID] = true

		self.icon:RebuildSpawnIconEx(
			iconCam
		)
    end
    
    self.description = self:Add("DPanel")
    self.description:Dock(LEFT)
    self.description.Paint = function() end

	self.name = self.description:Add("DLabel")
	self.name:Dock(TOP)
    self.name:SetContentAlignment(4)
    self.name:DockMargin(4, 8, 0, 0)
	self.name:SetTextColor(color_white)
	self.name:SetFont("ixMenuButtonFontSmall")
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))
    self.name:SetText(recipe:GetName())

    self.requirements = self.description:Add("DLabel")
	self.requirements:Dock(TOP)
    self.requirements:SetContentAlignment(4)
    self.requirements:DockMargin(4, 0, 0, 0)
	self.requirements:SetTextColor(color_white)
	self.requirements:SetFont("ixMenuMiniFont")
    self.requirements:SetText(recipe:GetRequirements() or "Invalid requirements for this recipe.")

    local width = self.requirements:GetTextSize()

    if(self.name:GetTextSize() > width) then
        width = self.name:GetTextSize()
    end

    self.description:SetWide(width + 16)

    self.create = self:Add("ixNewButton")
    self.create:Dock(RIGHT)
    self.create:SetWide(64)
    self.create:SetFont("ixMenuMiniFont")
    self.create:SetText("Craft")
    self.create:DockMargin(4, 4, 4, 4)
end

-- Called when a player's cursor has entered the button.
function PANEL:OnCursorEntered()
    if(self:IsEnabled()) then
        LocalPlayer():EmitSound(unpack({"buttons/button15.wav", 35, 250}))
        self.drawColor = Color(40, 40, 40, 180)
    end
end

-- Called when a player's cursor has exited the button.
function PANEL:OnCursorExited()
    if(self:IsEnabled()) then
        self.drawColor = Color(25, 25, 25, 180)
    end
end

-- Called every frame
function PANEL:Paint()
    if(self:IsEnabled()) then
        surface.SetDrawColor(90, 90, 90, 120)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
        
        surface.SetDrawColor(self.drawColor)
    else
        surface.SetDrawColor(Color(25,25,25,80))
    end

    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixRecipePanel", PANEL, "DPanel")