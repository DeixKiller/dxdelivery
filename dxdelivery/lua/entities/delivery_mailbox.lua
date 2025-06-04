AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = DXDELIVERY_MAILBOX_NAME
ENT.Category = "DXDelivery"
ENT.Author = "Deix(Amanda)"
ENT.Contact = "STEAM_0:0:440963439"
ENT.Spawnable = true
ENT.Delay = 0

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_lab/partsbin01.mdl")
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS ) 
        self:SetSolid( SOLID_VPHYSICS ) 
        self:SetUseType( SIMPLE_USE )
    end
end


function ENT:AcceptInput(name,act,ply)
    if CurTime() < self.Delay then return end	
    self.Delay = CurTime() + 2.5
    dxdelivery(ply, self)

end 

