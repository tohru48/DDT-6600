using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(170, "场景用户离开")]
	public class CardSlotHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			string text = "";
			List<UsersCardInfo> cards = client.Player.CardBag.GetCards(0, 5);
			switch (num)
			{
			case 0:
			{
				int num3 = packet.ReadInt();
				int num4 = packet.ReadInt();
				if (num4 > 0 && num4 <= client.Player.PlayerCharacter.CardSoul)
				{
					int type = cards[num3].Type;
					int gP = cards[num3].CardGP + num4;
					int level = CardMgr.GetLevel(gP, type);
					int num5 = CardMgr.GetGP(level, type) - cards[num3].CardGP;
					if (level == CardMgr.MaxLv(type))
					{
						num4 = num5;
					}
					client.Player.CardBag.UpGraceSlot(num4, level, num3);
					client.Player.RemoveCardSoul(num4);
					client.Player.Out.SendPlayerCardSlot(client.Player.PlayerCharacter, cards[num3]);
					client.Player.EquipBag.UpdatePlayerProperties();
				}
				break;
			}
			case 1:
				packet.ReadBoolean();
				if (client.Player.MoneyDirect(300))
				{
					int num2 = 0;
					for (int i = 0; i < cards.Count; i++)
					{
						num2 += cards[i].CardGP;
					}
					client.Player.CardBag.ResetCardSoul();
					client.Player.AddCardSoul(num2);
					text = LanguageMgr.GetTranslation("UpdateSLOT.ResetComplete", num2);
					client.Player.Out.SendPlayerCardSlot(client.Player.PlayerCharacter, cards);
					client.Player.EquipBag.UpdatePlayerProperties();
				}
				else
				{
					text = "Xu không đủ!";
				}
				break;
			}
			if (text != "")
			{
				client.Out.SendMessage(eMessageType.Normal, text);
			}
			return 0;
		}
	}
}
