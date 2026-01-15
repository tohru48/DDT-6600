using System;
using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(183, "卡片使用")]
	public class CardUseHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			ItemInfo ıtemInfo = null;
			ShopItemInfo shopItemInfo = new ShopItemInfo();
			List<ItemInfo> list = new List<ItemInfo>();
			if (DateTime.Compare(client.Player.LastOpenCard.AddSeconds(1.0), DateTime.Now) > 0)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CardUseHandler.ManyAction"));
				return 0;
			}
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			if (num == -1 && num2 == -1)
			{
				int num3 = packet.ReadInt();
				int num4 = packet.ReadInt();
				int num5 = packet.ReadInt();
				int num6 = 0;
				int value = 0;
				Console.WriteLine($"Count {num3} templateID {num4} type {num5}");
				for (int i = 0; i < num3; i++)
				{
					shopItemInfo = ShopMgr.FindShopbyTemplateID(num4);
					if (shopItemInfo != null)
					{
						ItemTemplateInfo goods = ItemMgr.FindItemTemplate(shopItemInfo.TemplateID);
						ıtemInfo = ItemInfo.CreateFromTemplate(goods, 1, 102);
						value = shopItemInfo.AValue1;
						ıtemInfo.ValidDate = shopItemInfo.AUnit;
					}
					if (ıtemInfo != null)
					{
						if (num6 <= client.Player.PlayerCharacter.Gold && client.Player.MoneyDirect(value))
						{
							client.Player.RemoveGold(num6);
							list.Add(ıtemInfo);
						}
					}
					else
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CardUseHandler.Fail"));
					}
				}
			}
			else
			{
				PlayerInventory ınventory = client.Player.GetInventory((eBageType)num);
				ıtemInfo = ınventory.GetItemAt(num2);
				if (ıtemInfo != null)
				{
					list.Add(ıtemInfo);
				}
				string translateId = "CardUseHandler.Success";
				if (list.Count > 0)
				{
					string translateId2 = string.Empty;
					foreach (ItemInfo item in list)
					{
						if (item.Template.Property1 != 13 && item.Template.Property1 != 11 && item.Template.Property1 != 12 && item.Template.Property1 != 26)
						{
							if (item.Template.Property5 == 3)
							{
								if (item.ValidDate != 30)
								{
									item.ValidDate = item.Template.Property5 * 10;
								}
								AbstractBuffer abstractBuffer = BufferList.CreateBufferMinutes(item.Template, item.ValidDate);
								if (abstractBuffer != null)
								{
									abstractBuffer.Start(client.Player);
									if (num2 != -1 && num != -1)
									{
										ınventory = client.Player.GetInventory((eBageType)num);
										ınventory.RemoveCountFromStack(item, 1);
									}
								}
								client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(translateId));
								continue;
							}
							if (item.IsValidItem() && item.Template.Property1 == 21)
							{
								if (item.TemplateID == 201145)
								{
									int min = item.Template.Property2 * ıtemInfo.Count;
									client.Player.Actives.AddTime(min);
									translateId2 = "TimerDanUser.Success";
								}
								else
								{
									int num7 = item.Template.Property2 * ıtemInfo.Count;
									if (client.Player.Level == LevelMgr.MaxLevel)
									{
										int num8 = num7 / 100;
										if (num8 > 0)
										{
											client.Player.AddOffer(num8);
											translateId2 = LanguageMgr.GetTranslation("CardUseHandler.MaxExp", num8);
										}
									}
									else
									{
										client.Player.AddGP(num7);
										translateId2 = "GPDanUser.Success";
									}
								}
								if (item.Template.CanDelete)
								{
									client.Player.RemoveAt((eBageType)num, num2);
								}
							}
							client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(translateId2, ıtemInfo.Template.Property2 * ıtemInfo.Count));
							continue;
						}
						AbstractBuffer abstractBuffer2 = BufferList.CreateBuffer(item.Template, (item.ValidDate == 0) ? 1 : item.ValidDate);
						if (abstractBuffer2 != null)
						{
							abstractBuffer2.Start(client.Player);
							if (num2 != -1 && num != -1)
							{
								ınventory = client.Player.GetInventory((eBageType)num);
								ınventory.RemoveCountFromStack(item, 1);
							}
						}
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(translateId));
					}
				}
				else
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CardUseHandler.Fail"));
				}
			}
			client.Player.LastOpenCard = DateTime.Now;
			return 0;
		}
	}
}
