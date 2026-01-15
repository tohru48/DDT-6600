using System;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(73, "大喇叭")]
	public class CBugleHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int clientId = packet.ReadInt();
			ItemInfo ıtemByTemplateID = client.Player.PropBag.GetItemByTemplateID(0, 11100);
			if (DateTime.Compare(client.Player.LastChatTime.AddSeconds(30.0), DateTime.Now) > 0)
			{
				client.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("CBugleHandler.Msg"));
				return 1;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(73, clientId);
			if (ıtemByTemplateID != null)
			{
				packet.ReadString();
				string str = packet.ReadString();
				client.Player.PropBag.RemoveCountFromStack(ıtemByTemplateID, 1);
				gSPacketIn.WriteInt(client.Player.ZoneId);
				gSPacketIn.WriteInt(client.Player.PlayerCharacter.ID);
				gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
				gSPacketIn.WriteString(str);
				gSPacketIn.WriteString(client.Player.ZoneName);
				if (GameServer.Instance.LoginCrossServer != null)
				{
					GameServer.Instance.LoginCrossServer.SendPacket(gSPacketIn);
					client.Player.LastChatTime = DateTime.Now;
				}
			}
			else
			{
				client.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("CBugleHandler.Msg"));
				client.Player.LastChatTime = DateTime.Now.AddDays(7.0);
			}
			return 0;
		}
	}
}
