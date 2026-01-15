using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(196, "场景用户离开")]
	public class CardResetHandler : IPacketHandler
	{
		public static ThreadSafeRandom random;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			UsersCardInfo ıtemByPlace = client.Player.CardBag.GetItemByPlace(0, num2);
			if (ıtemByPlace == null)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CardResetHandler.Msg1"));
				return 0;
			}
			if (client.Player.PlayerCharacter.CardSoul <= 50)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CardResetHandler.Msg2"));
				return 0;
			}
			List<int> list = new List<int>();
			string translation = LanguageMgr.GetTranslation("CardResetHandler.Msg3");
			int minValue = 1;
			int maxValue = 10;
			if (ıtemByPlace.CardType == 2)
			{
				minValue = 5;
				maxValue = 31;
			}
			if (ıtemByPlace.CardType == 1)
			{
				minValue = 15;
				maxValue = 51;
			}
			if (ıtemByPlace.CardType == 4)
			{
				minValue = 25;
				maxValue = 81;
			}
			switch (num)
			{
			case 0:
			{
				for (int i = 0; i < 4; i++)
				{
					int num3 = random.Next(minValue, maxValue);
					list.Add(num3);
					switch (i)
					{
					case 0:
						ıtemByPlace.Attack = num3;
						break;
					case 1:
						ıtemByPlace.Defence = num3;
						break;
					case 2:
						ıtemByPlace.Agility = num3;
						break;
					case 3:
						ıtemByPlace.Luck = num3;
						break;
					}
				}
				client.Player.CardBag.UpdateTempCard(ıtemByPlace);
				client.Player.RemoveCardSoul(50);
				client.Player.Out.SendPlayerCardReset(client.Player.PlayerCharacter, list);
				break;
			}
			case 1:
				translation = LanguageMgr.GetTranslation("CardResetHandler.Msg4");
				client.Player.CardBag.UpdateCard();
				if (num2 < 5)
				{
					client.Player.EquipBag.UpdatePlayerProperties();
				}
				client.Player.CardBag.SaveToDatabase();
				break;
			}
			client.Out.SendMessage(eMessageType.Normal, translation);
			return 0;
		}

		static CardResetHandler()
		{
			random = new ThreadSafeRandom();
		}
	}
}
