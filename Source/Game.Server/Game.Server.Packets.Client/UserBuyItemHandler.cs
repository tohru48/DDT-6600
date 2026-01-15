using System;
using System.Collections.Generic;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(44, "购买物品")]
	public class UserBuyItemHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			StringBuilder stringBuilder = new StringBuilder();
			eMessageType type = eMessageType.Normal;
			string translateId = "UserBuyItemHandler.Success";
			GSPacketIn gSPacketIn = new GSPacketIn(44, client.Player.PlayerCharacter.ID);
			List<bool> list = new List<bool>();
			List<int> list2 = new List<int>();
			StringBuilder stringBuilder2 = new StringBuilder();
			Dictionary<int, ItemInfo> dictionary = new Dictionary<int, ItemInfo>();
			bool isBinds = false;
			ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
			int num = packet.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int num2 = packet.ReadInt();
				int ıD = packet.ReadInt();
				int num3 = packet.ReadInt();
				string text = packet.ReadString();
				bool item = packet.ReadBoolean();
				string text2 = packet.ReadString();
				int item2 = packet.ReadInt();
				packet.ReadBoolean();
				ShopItemInfo shopItemInfo = ShopMgr.GetShopItemInfoById(ıD);
				if (num2 == 2)
				{
					shopItemInfo = ShopMgr.GetShopItemDisCountById(ıD);
				}
				if (shopItemInfo == null || !ShopMgr.IsOnShop(shopItemInfo.ID) || !ShopMgr.CanBuy(shopItemInfo.ShopID, consortiaInfo?.ShopLevel ?? 1, ref isBinds, client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.Riches))
				{
					continue;
				}
				ItemTemplateInfo goods = ItemMgr.FindItemTemplate(shopItemInfo.TemplateID);
				ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(goods, 1, 102);
				if (shopItemInfo.BuyType == 0)
				{
					if (1 == num3)
					{
						ıtemInfo.ValidDate = shopItemInfo.AUnit;
					}
					if (2 == num3)
					{
						ıtemInfo.ValidDate = shopItemInfo.BUnit;
					}
					if (3 == num3)
					{
						ıtemInfo.ValidDate = shopItemInfo.CUnit;
					}
				}
				else
				{
					if (1 == num3)
					{
						ıtemInfo.Count = shopItemInfo.AUnit;
					}
					if (2 == num3)
					{
						ıtemInfo.Count = shopItemInfo.BUnit;
					}
					if (3 == num3)
					{
						ıtemInfo.Count = shopItemInfo.CUnit;
					}
				}
				if (num3 > 3 || num3 < 0 || (ıtemInfo == null && shopItemInfo == null))
				{
					continue;
				}
				ıtemInfo.Color = ((text == null) ? "" : text);
				ıtemInfo.Skin = ((text2 == null) ? "" : text2);
				if (isBinds)
				{
					ıtemInfo.IsBinds = true;
				}
				else
				{
					ıtemInfo.IsBinds = Convert.ToBoolean(shopItemInfo.IsBind);
				}
				ShopMgr.SetItemType(shopItemInfo, num3, ref specialValue);
				if ((specialValue.Money <= 0 || ShopCondition.isMoney(shopItemInfo.ShopID)) && (specialValue.Offer <= 0 || ShopCondition.isOffer(shopItemInfo.ShopID)) && (specialValue.DDTMoney <= 0 || ShopCondition.smethod_0(shopItemInfo.ShopID)) && (specialValue.DamageScore <= 0 || ShopCondition.isWorldBoss(shopItemInfo.ShopID)) && (specialValue.PetScore <= 0 || ShopCondition.isPetScrore(shopItemInfo.ShopID)) && (specialValue.HardCurrency <= 0 || ShopCondition.isLabyrinth(shopItemInfo.ShopID)) && (specialValue.LeagueMoney <= 0 || ShopCondition.isLeague(shopItemInfo.ShopID)) && (specialValue.SummerScore <= 0 || ShopCondition.isCatchInsect(shopItemInfo.ShopID)) && (specialValue.iCount <= 0 || ShopCondition.isSearchGoods(shopItemInfo.ShopID)))
				{
					stringBuilder2.Append(num3);
					stringBuilder2.Append(",");
					list.Add(item);
					list2.Add(item2);
					if (!dictionary.ContainsKey(ıtemInfo.TemplateID))
					{
						dictionary.Add(ıtemInfo.TemplateID, ıtemInfo);
					}
					else
					{
						dictionary[ıtemInfo.TemplateID].Count += ıtemInfo.Count;
					}
				}
			}
			int num4 = packet.ReadInt();
			bool flag = false;
			int num5 = specialValue.Gold + specialValue.Money + specialValue.Offer + specialValue.DDTMoney + specialValue.DamageScore + specialValue.PetScore + specialValue.HardCurrency + specialValue.LeagueMoney + specialValue.SummerScore;
			if (dictionary.Count == 0)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("UserBuyItemHandler.NotSell"));
				return 1;
			}
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 1;
			}
			if (GameProperties.IsActiveMoney && num5 > 0)
			{
				foreach (ItemInfo value in dictionary.Values)
				{
					if (method_0(value.TemplateID) && client.Player.Actives.Info.ActiveMoney < num5)
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("UserBuyItemHandler.ActiveMoneyNotEnough", value.Template.Name, client.Player.Actives.Info.ActiveMoney));
						return 0;
					}
					client.Player.RemoveActiveMoney(num5);
				}
			}
			if (specialValue.Int32_0 > 0 && num5 == 0)
			{
				int ıtemCount = client.Player.GetItemCount(specialValue.Int32_0);
				if (ıtemCount > 0 && ıtemCount >= specialValue.iCount)
				{
					flag = client.Player.RemoveTemplate(specialValue.Int32_0, specialValue.iCount);
				}
				else
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("UserBuyItemHandler.FailByPermission"));
				}
			}
			else if (num5 > 0)
			{
				if (specialValue.Money > client.Player.PlayerCharacter.Money)
				{
					translateId = "UserBuyItemHandler.NoMoney";
				}
				else if (specialValue.Gold > client.Player.PlayerCharacter.Gold)
				{
					translateId = "UserBuyItemHandler.NoGold";
				}
				else if (specialValue.Offer > client.Player.PlayerCharacter.Offer)
				{
					translateId = "UserBuyItemHandler.NoOffer";
				}
				else if (specialValue.DDTMoney > client.Player.PlayerCharacter.DDTMoney)
				{
					translateId = "UserBuyItemHandler.GiftToken";
				}
				else if (specialValue.Medal > client.Player.PlayerCharacter.medal)
				{
					translateId = "UserBuyItemHandler.Medal";
				}
				else if (specialValue.DamageScore > client.Player.PlayerCharacter.damageScores)
				{
					translateId = "UserBuyItemHandler.FailByPermission";
				}
				else if (specialValue.PetScore > client.Player.PlayerCharacter.petScore)
				{
					translateId = "UserBuyItemHandler.FailByPermission";
				}
				else if (specialValue.HardCurrency > client.Player.PlayerCharacter.hardCurrency)
				{
					translateId = "UserBuyItemHandler.FailByPermission";
				}
				else if (specialValue.LeagueMoney > client.Player.PlayerCharacter.LeagueMoney)
				{
					translateId = "UserBuyItemHandler.FailByPermission";
				}
				else if (specialValue.SummerScore > client.Player.Extra.Info.SummerScore)
				{
					translateId = "UserBuyItemHandler.SummerScore";
				}
				else if (specialValue.UseableScore == 0)
				{
					type = eMessageType.ERROR;
					client.Player.DirectRemoveValue(specialValue);
					if (!GameProperties.IsDDTMoneyActive)
					{
						client.Player.AddExpVip(specialValue.Money);
					}
					flag = true;
				}
			}
			if (flag)
			{
				string text3 = "";
				foreach (ItemInfo value2 in dictionary.Values)
				{
					text3 += ((text3 == "") ? value2.TemplateID.ToString() : ("," + value2.TemplateID));
					switch (num4)
					{
					case 1:
					case 2:
						if (!method_1(client, value2))
						{
							client.Player.AddTemplate(value2);
						}
						continue;
					}
					new List<ItemInfo>();
					if (value2.Template.MaxCount == 1)
					{
						for (int j = 0; j < value2.Count; j++)
						{
							ItemInfo ıtemInfo2 = ItemInfo.CloneFromTemplate(value2.Template, value2);
							ıtemInfo2.Count = 1;
							client.Player.AddTemplate(ıtemInfo2);
						}
						continue;
					}
					int num6 = 0;
					for (int k = 0; k < value2.Count; k++)
					{
						if (num6 == value2.Template.MaxCount)
						{
							ItemInfo ıtemInfo3 = ItemInfo.CloneFromTemplate(value2.Template, value2);
							ıtemInfo3.Count = num6;
							client.Player.AddTemplate(ıtemInfo3);
							num6 = 0;
						}
						num6++;
					}
					if (num6 > 0)
					{
						ItemInfo ıtemInfo4 = ItemInfo.CloneFromTemplate(value2.Template, value2);
						ıtemInfo4.Count = num6;
						client.Player.AddTemplate(ıtemInfo4);
					}
				}
				client.Player.OnPaid(specialValue.Money, specialValue.Gold, specialValue.Offer, specialValue.DDTMoney, specialValue.Medal, stringBuilder.ToString());
			}
			else
			{
				type = eMessageType.ERROR;
				translateId = "UserBuyItemHandler.FailByPermission";
			}
			client.Out.SendMessage(type, LanguageMgr.GetTranslation(translateId));
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(3);
			client.Player.SendTCP(gSPacketIn);
			return 0;
		}

		private bool method_0(int int_0)
		{
			return int_0 == 201192;
		}

		private bool method_1(GameClient gameClient_0, ItemInfo itemInfo_0)
		{
			int num = 2;
			if (itemInfo_0.TemplateID == 11018 || itemInfo_0.TemplateID == 11025)
			{
				num = 0;
			}
			ItemInfo ıtemAt = gameClient_0.Player.StoreBag.GetItemAt(num);
			if (ıtemAt != null && ıtemAt.Count < ıtemAt.Template.MaxCount && ıtemAt.CanStackedTo(itemInfo_0))
			{
				return gameClient_0.Player.StoreBag.AddTemplateAt(itemInfo_0, itemInfo_0.Count, num);
			}
			if (ıtemAt == null)
			{
				return gameClient_0.Player.StoreBag.AddItemTo(itemInfo_0, num);
			}
			return gameClient_0.Player.AddTemplate(itemInfo_0, (eBageType)itemInfo_0.GetBagType, itemInfo_0.Count, eGameView.RouletteTypeGet);
		}
	}
}
