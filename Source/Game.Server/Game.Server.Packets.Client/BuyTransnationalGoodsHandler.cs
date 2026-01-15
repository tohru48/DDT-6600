using System.Collections.Generic;
using System.Linq;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(156, "客户端日记")]
	public class BuyTransnationalGoodsHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int ıD = packet.ReadInt();
			PyramidInfo pyramid = client.Player.Actives.Pyramid;
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			eMessageType type = eMessageType.Normal;
			string translateId = "UserBuyItemHandler.Success";
			ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(ıD);
			if (shopItemInfoById == null)
			{
				return 0;
			}
			bool flag = false;
			if (ShopMgr.IsOnShop(shopItemInfoById.ID) && shopItemInfoById.ShopID == 98)
			{
				flag = true;
			}
			if (!flag)
			{
				client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserBuyItemHandler.FailByPermission"));
				return 1;
			}
			Dictionary<int, ItemInfo> dictionary = new Dictionary<int, ItemInfo>();
			ItemTemplateInfo goods = ItemMgr.FindItemTemplate(shopItemInfoById.TemplateID);
			ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(goods, 1, 102);
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
				return 1;
			}
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 1;
			}
			if (pyramid.totalPoint < specialValue.DamageScore)
			{
				client.Player.SendMessage(LanguageMgr.GetTranslation("BuyTransnationalGoodsHandler.Msg1"));
				return 0;
			}
			pyramid.totalPoint -= specialValue.DamageScore;
			string text = "";
			foreach (ItemInfo value in dictionary.Values)
			{
				text += ((text == "") ? value.TemplateID.ToString() : ("," + value.TemplateID));
				if (value.Template.MaxCount == 1)
				{
					for (int i = 0; i < value.Count; i++)
					{
						ItemInfo ıtemInfo2 = ItemInfo.CloneFromTemplate(value.Template, value);
						ıtemInfo2.Count = 1;
						client.Player.AddTemplate(ıtemInfo2);
					}
					continue;
				}
				int num = 0;
				for (int j = 0; j < value.Count; j++)
				{
					if (num == value.Template.MaxCount)
					{
						ItemInfo ıtemInfo3 = ItemInfo.CloneFromTemplate(value.Template, value);
						ıtemInfo3.Count = num;
						client.Player.AddTemplate(ıtemInfo3);
						num = 0;
					}
					num++;
				}
				if (num > 0)
				{
					ItemInfo ıtemInfo4 = ItemInfo.CloneFromTemplate(value.Template, value);
					ıtemInfo4.Count = num;
					client.Player.AddTemplate(ıtemInfo4);
				}
			}
			client.Out.SendMessage(type, LanguageMgr.GetTranslation(translateId));
			GSPacketIn gSPacketIn = new GSPacketIn(145, client.Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteBoolean(pyramid.isPyramidStart);
			gSPacketIn.WriteInt(pyramid.totalPoint);
			gSPacketIn.WriteInt(pyramid.turnPoint);
			gSPacketIn.WriteInt(pyramid.pointRatio);
			gSPacketIn.WriteInt(pyramid.currentLayer);
			client.Player.SendTCP(gSPacketIn);
			return 0;
		}
	}
}
