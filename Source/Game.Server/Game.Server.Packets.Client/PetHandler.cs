using System;
using System.Collections.Generic;
using System.IO;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(68, "添加好友")]
	public class PetHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.PlayerCharacter.Grade < 25)
			{
				return 0;
			}
			byte b = packet.ReadByte();
			string msg = LanguageMgr.GetTranslation("PetHandler.Msg1");
			int num = -1;
			PetInventory petBag = client.Player.PetBag;
			int num2 = Convert.ToInt32(PetMgr.FindConfig("MaxLevel").Value);
			int num3 = ((client.Player.Level > num2) ? num2 : client.Player.Level);
			switch (b)
			{
			case 1:
				method_0(client, packet.ReadInt());
				return 0;
			case 2:
			{
				int place = packet.ReadInt();
				int bagType = packet.ReadInt();
				int ıD3 = client.Player.PlayerCharacter.ID;
				int num20 = petBag.FindFirstEmptySlot();
				if (client.Player.PlayerCharacter.Grade < 25)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg2"));
					return 0;
				}
				if (num20 == -1)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg3"));
					return 0;
				}
				ItemInfo ıtemAt2 = client.Player.GetItemAt((eBageType)bagType, place);
				PetTemplateInfo petTemplateInfo2 = PetMgr.FindPetTemplate(ıtemAt2.Template.Property5);
				if (petTemplateInfo2 == null)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg4"));
					return 0;
				}
				UsersPetinfo usersPetinfo2 = PetMgr.CreatePet(petTemplateInfo2, ıD3, num20, num3);
				usersPetinfo2.IsExit = true;
				usersPetinfo2.PetEquip = new List<ItemInfo>();
				petBag.AddPetTo(usersPetinfo2, num20);
				client.Player.RemoveCountFromStack(ıtemAt2, 1);
				if (petTemplateInfo2.StarLevel > 4)
				{
					string translation = LanguageMgr.GetTranslation("PetHandler.Msg5", client.Player.PlayerCharacter.NickName, petTemplateInfo2.Name, petTemplateInfo2.StarLevel);
					GSPacketIn packet2 = WorldMgr.SendSysNotice(translation);
					GameServer.Instance.LoginServer.SendPacket(packet2);
				}
				else
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg6", petTemplateInfo2.Name, petTemplateInfo2.StarLevel));
				}
				petBag.SaveToDatabase(saveAdopt: false);
				return 0;
			}
			case 4:
			{
				int place = packet.ReadInt();
				int bagType = packet.ReadInt();
				num = packet.ReadInt();
				bool flag3 = false;
				ItemInfo ıtemAt = client.Player.GetItemAt((eBageType)bagType, place);
				if (ıtemAt == null)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("PetHandler.Msg9"));
					return 0;
				}
				int num11 = Convert.ToInt32(PetMgr.FindConfig("MaxHunger").Value);
				UsersPetinfo petAt2 = petBag.GetPetAt(num);
				int num12 = ıtemAt.Count;
				int property = ıtemAt.Template.Property2;
				int property2 = ıtemAt.Template.Property1;
				int num13 = num12 * property2;
				int num14 = num13 + petAt2.Hunger;
				int num15 = num12 * property;
				msg = "";
				if (ıtemAt.TemplateID == 334100)
				{
					num15 = ıtemAt.DefendCompose;
				}
				if (petAt2.Level < num3)
				{
					num15 += petAt2.GP;
					int level = petAt2.Level;
					int level2 = PetMgr.GetLevel(num15, num3);
					int gP = PetMgr.GetGP(level2 + 1, num3);
					int gP2 = PetMgr.GetGP(num3, num3);
					int num16 = num15;
					if (num15 > gP2)
					{
						num15 -= gP2;
						if (num15 >= property && property != 0)
						{
							num12 -= (int)Math.Ceiling((double)num15 / (double)property);
						}
					}
					petAt2.GP = ((num16 >= gP2) ? gP2 : num16);
					petAt2.Level = level2;
					petAt2.MaxGP = ((gP == 0) ? gP2 : gP);
					petAt2.Hunger = ((num14 > num11) ? num11 : num14);
					flag3 = petBag.UpGracePet(petAt2, num, isUpdateProp: true, level, level2, num3, ref msg);
					if (ıtemAt.TemplateID == 334100)
					{
						client.Player.StoreBag.RemoveItem(ıtemAt);
					}
					else
					{
						client.Player.StoreBag.RemoveCountFromStack(ıtemAt, num12);
						client.Player.OnUsingItem(ıtemAt.TemplateID);
					}
				}
				else if (petAt2.Hunger < num11)
				{
					petAt2.Hunger = num14;
					client.Player.StoreBag.RemoveCountFromStack(ıtemAt, num12);
					flag3 = petBag.UpGracePet(petAt2, num, isUpdateProp: false, 0, 0, num3, ref msg);
					msg = LanguageMgr.GetTranslation("PetHandler.Msg10", num13);
				}
				else
				{
					msg = LanguageMgr.GetTranslation("PetHandler.Msg11");
				}
				if (flag3)
				{
					petBag.SaveToDatabase(saveAdopt: false);
				}
				if (!string.IsNullOrEmpty(msg))
				{
					client.Player.SendMessage(msg);
					return 0;
				}
				return 0;
			}
			case 5:
			{
				bool flag4 = packet.ReadBoolean();
				int num17 = Convert.ToInt32(PetMgr.FindConfig("AdoptRefereshCost").Value);
				int templateId = Convert.ToInt32(PetMgr.FindConfig("FreeRefereshID").Value);
				ItemInfo ıtemByTemplateID2 = client.Player.PropBag.GetItemByTemplateID(0, templateId);
				if (flag4)
				{
					bool flag5 = true;
					if (client.Player.Extra.UseKingBless(2))
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg12", num17));
						flag5 = false;
					}
					else
					{
						if (!client.Player.MoneyDirect(num17))
						{
							return 0;
						}
						if (ıtemByTemplateID2 != null)
						{
							client.Player.PropBag.RemoveTemplate(templateId, 1);
							flag5 = false;
						}
					}
					if (flag5)
					{
						client.Player.AddPetScore(num17 / 100);
					}
					List<UsersPetinfo> list = PetMgr.CreateAdoptList(client.Player.PlayerCharacter.ID, num3);
					client.Player.PetBag.ClearAdoptPets();
					foreach (UsersPetinfo item in list)
					{
						client.Player.PetBag.AddAdoptPetTo(item, item.Place);
					}
				}
				client.Player.Out.SendRefreshPet(client.Player, client.Player.PetBag.GetAdoptPet(), null, flag4);
				return 0;
			}
			case 6:
			{
				num = packet.ReadInt();
				int num25 = petBag.FindFirstEmptySlot();
				if (num25 == -1)
				{
					client.Out.SendRefreshPet(client.Player, petBag.GetAdoptPet(), null, refreshBtn: false);
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg15"));
					return 0;
				}
				if (num < 0)
				{
					client.Out.SendRefreshPet(client.Player, petBag.GetAdoptPet(), null, refreshBtn: false);
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg16"));
					return 0;
				}
				UsersPetinfo adoptPetAt = petBag.GetAdoptPetAt(num);
				adoptPetAt.PetEquip = new List<ItemInfo>();
				using (PlayerBussiness playerBussiness2 = new PlayerBussiness())
				{
					if (adoptPetAt.ID > 0)
					{
						playerBussiness2.RemoveUserAdoptPet(adoptPetAt.ID);
						adoptPetAt.ID = 0;
					}
				}
				petBag.RemoveAdoptPet(adoptPetAt);
				if (petBag.AddPetTo(adoptPetAt, num25))
				{
					PetTemplateInfo petTemplateInfo3 = PetMgr.FindPetTemplate(adoptPetAt.TemplateID);
					if (petTemplateInfo3.StarLevel > 3)
					{
						string translation2 = LanguageMgr.GetTranslation("PetHandler.Msg17", client.Player.PlayerCharacter.NickName, petTemplateInfo3.Name, petTemplateInfo3.StarLevel);
						GSPacketIn packet3 = WorldMgr.SendSysNotice(translation2);
						GameServer.Instance.LoginServer.SendPacket(packet3);
					}
					client.Player.OnAdoptPetEvent();
				}
				petBag.SaveToDatabase(saveAdopt: false);
				return 0;
			}
			case 7:
			{
				num = packet.ReadInt();
				int killId = packet.ReadInt();
				int killindex = packet.ReadInt();
				if (!petBag.EquipSkillPet(num, killId, killindex))
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg18"));
					return 0;
				}
				return 0;
			}
			case 8:
			{
				num = packet.ReadInt();
				UsersPetinfo petAt6 = petBag.GetPetAt(num);
				if (petBag.RemovePet(petAt6))
				{
					using PlayerBussiness playerBussiness3 = new PlayerBussiness();
					playerBussiness3.UpdateUserAdoptPet(petAt6.ID);
				}
				client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg19"));
				petBag.SaveToDatabase(saveAdopt: false);
				return 0;
			}
			case 9:
			{
				num = packet.ReadInt();
				string name = packet.ReadString();
				int value = Convert.ToInt32(PetMgr.FindConfig("ChangeNameCost").Value);
				if (client.Player.MoneyDirect(value))
				{
					if (petBag.RenamePet(num, name))
					{
						msg = LanguageMgr.GetTranslation("PetHandler.Msg20");
					}
					client.Player.SendMessage(msg);
					return 0;
				}
				return 0;
			}
			case 17:
			{
				num = packet.ReadInt();
				bool isEquip = packet.ReadBoolean();
				UsersPetinfo petAt3 = petBag.GetPetAt(num);
				if (petAt3 == null)
				{
					return 0;
				}
				if (petAt3.Level > num3 && !petAt3.IsEquip)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg21"));
					return 0;
				}
				if (petBag.EquipPet(num, isEquip))
				{
					client.Player.EquipBag.UpdatePlayerProperties();
					return 0;
				}
				client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg22"));
				return 0;
			}
			case 18:
			{
				num = packet.ReadInt();
				int value2 = Convert.ToInt32(PetMgr.FindConfig("RecycleCost").Value);
				if (client.Player.MoneyDirect(value2))
				{
					UsersPetinfo petAt4 = client.Player.PetBag.GetPetAt(num);
					if (petAt4 == null)
					{
						return 0;
					}
					UsersPetinfo usersPetinfo = new UsersPetinfo();
					int ıD = petAt4.ID;
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						usersPetinfo = playerBussiness.GetAdoptPetSingle(ıD);
					}
					if (usersPetinfo == null)
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg7"));
						return 0;
					}
					ItemTemplateInfo goods = ItemMgr.FindItemTemplate(334100);
					ItemInfo ıtemInfo3 = ItemInfo.CreateFromTemplate(goods, 1, 102);
					ıtemInfo3.IsBinds = true;
					ıtemInfo3.DefendCompose = petAt4.GP;
					ıtemInfo3.AgilityCompose = petAt4.MaxGP;
					if (!client.Player.PropBag.AddTemplate(ıtemInfo3, 1))
					{
						client.Player.SendItemToMail(ıtemInfo3, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), eMailType.ItemOverdue);
						client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
					}
					petAt4.Blood = usersPetinfo.Blood;
					petAt4.Attack = usersPetinfo.Attack;
					petAt4.Defence = usersPetinfo.Defence;
					petAt4.Agility = usersPetinfo.Agility;
					petAt4.Luck = usersPetinfo.Luck;
					int ıD2 = client.Player.PlayerCharacter.ID;
					int templateID2 = usersPetinfo.TemplateID;
					petAt4.TemplateID = templateID2;
					petAt4.Skill = usersPetinfo.Skill;
					petAt4.SkillEquip = usersPetinfo.SkillEquip;
					petAt4.GP = 0;
					petAt4.Level = 1;
					petAt4.MaxGP = 55;
					client.Player.PetEquipBag.ClearPetEquipByPetID(ıD);
					if (client.Player.PetBag.UpGracePet(petAt4, num, isUpdateProp: false, 0, 0, num3, ref msg))
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg8"));
					}
				}
				petBag.SaveToDatabase(saveAdopt: false);
				return 0;
			}
			case 19:
			{
				bool flag8 = packet.ReadBoolean();
				if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
					return 0;
				}
				UserFarmInfo currentFarm = client.Player.Farm.CurrentFarm;
				int buyExpRemainNum = currentFarm.buyExpRemainNum;
				PetExpItemPriceInfo petExpItemPriceInfo = PetMgr.FindPetExpItemPrice(method_2(buyExpRemainNum));
				if (petExpItemPriceInfo == null || buyExpRemainNum < 1)
				{
					return 0;
				}
				bool flag9 = false;
				int money = petExpItemPriceInfo.Money;
				if (flag8)
				{
					if (client.Player.MoneyDirect(money))
					{
						client.Player.AddExpVip(money);
						flag9 = true;
					}
				}
				else if (money <= client.Player.PlayerCharacter.DDTMoney)
				{
					client.Player.RemoveGiftToken(money);
					flag9 = true;
				}
				if (!flag9)
				{
					if (GameProperties.IsDDTMoneyActive)
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg13"));
					}
					else
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg14"));
					}
					return 0;
				}
				ItemTemplateInfo goods2 = ItemMgr.FindItemTemplate(334102);
				ItemInfo ıtemInfo6 = ItemInfo.CreateFromTemplate(goods2, petExpItemPriceInfo.ItemCount, 102);
				ıtemInfo6.IsBinds = true;
				client.Player.AddTemplate(ıtemInfo6, ıtemInfo6.Template.BagType, petExpItemPriceInfo.ItemCount, eGameView.RouletteTypeGet);
				currentFarm.buyExpRemainNum--;
				GSPacketIn gSPacketIn5 = new GSPacketIn(68);
				gSPacketIn5.WriteByte(19);
				gSPacketIn5.WriteInt(currentFarm.buyExpRemainNum);
				client.SendTCP(gSPacketIn5);
				client.Player.Farm.UpdateFarm(currentFarm);
				return 0;
			}
			case 20:
			{
				int bageType = packet.ReadInt();
				num = packet.ReadInt();
				int num21 = packet.ReadInt();
				UsersPetinfo petAt5 = petBag.GetPetAt(num21);
				if (petAt5 == null)
				{
					return 0;
				}
				PlayerInventory ınventory = client.Player.GetInventory((eBageType)bageType);
				ItemInfo ıtemAt3 = ınventory.GetItemAt(num);
				if (ıtemAt3 != null && client.Player.PetEquipBag.GetPetEquipByPetID(petAt5.ID, ıtemAt3.eqType()) == null && ıtemAt3.IsEquipPet())
				{
					ItemInfo ıtemInfo4 = ıtemAt3.Clone();
					ıtemInfo4.Bless = petAt5.ID;
					if (client.Player.PetEquipBag.AddItem(ıtemInfo4))
					{
						ınventory.TakeOutItem(ıtemAt3);
					}
					petBag.OnChangedPetEquip(num21);
					return 0;
				}
				return 0;
			}
			case 21:
			{
				int num26 = packet.ReadInt();
				num = packet.ReadInt();
				UsersPetinfo petAt7 = petBag.GetPetAt(num26);
				if (petAt7 == null)
				{
					return 0;
				}
				ItemInfo petEquipByPetID = client.Player.PetEquipBag.GetPetEquipByPetID(petAt7.ID, num);
				if (petEquipByPetID != null && petEquipByPetID.IsEquipPet())
				{
					ItemInfo ıtemInfo5 = petEquipByPetID.Clone();
					ıtemInfo5.Bless = 0;
					if (client.Player.EquipBag.AddItem(ıtemInfo5))
					{
						client.Player.PetEquipBag.TakeOutItem(petEquipByPetID);
					}
					petBag.OnChangedPetEquip(num26);
					return 0;
				}
				return 0;
			}
			case 22:
				client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg23"));
				return 0;
			case 23:
			{
				int num22 = packet.ReadInt();
				int num23 = packet.ReadInt();
				if (num22 != 11163)
				{
					return 0;
				}
				bool flag7 = client.Player.Extra.UseDeed(11);
				int num24 = 0;
				if (flag7)
				{
					num24 = 10;
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg24"));
				}
				ItemInfo ıtemByTemplateID4 = client.Player.GetItemByTemplateID(num22);
				if (!flag7 && ıtemByTemplateID4 != null && num23 > 0 && num22 == 11163)
				{
					if (ıtemByTemplateID4.Count < num23)
					{
						num23 = ıtemByTemplateID4.Count;
					}
					num24 = ıtemByTemplateID4.Template.Property2 * num23;
					client.Player.RemoveTemplate(num22, num23);
				}
				if (num24 <= 0)
				{
					return 0;
				}
				bool val = false;
				int evolutionGrade = client.Player.PlayerCharacter.evolutionGrade;
				int evolutionExp = client.Player.PlayerCharacter.evolutionExp;
				int evolutionGP = PetMgr.GetEvolutionGP(evolutionGrade);
				if (evolutionGP < 0)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg25"));
					return 0;
				}
				if (evolutionGP < num24 + evolutionExp)
				{
					num23 = (evolutionGP - evolutionExp) / ıtemByTemplateID4.Template.Property2;
					num24 = ıtemByTemplateID4.Template.Property2 * num23;
				}
				client.Player.PlayerCharacter.evolutionExp += num24;
				int evolutionGrade2 = PetMgr.GetEvolutionGrade(client.Player.PlayerCharacter.evolutionExp);
				if (evolutionGrade < evolutionGrade2)
				{
					client.Player.PlayerCharacter.evolutionGrade = evolutionGrade2;
					val = true;
					client.Player.EquipBag.UpdatePlayerProperties();
				}
				client.Player.SendUpdatePublicPlayer();
				GSPacketIn gSPacketIn4 = new GSPacketIn(68, client.Player.PlayerId);
				gSPacketIn4.WriteByte(23);
				gSPacketIn4.WriteBoolean(val);
				client.Player.SendTCP(gSPacketIn4);
				return 0;
			}
			case 24:
			{
				GSPacketIn gSPacketIn3 = new GSPacketIn(68, client.Player.PlayerId);
				gSPacketIn3.WriteByte(24);
				List<PetFormActiveListInfo> activeList = client.Player.PetBag.ActiveList;
				gSPacketIn3.WriteInt(activeList.Count);
				foreach (PetFormActiveListInfo item2 in activeList)
				{
					gSPacketIn3.WriteInt(item2.TemplateID);
				}
				client.Player.SendTCP(gSPacketIn3);
				return 0;
			}
			case 25:
			{
				bool flag6 = packet.ReadBoolean();
				int num19 = packet.ReadInt();
				GSPacketIn gSPacketIn2 = new GSPacketIn(68, client.Player.PlayerId);
				gSPacketIn2.WriteByte(25);
				gSPacketIn2.WriteBoolean(flag6);
				gSPacketIn2.WriteInt(num19);
				client.Player.SendTCP(gSPacketIn2);
				client.Player.PetBag.PetFormFollow(num19, flag6);
				return 0;
			}
			case 32:
			{
				int num18 = packet.ReadInt();
				ItemInfo ıtemByTemplateID3 = client.Player.PropBag.GetItemByTemplateID(num18);
				if (ıtemByTemplateID3 == null)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.WakeFail"));
					return 0;
				}
				PetFormDataInfo petFormDataInfo = PetMgr.FindPetFormData(ıtemByTemplateID3.TemplateID);
				if (petFormDataInfo != null)
				{
					GSPacketIn gSPacketIn = new GSPacketIn(68, client.Player.PlayerId);
					gSPacketIn.WriteByte(32);
					gSPacketIn.WriteInt(num18);
					client.Player.SendTCP(gSPacketIn);
					client.Player.PetBag.AddPetForm(num18);
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.WakeSuccess", petFormDataInfo.Name));
					client.Player.PropBag.RemoveTemplate(num18, 1);
					return 0;
				}
				client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.WakeFail"));
				return 0;
			}
			case 33:
			{
				int num4 = packet.ReadInt();
				int num5 = packet.ReadInt();
				int num6 = 0;
				int num7 = 201567;
				if (num5 == 1)
				{
					int num8 = packet.ReadInt();
					for (int i = 0; i < num8; i++)
					{
						int slot = packet.ReadInt();
						int templateID = packet.ReadInt();
						UsersPetinfo petAt = client.Player.PetBag.GetPetAt(slot);
						if (petAt != null)
						{
							PetTemplateInfo petTemplateInfo = PetMgr.FindPetTemplate(templateID);
							if (petTemplateInfo != null)
							{
								num6 += (int)(Math.Pow(10.0, petTemplateInfo.StarLevel - 2) + 5.0 * Math.Max(petAt.Level - 8, (double)petAt.Level * 0.2));
							}
						}
						client.Player.PetBag.RemovePet(petAt);
					}
				}
				else
				{
					int num8 = packet.ReadInt();
					ItemInfo ıtemByTemplateID = client.Player.GetItemByTemplateID(num7);
					if (ıtemByTemplateID != null)
					{
						if (ıtemByTemplateID.Count < num8)
						{
							num8 = ıtemByTemplateID.Count;
						}
						num6 += ıtemByTemplateID.Template.Property2 * num8;
						client.Player.RemoveTemplate(num7, num8);
					}
				}
				if (num6 <= 0)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.EatPetNotEnoughtCount"));
					return 0;
				}
				int num9 = 0;
				int num10 = PetMoePropertyMgr.FindMaxLevel();
				bool flag = false;
				bool flag2 = false;
				switch (num4)
				{
				case 0:
				{
					num9 = client.Player.PetBag.EatPets.weaponExp + num6;
					int hatLevel = client.Player.PetBag.EatPets.weaponLevel;
					for (int l = hatLevel; l <= num10; l++)
					{
						PetMoePropertyInfo petMoePropertyInfo3 = PetMoePropertyMgr.FindPetMoeProperty(l + 1);
						if (petMoePropertyInfo3 != null && petMoePropertyInfo3.Exp <= num9)
						{
							client.Player.PetBag.EatPets.weaponLevel = l + 1;
							num9 -= petMoePropertyInfo3.Exp;
							flag2 = true;
						}
					}
					if (client.Player.PetBag.EatPets.weaponLevel == num10)
					{
						client.Player.PetBag.EatPets.weaponExp = 0;
						flag = true;
					}
					else
					{
						client.Player.PetBag.EatPets.weaponExp = num9;
					}
					break;
				}
				case 1:
				{
					num9 = client.Player.PetBag.EatPets.clothesExp + num6;
					int hatLevel = client.Player.PetBag.EatPets.clothesLevel;
					for (int k = hatLevel; k <= num10; k++)
					{
						PetMoePropertyInfo petMoePropertyInfo2 = PetMoePropertyMgr.FindPetMoeProperty(k + 1);
						if (petMoePropertyInfo2 != null && petMoePropertyInfo2.Exp <= num9)
						{
							client.Player.PetBag.EatPets.clothesLevel = k + 1;
							num9 -= petMoePropertyInfo2.Exp;
							flag2 = true;
						}
					}
					if (client.Player.PetBag.EatPets.clothesLevel == num10)
					{
						client.Player.PetBag.EatPets.clothesExp = 0;
						flag = true;
					}
					else
					{
						client.Player.PetBag.EatPets.clothesExp = num9;
					}
					break;
				}
				case 2:
				{
					num9 = client.Player.PetBag.EatPets.hatExp + num6;
					int hatLevel = client.Player.PetBag.EatPets.hatLevel;
					for (int j = hatLevel; j <= num10; j++)
					{
						PetMoePropertyInfo petMoePropertyInfo = PetMoePropertyMgr.FindPetMoeProperty(j + 1);
						if (petMoePropertyInfo != null && petMoePropertyInfo.Exp <= num9)
						{
							client.Player.PetBag.EatPets.hatLevel = j + 1;
							num9 -= petMoePropertyInfo.Exp;
							flag2 = true;
						}
					}
					if (client.Player.PetBag.EatPets.hatLevel == num10)
					{
						client.Player.PetBag.EatPets.hatExp = 0;
						flag = true;
					}
					else
					{
						client.Player.PetBag.EatPets.hatExp = num9;
					}
					break;
				}
				}
				if (flag2)
				{
					client.Player.EquipBag.UpdatePlayerProperties();
				}
				if (num5 == 2 && flag)
				{
					ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(num7);
					if (ıtemTemplateInfo != null && num9 > ıtemTemplateInfo.Property2)
					{
						int num8 = num9 / ıtemTemplateInfo.Property2;
						if (num8 > ıtemTemplateInfo.MaxCount)
						{
							for (int m = 0; m < num8; m++)
							{
								if (m > ıtemTemplateInfo.MaxCount || m > num8)
								{
									ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, m - 1, 105);
									ıtemInfo.IsBinds = true;
									client.Player.AddTemplate(ıtemInfo);
								}
							}
						}
						else
						{
							ItemInfo ıtemInfo2 = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, num8, 105);
							ıtemInfo2.IsBinds = true;
							client.Player.AddTemplate(ıtemInfo2);
						}
					}
				}
				client.Player.Out.SendEatPetsInfo(client.Player.PetBag.EatPets);
				return 0;
			}
			default:
				Console.WriteLine("pet_cmd: " + (PetPackageType)b);
				return 0;
			}
		}

		private void method_0(GameClient gameClient_0, int int_0)
		{
			GamePlayer playerById = WorldMgr.GetPlayerById(int_0);
			UsersPetinfo[] array;
			if (playerById != null)
			{
				array = playerById.PetBag.GetPets();
			}
			else
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				array = playerBussiness.GetUserPetSingles(int_0);
				ItemInfo[] userBagByType = playerBussiness.GetUserBagByType(int_0, 5012);
				for (int i = 0; i < array.Length; i++)
				{
					array[i].PetEquip = method_1(array[i].ID, userBagByType);
				}
			}
			if (array != null)
			{
				gameClient_0.Out.SendPetInfo(int_0, gameClient_0.Player.ZoneId, array);
			}
		}

		private List<ItemInfo> method_1(int int_0, ItemInfo[] itemInfo_0)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			foreach (ItemInfo ıtemInfo in itemInfo_0)
			{
				if (int_0 == ıtemInfo.Bless)
				{
					list.Add(ıtemInfo);
				}
			}
			return list;
		}

		private int method_2(int int_0)
		{
			return int_0 switch
			{
				1 => 20, 
				2 => 19, 
				3 => 18, 
				4 => 17, 
				5 => 16, 
				6 => 15, 
				7 => 14, 
				8 => 13, 
				9 => 12, 
				10 => 11, 
				11 => 10, 
				12 => 9, 
				13 => 8, 
				14 => 7, 
				15 => 6, 
				16 => 5, 
				17 => 4, 
				18 => 3, 
				19 => 2, 
				_ => 1, 
			};
		}

		public static void Log(string logMessage, TextWriter w)
		{
			w.WriteLine("  {0}", logMessage);
		}
	}
}
