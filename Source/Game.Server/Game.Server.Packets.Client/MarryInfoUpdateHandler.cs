using System;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	public class MarryInfoUpdateHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.PlayerCharacter.MarryInfoID == 0)
			{
				return 1;
			}
			bool ısPublishEquip = packet.ReadBoolean();
			string ıntroduction = packet.ReadString();
			int marryInfoID = client.Player.PlayerCharacter.MarryInfoID;
			string translateId = "MarryInfoUpdateHandler.Fail";
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				MarryInfo marryInfoSingle = playerBussiness.GetMarryInfoSingle(marryInfoID);
				if (marryInfoSingle == null)
				{
					translateId = "MarryInfoUpdateHandler.Msg1";
				}
				else
				{
					marryInfoSingle.IsPublishEquip = ısPublishEquip;
					marryInfoSingle.Introduction = ıntroduction;
					marryInfoSingle.RegistTime = DateTime.Now;
					if (playerBussiness.UpdateMarryInfo(marryInfoSingle))
					{
						translateId = "MarryInfoUpdateHandler.Succeed";
					}
				}
				client.Out.SendMarryInfoRefresh(marryInfoSingle, marryInfoID, marryInfoSingle != null);
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(translateId));
			}
			return 0;
		}
	}
}
