using System.Collections.Generic;
using System.Linq;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.MagicStone.Handle
{
	[Attribute11(5)]
	public class ConverScore : IMagicStoneCommandHadler
	{
		public static ThreadSafeRandom random;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int ıD = packet.ReadInt();
			packet.ReadBoolean();
			packet.ReadInt();
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			eMessageType type = eMessageType.Normal;
			string translateId = "UserBuyItemHandler.Success";
			ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(ıD);
			bool flag = false;
			if (shopItemInfoById == null)
			{
				return false;
			}
			if (shopItemInfoById != null && ShopMgr.IsOnShop(shopItemInfoById.ID) && shopItemInfoById.ShopID == 101)
			{
				flag = true;
			}
			if (!flag)
			{
				Player.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserBuyItemHandler.FailByPermission"));
				return false;
			}
			Dictionary<int, ItemInfo> dictionary = new Dictionary<int, ItemInfo>();
			ItemTemplateInfo info = ItemMgr.FindItemTemplate(shopItemInfoById.TemplateID);
			ItemInfo ıtemInfo = Player.MagicStoneBag.CreateMagicstone(info, 1);
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
			if (dictionary.Values.Count == 0)
			{
				return false;
			}
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			if (Player.Extra.Info.ScoreMagicstone < specialValue.MagicstoneScore)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("ConverScore.Msg1"));
				return false;
			}
			Player.RemoveScoreMagicstone(specialValue.MagicstoneScore);
			string text = "";
			foreach (ItemInfo value in dictionary.Values)
			{
				text += ((text == "") ? value.TemplateID.ToString() : ("," + value.TemplateID));
				for (int i = 0; i < ıtemInfo.Count; i++)
				{
					ItemInfo ıtemInfo2 = ItemInfo.CloneFromTemplate(value.Template, value);
					ıtemInfo2.Count = 1;
					Player.AddTemplate(ıtemInfo2);
				}
			}
			Player.Out.SendMessage(type, LanguageMgr.GetTranslation(translateId));
			GSPacketIn gSPacketIn = new GSPacketIn(258, Player.PlayerId);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(Player.Extra.Info.ScoreMagicstone);
			Player.SendTCP(gSPacketIn);
			return true;
		}

		static ConverScore()
		{
			random = new ThreadSafeRandom();
		}
	}
}
