using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server;
using Game.Server.GameUtils;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.Packets.Client;
using log4net;
using SqlDataProvider.Data;

[PacketHandler(216, "防沉迷系统开关")]
internal class Class14 : IPacketHandler
{
	private static readonly ILog ilog_0;

	public static ThreadSafeRandom threadSafeRandom_0;

	public int HandlePacket(GameClient client, GSPacketIn packet)
	{
		int num = packet.ReadInt();
		PlayerInfo playerCharacter = client.Player.PlayerCharacter;
		CardInventory cardBag = client.Player.CardBag;
		List<ItemInfo> list = new List<ItemInfo>();
		switch (num)
		{
		case 0:
		{
			int num9 = packet.ReadInt();
			int num10 = packet.ReadInt();
			UsersCardInfo ıtemAt2 = cardBag.GetItemAt(num9);
			UsersCardInfo ıtemAt3 = cardBag.GetItemAt(num10);
			if (ıtemAt2 == null)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CardDataHander.Msg1"));
				return 0;
			}
			if (ıtemAt3 != null && num10 >= 5)
			{
				return 0;
			}
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(ıtemAt2.TemplateID);
			if (ıtemTemplateInfo.Property8 == 0 && num10 == 0)
			{
				return 0;
			}
			if (ıtemTemplateInfo.Property8 == 1 && num10 > 0 && num10 <= 4)
			{
				return 0;
			}
			if (num9 == num10)
			{
				cardBag.MoveCard(num9, num10);
				client.Player.EquipBag.UpdatePlayerProperties();
				return 0;
			}
			string translation2;
			if (cardBag.FindEquipCard(ıtemAt2.TemplateID))
			{
				translation2 = LanguageMgr.GetTranslation("CardDataHander.Msg2");
			}
			else
			{
				cardBag.MoveCard(num9, num10);
				client.Player.EquipBag.UpdatePlayerProperties();
				translation2 = LanguageMgr.GetTranslation("CardDataHander.Msg3");
			}
			client.Out.SendMessage(eMessageType.Normal, translation2);
			return 0;
		}
		case 2:
		{
			int num2 = packet.ReadInt();
			List<UsersCardInfo> cards = cardBag.GetCards(5, cardBag.Capalility);
			if (num2 != cards.Count)
			{
				return 0;
			}
			bool flag2 = false;
			cardBag.BeginChanges();
			try
			{
				try
				{
					UsersCardInfo[] rawSpaces = cardBag.GetRawSpaces();
					cardBag.Clear();
					for (int j = 0; j < num2; j++)
					{
						int num5 = packet.ReadInt();
						int num6 = packet.ReadInt();
						UsersCardInfo usersCardInfo = rawSpaces[num5];
						if (usersCardInfo != null && !cardBag.AddCardTo(usersCardInfo, num6))
						{
							throw new Exception($"move card Bag error: old place:{num5} new place:{num6}");
						}
					}
					flag2 = true;
				}
				catch (Exception ex)
				{
					ilog_0.ErrorFormat("Arrage bag errror,user id:{0}   msg:{1}", client.Player.PlayerId, ex.Message);
				}
				return 0;
			}
			finally
			{
				if (!flag2)
				{
					cardBag.Clear();
					foreach (UsersCardInfo item in cards)
					{
						cardBag.AddCardTo(item, item.Place);
					}
				}
				cardBag.CommitChanges();
			}
		}
		case 3:
			return 0;
		case 5:
			if (!client.Player.MoneyDirect(50))
			{
				return 0;
			}
			if (client.Player.PlayerCharacter.GetSoulCount > 0)
			{
				int num7 = 50;
				int num8 = threadSafeRandom_0.Next(1000);
				if (num8 < 100)
				{
					num7 = 120;
				}
				client.Player.AddCardSoul(num7);
				client.Player.PlayerCharacter.GetSoulCount--;
				client.Player.Out.SendPlayerCardSoul(client.Player.PlayerCharacter, isSoul: true, num7);
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CardDataHander.Msg6", num7));
				return 0;
			}
			client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CardDataHander.Msg7"));
			return 0;
		default:
			return 0;
		case 1:
		case 4:
		{
			int slot = packet.ReadInt();
			int num2 = packet.ReadInt();
			if (num2 == 99)
			{
				num2 = 999;
			}
			ItemInfo ıtemAt = client.Player.EquipBag.GetItemAt(slot);
			if (num == 4)
			{
				ıtemAt = client.Player.PropBag.GetItemAt(slot);
			}
			if (ıtemAt == null)
			{
				return 0;
			}
			if (ıtemAt.Count < num2 || num2 < 1)
			{
				return 0;
			}
			if (!ıtemAt.IsCard())
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CardDataHander.Msg4", ıtemAt.Template.Name));
				return 0;
			}
			bool flag = false;
			int num3 = 0;
			int num4 = 0;
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			for (int i = 0; i < num2; i++)
			{
				if (ItemBoxMgr.CreateItemBox(ıtemAt.TemplateID, list, ref specialValue))
				{
					int index = threadSafeRandom_0.Next(list.Count);
					ItemInfo ıtemInfo = list[index];
					if (flag = method_0(client, ıtemInfo.Template.Property5))
					{
						num3++;
					}
				}
				if (!flag)
				{
					num4 = ((ıtemAt.TemplateID != 20150) ? (num4 + threadSafeRandom_0.Next(5, 25)) : (num4 + threadSafeRandom_0.Next(50, 500)));
				}
			}
			client.Player.RemoveTemplate(ıtemAt.TemplateID, num2);
			client.Player.AddCardSoul(num4);
			client.Player.Out.SendPlayerCardSoul(client.Player.PlayerCharacter, isSoul: true, num4);
			string translation = LanguageMgr.GetTranslation("CardDataHander.Msg5", num4, num3);
			client.Out.SendMessage(eMessageType.Normal, translation);
			return 0;
		}
		}
	}

	private bool method_0(GameClient gameClient_0, int int_0)
	{
		bool result = false;
		int place = gameClient_0.Player.CardBag.FindFirstEmptySlot(5);
		CardTemplateInfo card = CardMgr.GetCard(int_0);
		if (card != null)
		{
			int num = gameClient_0.Player.CardBag.FindPlaceByTamplateId(5, int_0);
			UsersCardInfo usersCardInfo;
			if (num == -1)
			{
				usersCardInfo = new UsersCardInfo();
				usersCardInfo.CardType = card.CardType;
				usersCardInfo.UserID = gameClient_0.Player.PlayerCharacter.ID;
				usersCardInfo.Place = place;
				usersCardInfo.TemplateID = card.CardID;
				usersCardInfo.isFirstGet = true;
				usersCardInfo.Attack = 0;
				usersCardInfo.Agility = 0;
				usersCardInfo.Defence = 0;
				usersCardInfo.Luck = 0;
				usersCardInfo.Damage = 0;
				usersCardInfo.Guard = 0;
			}
			else
			{
				usersCardInfo = gameClient_0.Player.CardBag.GetItemAt(num);
				if (method_2(usersCardInfo.CardType, card.CardType))
				{
					usersCardInfo.isFirstGet = true;
				}
				else
				{
					usersCardInfo = null;
				}
			}
			if (usersCardInfo != null)
			{
				result = ((num != -1) ? gameClient_0.Player.CardBag.UpdateCardType(usersCardInfo.TemplateID, card.CardType) : gameClient_0.Player.CardBag.AddCardTo(usersCardInfo, place));
				gameClient_0.Out.SendGetCard(gameClient_0.Player.PlayerCharacter, usersCardInfo);
			}
		}
		return result;
	}

	private string method_1(int int_0)
	{
		return int_0 switch
		{
			2 => LanguageMgr.GetTranslation("CardDataHander.Msg8"), 
			1 => LanguageMgr.GetTranslation("CardDataHander.Msg9"), 
			4 => LanguageMgr.GetTranslation("CardDataHander.Msg10"), 
			_ => LanguageMgr.GetTranslation("CardDataHander.Msg11"), 
		};
	}

	private bool method_2(int int_0, int int_1)
	{
		return (int_1 == 2 && (int_0 == 0 || int_0 == 3)) || (int_1 == 1 && (int_0 == 2 || int_0 == 0 || int_0 == 3)) || (int_1 == 4 && (int_0 == 1 || int_0 == 2 || int_0 == 0 || int_0 == 3));
	}

	static Class14()
	{
		ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		threadSafeRandom_0 = new ThreadSafeRandom();
	}
}
