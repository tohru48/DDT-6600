using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(71, "小喇叭")]
	public class SmallBugleHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			ItemInfo ıtemByTemplateID = client.Player.PropBag.GetItemByTemplateID(0, 11101);
			if (DateTime.Compare(client.Player.LastChatTime.AddSeconds(15.0), DateTime.Now) > 0)
			{
				client.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("SmallBugleHandler.Msg"));
				return 1;
			}
			if (ıtemByTemplateID != null)
			{
				client.Player.PropBag.RemoveCountFromStack(ıtemByTemplateID, 1);
				packet.ReadInt();
				packet.ReadString();
				string str = packet.ReadString();
				GSPacketIn gSPacketIn = new GSPacketIn(71);
				gSPacketIn.WriteInt(client.Player.PlayerCharacter.ID);
				gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
				gSPacketIn.WriteString(str);
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
				client.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("SmallBugleHandler.Msg"));
				client.Player.LastChatTime = DateTime.Now.AddDays(7.0);
			}
			return 0;
		}
	}
}
