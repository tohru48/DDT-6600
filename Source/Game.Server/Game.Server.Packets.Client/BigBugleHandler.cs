using System;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(72, "大喇叭")]
	public class BigBugleHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			ItemInfo ıtemByTemplateID = client.Player.PropBag.GetItemByTemplateID(0, num);
			if (DateTime.Compare(client.Player.LastChatTime.AddSeconds(15.0), DateTime.Now) > 0)
			{
				client.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("BigBugleHandler.Msg"));
				return 1;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(72);
			if (ıtemByTemplateID != null && num == 11102)
			{
				packet.ReadInt();
				packet.ReadString();
				string str = packet.ReadString();
				client.Player.PropBag.RemoveCountFromStack(ıtemByTemplateID, 1);
				gSPacketIn.WriteInt(ıtemByTemplateID.Template.Property2);
				gSPacketIn.WriteInt(client.Player.PlayerCharacter.ID);
				gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
				gSPacketIn.WriteString(str);
				GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
				client.Player.LastChatTime = DateTime.Now;
			}
			else
			{
				client.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("BigBugleHandler.Msg"));
				client.Player.LastChatTime = DateTime.Now.AddDays(7.0);
			}
			return 0;
		}
	}
}
