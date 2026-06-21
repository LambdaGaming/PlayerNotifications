if SERVER then
	util.AddNetworkString( "OPGmanPlayerNotification" )
	hook.Add( "PlayerConnect", "OPGmanPlayerConnect", function( name, ip )
		net.Start( "OPGmanPlayerNotification" )
		net.WriteUInt( 1, 2 )
		net.WriteString( name )
		net.Broadcast()
	end )

	hook.Add( "PlayerInitialSpawn", "OPGmanPlayerSpawn", function( ply )
		local name = ply:Nick()
		local id = ply:SteamID()
		local tm = ply:Team()
		net.Start( "OPGmanPlayerNotification" )
		net.WriteUInt( 2, 2 )
		net.WriteString( name )
		net.WriteString( id )
		net.WriteUInt( 8, tm )
		net.Broadcast()
	end )

	hook.Add( "PlayerDisconnected", "OPGmanPlayerDisconnect", function( ply )
		local name = ply:Nick()
		local id = ply:SteamID()
		local tm = ply:Team()
		net.Start( "OPGmanPlayerNotification" )
		net.WriteUInt( 3, 2 )
		net.WriteString( name )
		net.WriteString( id )
		net.WriteUInt( 8, tm )
		net.Broadcast()
	end )
end

if CLIENT then
	local color_gray = Color( 165, 165, 165 )
	net.Receive( "OPGmanPlayerNotification", function()
		local notifyType = net.ReadUInt( 2 )
		local name = net.ReadString()
		local id = net.ReadString()
		local tm = net.ReadUInt( 8 )
		local ply = LocalPlayer()
		if !IsValid( ply ) then return end
		if notifyType == 1 then
			chat.AddText( color_gray, "[Server] ", color_white, name, " has connected to the server." )
		elseif notifyType == 2 then
			local color = team.GetColor( tm )
			local formatId = ply:IsAdmin() and " ("..id..") " or " "
			chat.AddText( color_gray, "[Server] ", color, name, color_gray, formatId, color_white, "has spawned in the server." )
		else
			local color = team.GetColor( tm )
			local formatId = ply:IsAdmin() and " ("..id..") " or " "
			chat.AddText( color_gray, "[Server] ", color, name, color_gray, formatId, color_white, "has left the server." )
		end
	end )

	hook.Add( "ChatText", "OPGmanChatText", function( index, name, text, type )
		if type == "joinleave" then return true end
	end )
end
