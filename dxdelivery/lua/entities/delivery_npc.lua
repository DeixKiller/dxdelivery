AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = DXDELIVERY_NPC_NAME
ENT.Category = "DXDelivery"
ENT.Author = "Deix(Amanda)"
ENT.Contact = "STEAM_0:0:440963439"
ENT.Spawnable = true
ENT.Delay = 0

if SERVER then
    function ENT:Initialize()
        self:SetModel(DXDELIVERY_NPC_MODEL)
        self:SetHullType( HULL_HUMAN )
        self:SetHullSizeNormal( )
        self:SetNPCState( NPC_STATE_SCRIPT )
        self:SetSolid( SOLID_BBOX )
        self:CapabilitiesAdd( CAP_ANIMATEDFACE )
        self:CapabilitiesAdd( CAP_TURN_HEAD )
        self:SetUseType( SIMPLE_USE )
        timer.Simple(0.2, function() self:SetSequence("idle_all_01") end)
    end
end


function ENT:AcceptInput(name,act,ply)
    if CurTime() < self.Delay then return end	
    self.Delay = CurTime() + 1.5
    dxdelivery(ply, self)
end 





if not CLIENT then return end

surface.CreateFont( "deixtrashfont", {
	font = "Tahoma",
	size = 23,
} )

function ENT:Draw()
    for p, ply in ipairs(player.GetAll()) do
        if(ply:EyePos():Distance(self:EyePos()) <= 200) then
            self:SetEyeTarget(ply:EyePos())
            break
        else
            self:SetEyeTarget(self:LocalToWorld(Vector(20,0,60)))
        end
    end
    self:DrawModel()

    local ang = self:GetAngles()    
    ang:RotateAroundAxis( self:GetUp(), 90 )
    ang:RotateAroundAxis( self:GetRight(), -90 + 0 )
    ang:RotateAroundAxis( self:GetForward(), 0)

    ang.y = LocalPlayer():EyeAngles().y + -90

    local pos = self:GetPos()
    pos = pos + self:GetForward() * 0
    pos = pos + self:GetRight() * 0
    pos = pos + self:GetUp() * 78

    local resolution = 0.3

    cam.Start3D2D( pos, ang, 0.05 / resolution )
        //Your word doenst fit? play arround with this values to fix it
        //                                                    Like this one
        draw.RoundedBox(8,-50,-1,string.len(DXDELIVERY_NPC_NAME) * 10 + DXDELIVERY_NPC_NAME_SPACE ,31,DXDELIVERY_NPC_COLOR_BG )
        draw.RoundedBox(8,-47.5,1.5,(string.len(DXDELIVERY_NPC_NAME) * 10 + DXDELIVERY_NPC_NAME_SPACE) * 0.93,25, DXDELIVERY_NPC_COLOR_MAIN )

        draw.SimpleText( DXDELIVERY_NPC_NAME, "deixtrashfont", -42, 2, DXDELIVERY_NPC_COLOR_FONT )
    cam.End3D2D()
end


