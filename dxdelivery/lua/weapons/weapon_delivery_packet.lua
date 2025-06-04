AddCSLuaFile()

SWEP.PrintName = DXDELIVERY_PACKET_NAME
SWEP.Contact = "STEAM_0:0:440963439"
SWEP.Instructions = DXDELIVERY_PACKET_DESC
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = ""
SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.Weight			= 0
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self:SetHoldType("normal")
    self:SetMaterial("Models/effects/vol_light001")
end

if CLIENT then
    local boxModel = "models/props_junk/cardboard_box003a_gib01.mdl"
    function SWEP:PostDrawViewModel(vm, weapon, ply)
        if not IsValid(self.BoxVM) then
            self.BoxVM = ClientsideModel("models/props_junk/cardboard_box003a_gib01.mdl", RENDERGROUP_VIEWMODEL)
            self.BoxVM:SetNoDraw(true)
            self.BoxVM:SetModelScale(0.7, 0)
        end


        local attach = vm:GetAttachment(1)
        if not attach then return end

        local pos = attach.Pos
        local ang = attach.Ang
        pos = pos + ang:Forward() * -2 - ang:Up() * 5
        self.BoxVM:SetPos(pos)
        self.BoxVM:SetAngles(ang + Angle(0,0,-90))
        self.BoxVM:DrawModel()
    end

    function SWEP:Holster()
        if IsValid(self.BoxVM) then
            self.BoxVM:Remove()
        end
            LocalPlayer():GetViewModel():SetMaterial("")
        return true
    end

    function SWEP:OnRemove()
        if IsValid(self.BoxVM) then
            self.BoxVM:Remove()
        end
        LocalPlayer():GetViewModel():SetMaterial("")
    end

    function SWEP:Deploy()
        LocalPlayer():GetViewModel():SetMaterial("Models/effects/vol_light001")
        timer.Simple(0.1, function ()
            LocalPlayer():GetViewModel():SetMaterial("Models/effects/vol_light001")    
        end)
    end
end




