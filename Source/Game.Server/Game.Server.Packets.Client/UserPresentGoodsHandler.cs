using System;
using System.Collections.Generic;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(57, "购买物品")]
	public class UserPresentGoodsHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			StringBuilder stringBuilder = new StringBuilder();
			eMessageType eMessageType = eMessageType.Normal;
			string translateId = "UserPresentGoodsHandler.Success";
			string text = packet.ReadString();
			string text2 = packet.ReadString();
			int num = packet.ReadInt();
			if (client.Player.PlayerCharacter.NickName == text2)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("GoodsPresentHandler.Msg1"));
				return 0;
			}
			int num2 = GameProperties.LimitLevel(2);
			if (client.Player.PlayerCharacter.Grade < num2)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("GoodsPresentHandler.Msg2", num2));
				return 0;
			}
			List<ItemInfo> list = new List<ItemInfo>();
			StringBuilder stringBuilder2 = new StringBuilder();
			GamePlayer clientByPlayerNickName = WorldMgr.GetClientByPlayerNickName(text2);
			PlayerInfo playerInfo;
			if (clientByPlayerNickName == null)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				playerInfo = playerBussiness.GetUserSingleByNickName(text2);
			}
			else
			{
				playerInfo = clientByPlayerNickName.PlayerCharacter;
			}
			bool flag = false;
			if (playerInfo.Grade < num2)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("GoodsPresentHandler.Msg3", num2));
				return 0;
			}
			bool flag2 = false;
			for (int i = 0; i < num; i++)
			{
				int ıD = packet.ReadInt();
				int num3 = packet.ReadInt();
				string text3 = packet.ReadString();
				string text4 = packet.ReadString();
				packet.ReadInt();
				ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(ıD);
				if (shopItemInfoById != null && ShopMgr.IsOnShop(shopItemInfoById.ID) && shopItemInfoById.ShopID == 1)
				{
					flag2 = true;
				}
				ItemTemplateInfo goods = ItemMgr.FindItemTemplate(shopItemInfoById.TemplateID);
				ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(goods, 1, 102);
				if (shopItemInfoById.BuyType == 0)
				{
					if (1 == num3)
					{
						ıtemInfo.ValidDate = shopItemInfoById.AUnit;
					}
					if (2 == num3)
					{
						ıtemInfo.ValidDate = shopItemInfoById.BUnit;
					}
					if (3 == num3)
					{
						ıtemInfo.ValidDate = shopItemInfoById.CUnit;
					}
				}
				else
				{
					if (1 == num3)
					{
						ıtemInfo.Count = shopItemInfoById.AUnit;
					}
					if (2 == num3)
					{
						ıtemInfo.Count = shopItemInfoById.BUnit;
					}
					if (3 == num3)
					{
						ıtemInfo.Count = shopItemInfoById.CUnit;
					}
				}
				if (ıtemInfo != null || shopItemInfoById != null)
				{
					ıtemInfo.Color = ((text3 == null) ? "" : text3);
					ıtemInfo.Skin = ((text4 == null) ? "" : text4);
					if (flag)
					{
						ıtemInfo.IsBinds = true;
					}
					else
					{
						ıtemInfo.IsBinds = Convert.ToBoolean(shopItemInfoById.IsBind);
					}
					stringBuilder2.Append(num3);
					stringBuilder2.Append(",");
					if (flag2)
					{
						list.Add(ıtemInfo);
					}
					ShopMgr.SetItemType(shopItemInfoById, num3, ref specialValue);
				}
			}
			if (list.Count == 0)
			{
				client.Disconnect();
				return 1;
			}
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 1;
			}
			if (!client.Player.ActiveMoneyEnable(specialValue.Money))
			{
				return 0;
			}
			if (specialValue.Gold <= client.Player.PlayerCharacter.Gold && specialValue.Money <= client.Player.PlayerCharacter.Money && specialValue.DDTMoney <= client.Player.PlayerCharacter.DDTMoney && specialValue.Medal <= client.Player.PlayerCharacter.medal)
			{
				client.Player.DirectRemoveValue(specialValue);
				string text5 = "";
				int num4 = 0;
				MailInfo mailInfo = new MailInfo();
				StringBuilder stringBuilder3 = new StringBuilder();
				stringBuilder3.Append(LanguageMgr.GetTranslation("GoodsPresentHandler.AnnexRemark"));
				for (int j = 0; j < list.Count; j++)
				{
					text5 += ((text5 == "") ? list[j].TemplateID.ToString() : ("," + list[j].TemplateID));
					using PlayerBussiness playerBussiness2 = new PlayerBussiness();
					list[j].UserID = 0;
					playerBussiness2.AddGoods(list[j]);
					num4++;
					stringBuilder3.Append(num4);
					stringBuilder3.Append("、");
					stringBuilder3.Append(list[j].Template.Name);
					stringBuilder3.Append("x");
					stringBuilder3.Append(list[j].Count);
					stringBuilder3.Append(";");
					switch (num4)
					{
					case 1:
						mailInfo.Annex1 = list[j].ItemID.ToString();
						mailInfo.String_0 = list[j].Template.Name;
						break;
					case 2:
						mailInfo.Annex2 = list[j].ItemID.ToString();
						mailInfo.String_1 = list[j].Template.Name;
						break;
					case 3:
						mailInfo.Annex3 = list[j].ItemID.ToString();
						mailInfo.String_2 = list[j].Template.Name;
						break;
					case 4:
						mailInfo.Annex4 = list[j].ItemID.ToString();
						mailInfo.String_3 = list[j].Template.Name;
						break;
					case 5:
						mailInfo.Annex5 = list[j].ItemID.ToString();
						mailInfo.String_4 = list[j].Template.Name;
						break;
					}
					if (num4 == 5)
					{
						num4 = 0;
						mailInfo.AnnexRemark = stringBuilder3.ToString();
						stringBuilder3.Remove(0, stringBuilder3.Length);
						stringBuilder3.Append(LanguageMgr.GetTranslation("GoodsPresentHandler.AnnexRemark"));
						mailInfo.Content = LanguageMgr.GetTranslation("UserBuyItemHandler.Title") + mailInfo.String_0 + "] " + text;
						mailInfo.Gold = 0;
						mailInfo.Money = 0;
						mailInfo.Receiver = playerInfo.NickName;
						mailInfo.ReceiverID = playerInfo.ID;
						mailInfo.Sender = client.Player.PlayerCharacter.NickName;
						mailInfo.SenderID = client.Player.PlayerCharacter.ID;
						mailInfo.Title = mailInfo.Content;
						mailInfo.Type = 8;
						playerBussiness2.SendMail(mailInfo);
						eMessageType = eMessageType.ERROR;
						mailInfo.Revert();
					}
				}
				if (num4 > 0)
				{
					using PlayerBussiness playerBussiness3 = new PlayerBussiness();
					mailInfo.AnnexRemark = stringBuilder3.ToString();
					mailInfo.Content = LanguageMgr.GetTranslation("UserBuyItemHandler.Title") + mailInfo.String_0 + "] " + text;
					mailInfo.Gold = 0;
					mailInfo.Money = 0;
					mailInfo.Receiver = playerInfo.NickName;
					mailInfo.ReceiverID = playerInfo.ID;
					mailInfo.Sender = client.Player.PlayerCharacter.NickName;
					mailInfo.SenderID = client.Player.PlayerCharacter.ID;
					mailInfo.Title = mailInfo.Content;
					mailInfo.Type = 8;
					playerBussiness3.SendMail(mailInfo);
					eMessageType = eMessageType.ERROR;
				}
				if (eMessageType == eMessageType.ERROR)
				{
					clientByPlayerNickName?.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
				}
				client.Player.OnPaid(specialValue.Money, specialValue.Gold, specialValue.Offer, specialValue.DDTMoney, specialValue.Medal, stringBuilder.ToString());
			}
			else
			{
				if (specialValue.Gold > client.Player.PlayerCharacter.Gold)
				{
					translateId = "UserBuyItemHandler.NoGold";
				}
				if (specialValue.Money > client.Player.PlayerCharacter.Money)
				{
					translateId = "UserBuyItemHandler.NoMoney";
				}
				if (specialValue.Offer > client.Player.PlayerCharacter.Offer)
				{
					translateId = "UserBuyItemHandler.NoOffer";
				}
				if (specialValue.DDTMoney > client.Player.PlayerCharacter.DDTMoney)
				{
					translateId = "UserBuyItemHandler.GiftToken";
				}
				if (specialValue.Medal > client.Player.PlayerCharacter.medal)
				{
					translateId = "UserBuyItemHandler.Medal";
				}
				eMessageType = eMessageType.ERROR;
			}
			client.Out.SendMessage(eMessageType, LanguageMgr.GetTranslation(translateId));
			return 0;
		}
	}
}
