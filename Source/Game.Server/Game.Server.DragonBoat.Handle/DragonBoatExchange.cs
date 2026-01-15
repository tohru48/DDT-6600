using System.Collections.Generic;
using System.Linq;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.DragonBoat.Handle
{
	[Attribute4(4)]
	public class DragonBoatExchange : IDragonBoatCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(100);
			ActiveSystemInfo ınfo = Player.Actives.Info;
			int ıD = packet.ReadInt();
			int num = packet.ReadInt();
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			eMessageType type = eMessageType.Normal;
			string translation = LanguageMgr.GetTranslation("UserBuyItemHandler.Success");
			ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(ıD);
			if (shopItemInfoById == null)
			{
				return false;
			}
			bool flag = false;
			if (shopItemInfoById != null && ShopMgr.IsOnShop(shopItemInfoById.ID) && shopItemInfoById.ShopID == 95)
			{
				flag = true;
			}
			if (!flag)
			{
				Player.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserBuyItemHandler.FailByPermission"));
				return false;
			}
			Dictionary<int, ItemInfo> dictionary = new Dictionary<int, ItemInfo>();
			for (int i = 0; i < num; i++)
			{
				ItemTemplateInfo goods = ItemMgr.FindItemTemplate(shopItemInfoById.TemplateID);
				ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(goods, 1, 102);
				if (ıtemInfo != null || shopItemInfoById != null)
				{
					if (shopItemInfoById.BuyType == 0)
					{
						ıtemInfo.ValidDate = shopItemInfoById.AUnit;
					}
					else
					{
						ıtemInfo.Count = shopItemInfoById.AUnit;
					}
					ıtemInfo.IsBinds = true;
					if (!dictionary.Keys.Contains(ıtemInfo.TemplateID))
					{
						dictionary.Add(ıtemInfo.TemplateID, ıtemInfo);
					}
					else
					{
						dictionary[ıtemInfo.TemplateID].Count += ıtemInfo.Count;
					}
					ShopMgr.SetItemType(shopItemInfoById, 1, ref specialValue);
				}
			}
			if (dictionary.Count == 0)
			{
				return false;
			}
			if (ınfo.useableScore < specialValue.UseableScore)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("DragonBoatHandler.Msg1"));
				return false;
			}
			ınfo.useableScore -= specialValue.UseableScore;
			string text = "";
			foreach (ItemInfo value in dictionary.Values)
			{
				text += ((text == "") ? value.TemplateID.ToString() : ("," + value.TemplateID));
				if (value.Template.MaxCount == 1)
				{
					for (int j = 0; j < value.Count; j++)
					{
						ItemInfo ıtemInfo2 = ItemInfo.CloneFromTemplate(value.Template, value);
						ıtemInfo2.Count = 1;
						Player.AddTemplate(ıtemInfo2);
					}
					continue;
				}
				int num2 = 0;
				for (int k = 0; k < value.Count; k++)
				{
					if (num2 == value.Template.MaxCount)
					{
						ItemInfo ıtemInfo3 = ItemInfo.CloneFromTemplate(value.Template, value);
						ıtemInfo3.Count = num2;
						Player.AddTemplate(ıtemInfo3);
						num2 = 0;
					}
					num2++;
				}
				if (num2 > 0)
				{
					ItemInfo ıtemInfo4 = ItemInfo.CloneFromTemplate(value.Template, value);
					ıtemInfo4.Count = num2;
					Player.AddTemplate(ıtemInfo4);
				}
			}
			Player.SendMessage(type, LanguageMgr.GetTranslation(translation));
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(ınfo.useableScore);
			gSPacketIn.WriteInt(ınfo.totalScore);
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
