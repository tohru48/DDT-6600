using System;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(236, "添加征婚信息")]
	public class MarryInfoAddHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.PlayerCharacter.MarryInfoID != 0)
			{
				return 1;
			}
			bool ısPublishEquip = packet.ReadBoolean();
			string ıntroduction = packet.ReadString();
			int ıD = client.Player.PlayerCharacter.ID;
			eMessageType type = eMessageType.Normal;
			string translateId = "MarryInfoAddHandler.Fail";
			int value = 10000;
			if (10000 > client.Player.PlayerCharacter.Gold)
			{
				type = eMessageType.ERROR;
				translateId = "MarryInfoAddHandler.Msg1";
			}
			else
			{
				MarryInfo marryInfo = new MarryInfo();
				marryInfo.UserID = ıD;
				marryInfo.IsPublishEquip = ısPublishEquip;
				marryInfo.Introduction = ıntroduction;
				marryInfo.RegistTime = DateTime.Now;
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				if (playerBussiness.AddMarryInfo(marryInfo))
				{
					client.Player.RemoveGold(value);
					translateId = "MarryInfoAddHandler.Msg2";
					client.Player.PlayerCharacter.MarryInfoID = marryInfo.ID;
					client.Out.SendMarryInfoRefresh(marryInfo, marryInfo.ID, isExist: true);
				}
			}
			client.Out.SendMessage(type, LanguageMgr.GetTranslation(translateId));
			return 0;
		}
	}
}
