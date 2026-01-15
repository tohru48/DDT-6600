using System.Collections.Generic;
using System.Linq;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(152, "场景用户离开")]
	public class FightFootballTimeTakeoutHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadByte();
			client.Player.Card = method_0();
			GSPacketIn gSPacketIn = new GSPacketIn(152, client.Player.PlayerCharacter.ID);
			if (num < 9 && num >= 0 && client.Player.takeoutCount > 0)
			{
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(client.Player.Card[num].templateID);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(client.Player.Card[num].count);
				client.Player.TakeFootballCard(client.Player.Card[num]);
			}
			else
			{
				client.Player.ShowAllFootballCard();
				gSPacketIn.WriteInt(2);
				gSPacketIn.WriteInt(client.Player.canTakeOut);
				CardsTakeOutInfo[] cardsTakeOut = client.Player.CardsTakeOut;
				foreach (CardsTakeOutInfo cardsTakeOutInfo in cardsTakeOut)
				{
					if (cardsTakeOutInfo.IsTake)
					{
						gSPacketIn.WriteInt(cardsTakeOutInfo.templateID);
						gSPacketIn.WriteInt(cardsTakeOutInfo.place);
						gSPacketIn.WriteInt(cardsTakeOutInfo.count);
					}
				}
				gSPacketIn.WriteInt(client.Player.Card.Count - client.Player.canTakeOut);
				CardsTakeOutInfo[] cardsTakeOut2 = client.Player.CardsTakeOut;
				foreach (CardsTakeOutInfo cardsTakeOutInfo2 in cardsTakeOut2)
				{
					if (!cardsTakeOutInfo2.IsTake)
					{
						gSPacketIn.WriteInt(cardsTakeOutInfo2.templateID);
						gSPacketIn.WriteInt(cardsTakeOutInfo2.place);
						gSPacketIn.WriteInt(cardsTakeOutInfo2.count);
					}
				}
				client.Player.RemoveFightFootballStyle();
			}
			client.Out.SendTCP(gSPacketIn);
			return 0;
		}

		private Dictionary<int, CardsTakeOutInfo> method_0()
		{
			Dictionary<int, CardsTakeOutInfo> dictionary = new Dictionary<int, CardsTakeOutInfo>();
			Dictionary<int, CardsTakeOutInfo> dictionary2 = new Dictionary<int, CardsTakeOutInfo>();
			int num = 0;
			int num2 = 0;
			while (dictionary.Count < 9)
			{
				List<CardsTakeOutInfo> fightFootballTimeAward = EventAwardMgr.GetFightFootballTimeAward(eEventType.FIGHT_FOOTBALL_TIME);
				if (fightFootballTimeAward.Count > 0)
				{
					CardsTakeOutInfo cardsTakeOutInfo = fightFootballTimeAward[0];
					if (!dictionary2.Keys.Contains(cardsTakeOutInfo.templateID))
					{
						dictionary2.Add(cardsTakeOutInfo.templateID, cardsTakeOutInfo);
						cardsTakeOutInfo.place = num;
						cardsTakeOutInfo.count = cardsTakeOutInfo.count;
						dictionary.Add(num, cardsTakeOutInfo);
						num++;
					}
				}
				num2++;
			}
			return dictionary;
		}
	}
}
