using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
	[PacketHandler(70, "邀请")]
	public class GameInviteHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.CurrentRoom == null)
			{
				return 0;
			}
			int playerId = packet.ReadInt();
			GamePlayer playerById = WorldMgr.GetPlayerById(playerId);
			if (playerById == client.Player)
			{
				return 0;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(70, client.Player.PlayerCharacter.ID);
			List<GamePlayer> players = client.Player.CurrentRoom.GetPlayers();
			foreach (GamePlayer item in players)
			{
				if (item == playerById)
				{
					client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("friendnotinthesameserver.Sameroom"));
					return 0;
				}
			}
			if (playerById != null && playerById.CurrentRoom == null)
			{
				gSPacketIn.WriteInt(client.Player.PlayerCharacter.ID);
				gSPacketIn.WriteInt(client.Player.CurrentRoom.RoomId);
				gSPacketIn.WriteInt(client.Player.CurrentRoom.MapId);
				gSPacketIn.WriteByte(client.Player.CurrentRoom.TimeMode);
				gSPacketIn.WriteByte((byte)client.Player.CurrentRoom.RoomType);
				gSPacketIn.WriteByte((byte)client.Player.CurrentRoom.HardLevel);
				gSPacketIn.WriteByte((byte)client.Player.CurrentRoom.LevelLimits);
				gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
				gSPacketIn.WriteByte(client.Player.PlayerCharacter.typeVIP);
				gSPacketIn.WriteInt(client.Player.PlayerCharacter.VIPLevel);
				gSPacketIn.WriteString(client.Player.CurrentRoom.Name);
				gSPacketIn.WriteString(client.Player.CurrentRoom.Password);
				gSPacketIn.WriteInt(client.Player.CurrentRoom.barrierNum);
				gSPacketIn.WriteBoolean(client.Player.CurrentRoom.isOpenBoss);
				playerById.Out.SendTCP(gSPacketIn);
			}
			else if (playerById != null && playerById.CurrentRoom != null && playerById.CurrentRoom != client.Player.CurrentRoom)
			{
				client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("friendnotinthesameserver.Room"));
			}
			else
			{
				client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("friendnotinthesameserver.Fail"));
			}
			return 0;
		}
	}
}
