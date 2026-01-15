using System;
using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(121, "物品镶嵌")]
	public class BeadHandle : IPacketHandler
	{
		public static ThreadSafeRandom random;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			PlayerBeadInventory beadBag = client.Player.BeadBag;
			string text = "";
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			switch (b)
			{
			case 1:
			{
				int num5 = packet.ReadInt();
				int num6 = packet.ReadInt();
				int needLv = 10;
				if (num6 == -1 || num6 > beadBag.BeginSlot)
				{
					num6 = beadBag.FindFirstEmptySlot();
				}
				if (num6 <= 12 && num6 >= 4 && !beadBag.CheckEquipByLevel(num6, client.Player.PlayerCharacter.Grade, ref needLv))
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("BeadHandle.Msg2", needLv));
					beadBag.UpdateChangedPlaces();
					return 0;
				}
				ItemInfo ıtemAt = beadBag.GetItemAt(num5);
				ItemInfo ıtemAt2 = beadBag.GetItemAt(num6);
				if (ıtemAt == null)
				{
					beadBag.UpdateChangedPlaces();
					return 0;
				}
				if (ıtemAt.Hole1 == 1)
				{
					beadBag.UpdateChangedPlaces();
					return 0;
				}
				if (num6 <= 18 && num6 >= 13)
				{
					int drillLevel = beadBag.GetDrillLevel(num6);
					if (!beadBag.JudgeLevel(ıtemAt.Hole1, drillLevel) || (ıtemAt2 != null && !beadBag.JudgeLevel(ıtemAt2.Hole1, drillLevel)))
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("BeadHandle.Msg3"));
						beadBag.UpdateChangedPlaces();
						return 0;
					}
				}
				if (!beadBag.MoveItem(num5, num6, 1))
				{
					if (num6 > beadBag.BeginSlot)
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("BeadHandle.Msg4"));
					}
					else
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("BeadHandle.Msg5"));
					}
				}
				beadBag.UpdateChangedPlaces();
				client.Player.EquipBag.UpdatePlayerProperties();
				break;
			}
			case 2:
			{
				ItemInfo ıtemInfo = beadBag.GetItemAt(31);
				if (ıtemInfo == null)
				{
					return 0;
				}
				List<int> list = new List<int>();
				int num7 = packet.ReadInt();
				for (int j = 0; j < num7; j++)
				{
					int num8 = packet.ReadInt();
					ItemInfo ıtemAt3 = beadBag.GetItemAt(num8);
					if (ıtemAt3 == null || ıtemAt3.IsUsed)
					{
						continue;
					}
					list.Add(num8);
					int hole = ıtemInfo.Hole2;
					int hole2 = ıtemInfo.Hole1;
					int num9 = (ıtemInfo.Hole2 = ıtemAt3.Hole2 + hole);
					ıtemInfo.Hole1 = RuneMgr.GetRuneLevel(num9);
					ıtemInfo.IsBinds = true;
					bool flag2 = false;
					for (int k = hole2; k <= ıtemInfo.Hole1; k++)
					{
						RuneTemplateInfo runeTemplateInfo = RuneMgr.FindRuneByTemplateID(ıtemInfo.TemplateID);
						if (runeTemplateInfo != null)
						{
							int num11 = runeTemplateInfo.BaseLevel + 1;
							if (ıtemInfo.Hole1 > num11)
							{
								ıtemInfo.TemplateID = runeTemplateInfo.NextTemplateID;
								flag2 = true;
							}
						}
					}
					if (flag2)
					{
						ItemTemplateInfo goods = ItemMgr.FindItemTemplate(ıtemInfo.TemplateID);
						ItemInfo ıtemInfo2 = ItemInfo.CloneFromTemplate(goods, ıtemInfo);
						beadBag.RemoveItemAt(31);
						beadBag.AddItemTo(ıtemInfo2, 31);
						if (num9 > RuneMgr.MaxExp())
						{
							ıtemInfo2.Hole2 = RuneMgr.MaxExp();
						}
						else
						{
							ıtemInfo2.Hole2 = num9;
						}
						ıtemInfo = ıtemInfo2;
					}
					beadBag.UpdateItem(ıtemInfo);
				}
				beadBag.RemoveAllItem(list);
				beadBag.UpdateChangedPlaces();
				break;
			}
			case 3:
			{
				int num12 = packet.ReadInt();
				packet.ReadBoolean();
				bool flag3 = false;
				string[] array = GameProperties.OpenRunePackageMoney.Split('|');
				string[] array2 = GameProperties.RunePackageID.Split('|');
				string[] array3 = GameProperties.OpenRunePackageRange.Split('|');
				if (DateTime.Compare(client.Player.LastOpenPack.AddMilliseconds(500.0), DateTime.Now) > 0)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("BeadHandle.Msg6"));
					beadBag.UpdateChangedPlaces();
					return 0;
				}
				if (beadBag.FindFirstEmptySlot() == -1)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("BeadHandle.Msg9"));
					beadBag.UpdateChangedPlaces();
					return 0;
				}
				if (num12 < 0 || num12 > array.Length)
				{
					num12 = array.Length - 1;
				}
				if (client.Player.Extra.UseKingBless(3))
				{
					flag3 = true;
				}
				else if (client.Player.MoneyDirect(int.Parse(array[num12])))
				{
					flag3 = true;
				}
				if (flag3)
				{
					List<ItemInfo> list2 = new List<ItemInfo>();
					int dateId = int.Parse(array2[0]);
					string[] array4 = array3[2].Split(',');
					switch (num12)
					{
					case 1:
						array4 = array3[1].Split(',');
						dateId = int.Parse(array2[1]);
						break;
					case 2:
						array4 = array3[0].Split(',');
						dateId = int.Parse(array2[2]);
						break;
					case 3:
						dateId = int.Parse(array2[3]);
						break;
					}
					SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
					ItemBoxMgr.CreateItemBox(dateId, list2, ref specialValue);
					if (list2.Count < 1)
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("BeadHandle.Msg10"));
						return 0;
					}
					ItemInfo ıtemInfo3 = list2[0];
					ıtemInfo3.Count = 1;
					beadBag.AddItem(ıtemInfo3);
					RuneTemplateInfo runeTemplateInfo2 = RuneMgr.FindRuneByTemplateID(ıtemInfo3.TemplateID);
					if (runeTemplateInfo2 != null)
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("BeadHandle.Msg11", runeTemplateInfo2.Name, runeTemplateInfo2.BaseLevel));
						if (runeTemplateInfo2.BaseLevel > 13)
						{
							client.Player.SendItemNotice(ıtemInfo3, 4, "bead");
						}
					}
					int num13 = random.Next(int.Parse(array4[1]));
					if (num13 == 3 || num13 > 4)
					{
						num13 = 0;
					}
					client.Out.SendRuneOpenPackage(client.Player, num13);
				}
				beadBag.UpdateChangedPlaces();
				client.Player.LastOpenPack = DateTime.Now;
				break;
			}
			case 4:
			{
				int num5 = packet.ReadInt();
				ItemInfo ıtemAt3 = beadBag.GetItemAt(num5);
				if (ıtemAt3 == null)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("BeadHandle.Msg1"));
					return 0;
				}
				if (ıtemAt3.IsUsed)
				{
					ıtemAt3.IsUsed = false;
				}
				else
				{
					ıtemAt3.IsUsed = true;
				}
				beadBag.UpdateItem(ıtemAt3);
				break;
			}
			case 5:
			{
				int num = packet.ReadInt();
				int templateId = packet.ReadInt();
				int num2 = packet.ReadInt();
				if (DateTime.Compare(client.Player.LastDrillUpTime.AddMilliseconds(200.0), DateTime.Now) > 0)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("BeadHandle.Msg6"));
					return 0;
				}
				bool flag = false;
				PlayerInventory ınventory = client.Player.GetInventory(eBageType.PropBag);
				ItemInfo ıtemByTemplateID = ınventory.GetItemByTemplateID(0, templateId);
				UserDrillInfo userDrillInfo = beadBag.UserDrills[num];
				if (ıtemByTemplateID == null || userDrillInfo == null || !ıtemByTemplateID.isDrill(userDrillInfo.HoleLv))
				{
					client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("BeadHandle.Msg7"));
					return 0;
				}
				int ıtemCount = ınventory.GetItemCount(templateId);
				if (ıtemCount > 0 && num2 > 0)
				{
					if (ıtemCount < num2)
					{
						num2 = ıtemCount;
					}
					int num3 = 0;
					int i;
					for (i = 0; i < num2; i++)
					{
						int num4 = random.Next(2, 6);
						userDrillInfo.HoleExp += num4;
						num3 += num4;
						switch (userDrillInfo.HoleLv)
						{
						case 0:
							if (userDrillInfo.HoleExp >= GameProperties.HoleLevelUpExp(0))
							{
								userDrillInfo.HoleLv++;
								userDrillInfo.HoleExp = 0;
								flag = true;
							}
							break;
						case 1:
							if (userDrillInfo.HoleExp >= GameProperties.HoleLevelUpExp(1))
							{
								userDrillInfo.HoleLv++;
								userDrillInfo.HoleExp = 0;
								flag = true;
							}
							break;
						case 2:
							if (userDrillInfo.HoleExp >= GameProperties.HoleLevelUpExp(2))
							{
								userDrillInfo.HoleLv++;
								userDrillInfo.HoleExp = 0;
								flag = true;
							}
							break;
						case 3:
							if (userDrillInfo.HoleExp >= GameProperties.HoleLevelUpExp(3))
							{
								userDrillInfo.HoleLv++;
								userDrillInfo.HoleExp = 0;
								flag = true;
							}
							break;
						case 4:
							if (userDrillInfo.HoleExp >= GameProperties.HoleLevelUpExp(4))
							{
								userDrillInfo.HoleLv++;
								userDrillInfo.HoleExp = 0;
								flag = true;
							}
							break;
						}
						if (flag)
						{
							break;
						}
					}
					text = LanguageMgr.GetTranslation("OpenHoleHandler.GetExp", num3);
					beadBag.UpdateDrill(num, userDrillInfo);
					if (i < num2)
					{
						num2 = i;
					}
				}
				else
				{
					client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("BeadHandle.Msg8"));
				}
				if (text != "")
				{
					client.Out.SendMessage(eMessageType.Normal, text);
				}
				beadBag.SendPlayerDrill();
				ınventory.RemoveTemplate(templateId, num2);
				client.Player.LastDrillUpTime = DateTime.Now;
				if (!flag)
				{
					break;
				}
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					foreach (UserDrillInfo value in beadBag.UserDrills.Values)
					{
						playerBussiness.UpdateUserDrillInfo(value);
					}
				}
				break;
			}
			}
			return 0;
		}

		static BeadHandle()
		{
			random = new ThreadSafeRandom();
		}
	}
}
