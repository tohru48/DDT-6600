using System;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(192, "添加拍卖")]
	public class AuctionAddHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			eBageType bagType = (eBageType)packet.ReadByte();
			int place = packet.ReadInt();
			int num = packet.ReadByte();
			int num2 = packet.ReadInt();
			int num3 = packet.ReadInt();
			int num4 = packet.ReadInt();
			int num5 = packet.ReadInt();
			if (client.Player.IsLimitAuction())
			{
				return 0;
			}
			string translateId = "AuctionAddHandler.Fail";
			num = 1;
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			if (num2 < 0 || (num3 != 0 && num3 < num2))
			{
				return 0;
			}
			int num6 = 1;
			if (num != 0)
			{
				num6 = 1;
				num = 1;
			}
			int num7 = (int)((double)(num6 * num2) * 0.03 * (double)(num4 switch
			{
				1 => 3, 
				0 => 1, 
				_ => 6, 
			}));
			num7 = ((num7 < 1) ? 1 : num7);
			ItemInfo ıtemAt = client.Player.GetItemAt(bagType, place);
			if (ıtemAt == null)
			{
				client.Player.SendMessage(LanguageMgr.GetTranslation("AuctionAddHandler.Msg13"));
				return 0;
			}
			if (ıtemAt.Count < num5 || num5 < 0)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("AuctionAddHandler.Msg11"));
				return 0;
			}
			if (client.Player.IsLimitCount(num5))
			{
				return 0;
			}
			int num8 = ıtemAt.Count - num5;
			int num9 = GameProperties.LimitLevel(1);
			if (client.Player.PlayerCharacter.Grade < num9)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("AuctionAddHandler.Msg12", num9));
				return 0;
			}
			if (num2 < 0)
			{
				translateId = "AuctionAddHandler.Msg1";
			}
			else if (num3 != 0 && num3 < num2)
			{
				translateId = "AuctionAddHandler.Msg2";
			}
			else if (num7 > client.Player.PlayerCharacter.Gold)
			{
				translateId = "AuctionAddHandler.Msg3";
			}
			else if (ıtemAt == null)
			{
				translateId = "AuctionAddHandler.Msg4";
			}
			else if (ıtemAt.IsBinds)
			{
				translateId = "AuctionAddHandler.Msg5";
			}
			else
			{
				ItemInfo ıtemInfo = ItemInfo.CloneFromTemplate(ıtemAt.Template, ıtemAt);
				ItemInfo ıtemInfo2 = ItemInfo.CloneFromTemplate(ıtemAt.Template, ıtemAt);
				ıtemInfo2.Count = num5;
				if (ıtemInfo2.ItemID == 0)
				{
					using PlayerBussiness playerBussiness = new PlayerBussiness();
					playerBussiness.AddGoods(ıtemInfo2);
				}
				AuctionInfo auctionInfo = new AuctionInfo();
				auctionInfo.AuctioneerID = client.Player.PlayerCharacter.ID;
				auctionInfo.AuctioneerName = client.Player.PlayerCharacter.NickName;
				auctionInfo.BeginDate = DateTime.Now;
				auctionInfo.BuyerID = 0;
				auctionInfo.BuyerName = "";
				auctionInfo.IsExist = true;
				auctionInfo.ItemID = ıtemInfo2.ItemID;
				auctionInfo.Mouthful = num3;
				auctionInfo.PayType = num;
				auctionInfo.Price = num2;
				auctionInfo.Rise = num2 / 10;
				auctionInfo.Rise = ((auctionInfo.Rise < 1) ? 1 : auctionInfo.Rise);
				auctionInfo.Name = ıtemInfo2.Template.Name;
				auctionInfo.Category = ıtemInfo2.Template.CategoryID;
				auctionInfo.ValidDate = num4 switch
				{
					1 => 24, 
					0 => 8, 
					_ => 48, 
				};
				auctionInfo.TemplateID = ıtemInfo2.TemplateID;
				auctionInfo.goodsCount = num5;
				auctionInfo.Random = ThreadSafeRandom.NextStatic(GameProperties.BeginAuction, GameProperties.EndAuction);
				using PlayerBussiness playerBussiness2 = new PlayerBussiness();
				if (playerBussiness2.AddAuction(auctionInfo))
				{
					client.Player.RemoveAt(bagType, place);
					if (num8 > 0)
					{
						ıtemInfo.Count = num8;
						client.Player.AddTemplate(ıtemInfo, bagType, num8, eGameView.CaddyTypeGet);
					}
					client.Player.RemoveGold(num7);
					translateId = "AuctionAddHandler.Msg6";
					client.Out.SendAuctionRefresh(auctionInfo, auctionInfo.AuctionID, isExist: true, ıtemInfo2);
				}
			}
			client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(translateId));
			return 0;
		}
	}
}
