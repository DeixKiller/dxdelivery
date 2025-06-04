//Conf

    DXDELIVERY_HUD_COLOR_FONT    = Color( 243, 252, 241)
    DXDELIVERY_HUD_COLOR_BG      = Color(17,151,145) 
    DXDELIVERY_HUD_COLOR_BORDER  = Color(40,46,45,194)
    DXDELIVERY_HUD_TEXT          = "Deliver the packet!"

    DXDELIVERY_NPC_COLOR_BG      = Color(17,151,145) 
    DXDELIVERY_NPC_COLOR_MAIN    = Color(40,46,45,194)
    DXDELIVERY_NPC_COLOR_FONT    = Color(255,244,244)
    DXDELIVERY_NPC_MODEL         = "models/Humans/Group02/Female_01.mdl" 

    DXDELIVERY_MODEL_VOICE       = "female" --Do you want the femenine or masculine voices? "female" or "male"
    DXDELIVERY_AWARD_MIN         = 2000
    DXDELIVERY_AWARD_MAX         = 3000
    DXDELIVERY_DELIVERY_TIME     = 80 --How much time the player has to deliver the packet

    DXDELIVERY_HALO_COLOR        = Color(255,0,0)
    DXDELIVERY_HALO_PASSES       = 2 //The higher is this number is the easy to see the mailbox thru walls, yet also decreases fps! max 3-6 before cracking low end pc in half

    DXDELIVERY_JOB               = "Delivery Guy" //Here should be the name of the job that you want it to be exclusive, ej "Delivery Guy" or "Hobo", etc Must be the same, else will not work
    //I already maked a job into the darkrp modules, so this one will come by default

//Lang
    DXDELIVERY_DARKRP_SYMBOL     = "$"
    DXDELIVERY_PACKET_NAME       = "Packet" //Weapon Name
    DXDELIVERY_PACKET_DESC       = "Deliver me!" //Weapon description

    DXDELIVERY_MAILBOX_NAME      = "Mailbox" 
    DXDELIVERY_NPC_NAME          = " Delivery"
    DXDELIVERY_NPC_NAME_SPACE    = 4 --Extra spacing for not fitting text


    DXDELIVERY_DELIVERY_TIMEOUT  = "Delivery failed, you ran out of time!"
    DXDELIVERY_DELIVERY_FAIL1    = "You already have something to deliver!"
    DXDELIVERY_DELIVERY_FAIL2    = "You arent the correct job for this!"
    DXDELIVERY_DELIVERY_FAIL3    = "Correct Job: "
    DXDELIVERY_DELIVERY_COMPLETE = "Delivery success! You have earned: "
    DXDELIVERY_DELIVERY_START    = {
        "I need you to deliver this for me.",
        "Might you make me a favor and deliver this, please?",
        "Where have you been? This packet is late!",
    }

dxdelivery_sounds = {
    "physics/cardboard/cardboard_box_break1.wav",
    "physics/cardboard/cardboard_box_break2.wav",
    "physics/wood/wood_box_impact_hard1.wav"
}   

dxdelivery_talk_fail = {
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01vquestion11.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/vquestion01.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/vquestion04.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/answer05.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/answer17.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/answer18.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/answer19.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/answer29.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/answer30.wav",
}

dxdelivery_talk = {
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/answer02.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/question06.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/question10.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/question16.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/question23.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/question25.wav",
    "vo/npc/" .. DXDELIVERY_MODEL_VOICE .. "01/question27.wav",
}





/* Do not touch anything after this unless you know what are you doing!
   You might break something, in that case probably i wouldnt be able to give you support!
*/ 
if CLIENT then
    surface.CreateFont("dxdelivery_font", {
    font = "Arial", 
    size = ScrH() * 0.025,
    weight = 500,
    antialias = true,
    })
end

function dxdelivery(ply, npc)
    if npc:GetClass() == "delivery_npc" and dxdelivery_mailcheck(ply) then
        if not ply:HasWeapon("weapon_delivery_packet") then
            ply:Give("weapon_delivery_packet")
            dxdelivery_mission_start(ply)
            ply:SendLua("dxdelivery_mission_start(ply)")
            ply:ChatPrint(DXDELIVERY_DELIVERY_START[math.random(1, #DXDELIVERY_DELIVERY_START)])
            npc:EmitSound(dxdelivery_talk[math.random(1, #dxdelivery_talk)])
        else
            ply:ChatPrint(DXDELIVERY_DELIVERY_FAIL1)
            npc:EmitSound(dxdelivery_talk_fail[math.random(1, #dxdelivery_talk_fail)])
        end
    elseif npc:GetClass() == "delivery_mailbox" and ply:GetNWEntity("mailbox") == npc then
        reward = math.random(DXDELIVERY_AWARD_MIN,DXDELIVERY_AWARD_MAX)
        if ply:HasWeapon("weapon_delivery_packet") then
            ply:StripWeapon("weapon_delivery_packet")
            dxdelivery_mission_end(ply)
                npc:EmitSound(dxdelivery_sounds[math.random(1, #dxdelivery_sounds)])
            ply:SendLua("dxdelivery_mission_end(ply)")
            ply:ChatPrint(DXDELIVERY_DELIVERY_COMPLETE .. reward .. DXDELIVERY_DARKRP_SYMBOL )
            ply:addMoney(reward)
        end    
    end
end

function dxdelivery_mailcheck(ply)
    local mailboxes = ents.FindByClass( "delivery_mailbox" )
    if #mailboxes < 1  then ply:ChatPrint("There aren't any mailbox placed!") return false 
    elseif team.GetName(ply:Team()) == DXDELIVERY_JOB then return true 
    else ply:ChatPrint(DXDELIVERY_DELIVERY_FAIL2) ply:ChatPrint(DXDELIVERY_DELIVERY_FAIL3 .. DXDELIVERY_JOB) end
end


function dxdelivery_mission_start(ply)
    if SERVER then
        local mailboxes = ents.FindByClass( "delivery_mailbox" )
        local deliverymail = mailboxes[math.random(1, #mailboxes)]
        ply:SetNWEntity("mailbox", deliverymail)
    end

    local time = DXDELIVERY_DELIVERY_TIME
    local minutes = math.floor(time/60)
    local seconds = time - (minutes * 60)
    local delay = 0

    
    if SERVER then 
        hook.Add("Think", "dxdelivery_timer" .. ply:Nick(), function ()
            if CurTime() < delay then return end
            delay = CurTime() + 1
            time = time - 1 
            minutes = math.floor(time/60)
            seconds = time - (minutes * 60)

            if time < 1 then 
                dxdelivery_mission_end(ply)
                ply:SendLua("dxdelivery_mission_end(ply)")
                ply:StripWeapon("weapon_delivery_packet")
                ply:ChatPrint(DXDELIVERY_DELIVERY_TIMEOUT)
            end
        end)
    end

    if CLIENT then
        hook.Add("Think", "dxdelivery_timer", function ()
            if CurTime() < delay then return end
            delay = CurTime() + 1
            time = time - 1 
            minutes = math.floor(time/60)
            seconds = time - (minutes * 60)
        end)

        hook.Add( "HUDPaint", "dxdelivery_timerhud", function()
            surface.SetFont( "dxdelivery_font" )
            surface.SetTextColor(DXDELIVERY_HUD_COLOR_FONT)
            surface.SetDrawColor(DXDELIVERY_HUD_COLOR_BG)
            surface.SetTextPos( ScrW() - ScrH() * 0.195,  ScrH() * 0.205) 

            surface.DrawRect( ScrW() - ScrH() * 0.2,  ScrH() * 0.2, ScrH() * 0.2, ScrH() * 0.06 )
            if seconds < 10 then
                surface.DrawText( minutes .. ":" .. "0".. seconds )
            else
                surface.DrawText( minutes .. ":" .. seconds )
            end
            surface.SetTextPos( ScrW() - ScrH() * 0.195,  ScrH() * 0.23) 
            surface.DrawText( DXDELIVERY_HUD_TEXT )
            surface.SetTextPos( ScrW() - ScrH() * 0.07,  ScrH() * 0.205) 
            surface.SetDrawColor(DXDELIVERY_HUD_COLOR_BORDER)
            surface.DrawOutlinedRect( ScrW() - ScrH() * 0.2,  ScrH() * 0.2, ScrH() * 0.2, ScrH() * 0.06, math.floor( math.sin( CurTime() * 2 ) * 2 ) + 5 )
            if IsValid(LocalPlayer():GetNWEntity("mailbox")) then
                surface.DrawText(math.floor(LocalPlayer():GetPos():Distance(LocalPlayer():GetNWEntity("mailbox"):GetPos())) .. "M" )
            end
        end)

        hook.Add( "PreDrawHalos", "dxdelivery_halos", function()
            halo.Add( {LocalPlayer():GetNWEntity("mailbox")}, DXDELIVERY_HALO_COLOR, 1, 1, 3, true, true )
        end )

    end
end


function dxdelivery_mission_end(ply)
    timer.Simple(0.2, function()
        if SERVER then hook.Remove( "Think", "dxdelivery_timer" .. ply:Nick()) end
    if CLIENT then hook.Remove( "PreDrawHalos", "dxdelivery_halos") hook.Remove( "HUDPaint", "dxdelivery_timerhud") hook.Remove( "Think", "dxdelivery_timer") end
    end)
end


/*  STEAM_0:0:440963439  	STEAM_0:0:440963439   STEAM_0:0:440963439 
MMMMMNKKXXNMMMMMMMMMMMMXo:lx0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMXxollodkOKNMWXNWMMMXd,';lx0XWMMMMMMMMMWNNWWNXK0O0NMMMMMMMMMMMMMMM
MMMMMMXdc:ccllodxxdOWMWWNKx,...';ldkO0Oxooxxlldxxoc::oKMMMMMMMMMMMMMMM
MMMMMMMOllooccodolldOOo:;,'...............':coxdc,,;cOWMMMMMMMMMMMMMMM
MMMMMMWOcl:::::;::;'''.... ... .........';cxkdc;',::xNMMMMMMMMMMMMMMMM
MMMMMMNd:c:ll;',;:,.....................,;:ll::;;;cccoOKXXXXXNMMMMMMMM
MMMMMM0lc::odc:oxc'......................;ol;cooc;;;'.;oONMMMMMWWNNWMM
MMMMMM0oxoccc:;;,....',''.................;ddl::c:,:;..',codollccd0WMM
MMMMMMNOkdlloc'......'''''.................,::,,;;;;'..'......;lkXWMMM
MMWXKXXKOxl;,.................'.......:;....'::,,'...........cOKXNWMMM
MMW0kxdol;'..........................,oo;.',',;'.............,:llodkOX
MMMMMMWW0:..........................'ldl:''col:'...............,:odk0N
MMMMMMMKc.......................  ..;oo:'...,:od;..............,l0WMMM
MMMMMMKc.;lc,.................... ':cl;......'::'...............':kNMM
MMMMMWkokOd;...............  .... 'cc:'.....',................;do:cOWM
MMMMMWN0dc,................. ......;cc'...''..................,xNNKXMM
WNX0xo:'............................,:'';;,....................c0MMMMM
0d:,...................,.............':oo:',,'.................'dNMMMM
WNX0Oko'..............'c;.....cxxl;,'.,ll:;:;'..................:kXNWM
MMMMMNd.....;oc........co:...:xO0Okkxocllcc:c;....................,:ld
MMMMWk;;lxOKNNo........,oxo,,okO0OOkkkkkxxxxo'...................',;;:
MMMW0ld0XWMMMNl......':clcc;;:lodkkkkkkkkkkkc....................;dKNW
MMMWKKNMMMMMM0:......;ol::::ccclloddxkkkkkko,.....................,l0W
MMMMMMMMMMMMMk;......,ccclloooodolloooxkkko,...................:do:,;k
MMMMMMMMMMMN0l.......'ll;,;l:.,;lodxoclxxl'....................,dXNKO0
MMMMMMMWNKko;.........ll'.'cc,..,okkkolo:'.......................,cldx
MMMMMXkoc;,'..........,c:;:clcccldxddlc:;'............................
MMMMMKdolc:'.............',:ldxxoc;,',,,............................;l
MMMMMNXXOl,..':l,............,:;....................................,:
MMMMMMMKo'.,lkKXl.........':::c;... ........................  .......,
MMMMMMMO::dO00xc'....... .ckko:,......................................
MMMMWX0xlllc;'.........  .'colc;.....................'................
WKkoc,................. ....,ldc,,;:;........''.....ll'...............
l;........................'...':ldxd:......':dl,,',oOo,...............
.........''...... ........''....,:;'.....',:dOdcc:lxxc'............... 
Made with love, you can support me if you liked this!
patreon.com/user?u=19847890 https://ko-fi.com/deixy 
*/ MsgC("DXDelivery Loaded!")
