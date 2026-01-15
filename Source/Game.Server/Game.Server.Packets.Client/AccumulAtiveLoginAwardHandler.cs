using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(238, "撤消征婚信息")]
	public class AccumulAtiveLoginAwardHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int ıD = packet.ReadInt();
			GSPacketIn gSPacketIn = new GSPacketIn(238, client.Player.PlayerCharacter.ID);
			string translation = LanguageMgr.GetTranslation("AccumulAtiveLoginAward.Fail");
			if (client.Player.PlayerCharacter.accumulativeAwardDays < client.Player.PlayerCharacter.accumulativeLoginDays)
			{
				for (int i = client.Player.PlayerCharacter.accumulativeAwardDays; i < client.Player.PlayerCharacter.accumulativeLoginDays; i++)
				{
					int num = i + 1;
					List<ItemInfo> list = new List<ItemInfo>();
					list = ((num < 7) ? AccumulActiveLoginMgr.GetAllAccumulAtiveLoginAward(num) : AccumulActiveLoginMgr.GetSelecedAccumulAtiveLoginAward(ıD));
					if (list.Count > 0)
					{
						translation = LanguageMgr.GetTranslation("AccumulAtiveLoginAward.Success", num);
						WorldEventMgr.SendItemsToMail(list, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, translation);
						client.Player.PlayerCharacter.accumulativeAwardDays++;
					}
					else
					{
						client.Player.SendMessage(translation);
					}
				}
			}
			gSPacketIn.WriteInt(client.Player.PlayerCharacter.accumulativeLoginDays);
			gSPacketIn.WriteInt(client.Player.PlayerCharacter.accumulativeAwardDays);
			client.Player.SendTCP(gSPacketIn);
			return 0;
		}
	}
}
