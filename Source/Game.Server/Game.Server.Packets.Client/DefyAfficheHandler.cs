using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
	[PacketHandler(123, "场景用户离开")]
	public class DefyAfficheHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			packet.ReadBoolean();
			string str = packet.ReadString();
			int value = 200;
			if (client.Player.PlayerCharacter.Money >= 200)
			{
				client.Player.RemoveMoney(value);
				GSPacketIn gSPacketIn = new GSPacketIn(123);
				gSPacketIn.WriteString(str);
				GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
				client.Player.LastChatTime = DateTime.Now;
				GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				foreach (GamePlayer gamePlayer in allPlayers)
				{
					gSPacketIn.ClientID = gamePlayer.PlayerCharacter.ID;
					gamePlayer.Out.SendTCP(gSPacketIn);
				}
			}
			else
			{
				client.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("DefyAfficheHandler.Msg"));
			}
			return 0;
		}
	}
}
