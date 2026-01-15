using System;
using System.Collections.Generic;
using Bussiness.Managers;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerEquipInventory : PlayerInventory
	{
		public static readonly ILog log;

		public PlayerEquipInventory(GamePlayer player)
			: base(player, saveTodb: true, 80, 0, 31, autoStack: true)
		{
		}

		public override void LoadFromDatabase()
		{
			BeginChanges();
			try
			{
				base.LoadFromDatabase();
				List<ItemInfo> list = new List<ItemInfo>();
				for (int i = 0; i < 31; i++)
				{
					ItemInfo ıtemInfo = m_items[i];
					if (ıtemInfo == null)
					{
						continue;
					}
					if (ıtemInfo.Template == null)
					{
						log.ErrorFormat("Load Item from database of account {0} with tempalteId {1} place {2}", m_player.Account, ıtemInfo.TemplateID, ıtemInfo.Place);
					}
					else if (ıtemInfo.Template != null && ıtemInfo.IsEquipPet() && ıtemInfo.Place < 31)
					{
						ItemInfo item = ıtemInfo.Clone();
						list.Add(item);
						TakeOutItem(ıtemInfo);
					}
					else if (!CanEquipSlotContains(ıtemInfo.Place, ıtemInfo.Template))
					{
						ItemInfo item2 = ıtemInfo.Clone();
						list.Add(item2);
						TakeOutItem(ıtemInfo);
					}
					else
					{
						if (ıtemInfo.IsValidItem())
						{
							continue;
						}
						if (ıtemInfo.isDress())
						{
							int num = m_player.AvatarBag.FindFirstEmptySlot(80);
							if (num > 0)
							{
								ItemInfo item3 = ıtemInfo.Clone();
								if (m_player.AvatarBag.AddItemTo(item3, num))
								{
									TakeOutItem(ıtemInfo);
								}
							}
							else
							{
								ItemInfo item4 = ıtemInfo.Clone();
								list.Add(item4);
								TakeOutItem(ıtemInfo);
							}
						}
						else
						{
							int num2 = FindFirstEmptySlot(31);
							if (num2 > 0)
							{
								MoveItem(ıtemInfo.Place, num2, ıtemInfo.Count);
							}
							else
							{
								list.Add(ıtemInfo);
							}
						}
					}
				}
				if (list.Count > 0)
				{
					m_player.SendItemsToMail(list, null, "Vật phẩm hết hạn trả về thư.", eMailType.ItemOverdue);
					m_player.Out.SendMailResponse(m_player.PlayerCharacter.ID, eMailRespose.Receiver);
				}
			}
			finally
			{
				CommitChanges();
			}
		}

		public override bool MoveItem(int fromSlot, int toSlot, int count)
		{
			if (m_items[fromSlot] == null)
			{
				return false;
			}
			if (IsEquipSlot(fromSlot) && !IsEquipSlot(toSlot) && m_items[toSlot] != null && m_items[toSlot].Template.CategoryID != m_items[fromSlot].Template.CategoryID)
			{
				if (!CanEquipSlotContains(fromSlot, m_items[toSlot].Template))
				{
					toSlot = FindFirstEmptySlot(base.BeginSlot);
				}
			}
			else
			{
				if (IsEquipSlot(toSlot))
				{
					if (!CanEquipSlotContains(toSlot, m_items[fromSlot].Template))
					{
						UpdateItem(m_items[fromSlot]);
						return false;
					}
					if (!m_player.CanEquip(m_items[fromSlot].Template) || !m_items[fromSlot].IsValidItem())
					{
						UpdateItem(m_items[fromSlot]);
						return false;
					}
				}
				if (IsEquipSlot(fromSlot) && m_items[toSlot] != null && (!CanEquipSlotContains(fromSlot, m_items[toSlot].Template) || !m_items[toSlot].IsValidItem()))
				{
					UpdateItem(m_items[toSlot]);
					return false;
				}
			}
			return base.MoveItem(fromSlot, toSlot, count);
		}

		public override void UpdateChangedPlaces()
		{
			int[] array = m_changedPlaces.ToArray();
			bool flag = false;
			int[] array2 = array;
			foreach (int slot in array2)
			{
				if (!IsEquipSlot(slot))
				{
					continue;
				}
				ItemInfo ıtemAt = GetItemAt(slot);
				if (ıtemAt != null)
				{
					m_player.OnUsingItem(ıtemAt.TemplateID);
					ıtemAt.IsBinds = true;
					if (!ıtemAt.IsUsed)
					{
						ıtemAt.IsUsed = true;
						ıtemAt.BeginDate = DateTime.Now;
					}
				}
				flag = true;
				break;
			}
			base.UpdateChangedPlaces();
			if (flag)
			{
				UpdatePlayerProperties();
			}
		}

		public void UpdatePlayerProperties()
		{
			m_player.BeginChanges();
			try
			{
				string text = "";
				string text2 = "";
				string skin = "";
				int attack = 0;
				int defence = 0;
				int agility = 0;
				int lucky = 0;
				int hp = 0;
				int num = 0;
				int num2 = 0;
				int num3 = 0;
				int attack2 = 0;
				int defence2 = 0;
				int agility2 = 0;
				int lucky2 = 0;
				int hp2 = 0;
				int num4 = 0;
				int num5 = 0;
				int num6 = 0;
				int num7 = 0;
				int num8 = 0;
				int num9 = 0;
				int num10 = 0;
				int num11 = 0;
				int num12 = 0;
				int num13 = 0;
				int num14 = 0;
				int num15 = 0;
				int num16 = 0;
				int num17 = 0;
				int attack3 = 0;
				int defence3 = 0;
				int agility3 = 0;
				int lucky3 = 0;
				int hp3 = 0;
				int att = 0;
				int def = 0;
				int agi = 0;
				int luk = 0;
				int hp4 = 0;
				int num18 = 0;
				int num19 = 0;
				int num20 = 0;
				int num21 = 0;
				int num22 = 0;
				int num23 = 0;
				int num24 = 0;
				int num25 = 0;
				int num26 = 0;
				int num27 = 0;
				int num28 = 0;
				int num29 = 0;
				int num30 = 0;
				int num31 = 0;
				m_player.UpdatePet(m_player.PetBag.GetPetIsEquip());
				List<UsersCardInfo> cards = m_player.CardBag.GetCards(0, 5);
				lock (m_lock)
				{
					text = ((m_items[0] == null) ? "" : (m_items[0].TemplateID + "|" + m_items[0].Pic));
					text2 = ((m_items[0] == null) ? "" : m_items[0].Color);
					skin = ((m_items[5] == null) ? "" : m_items[5].Skin);
					for (int i = 0; i < 31; i++)
					{
						ItemInfo ıtemInfo = m_items[i];
						if (ıtemInfo != null && !ıtemInfo.IsEquipPet())
						{
							attack += ıtemInfo.Attack;
							defence += ıtemInfo.Defence;
							agility += ıtemInfo.Agility;
							lucky += ıtemInfo.Luck;
							num3 = ((num3 > ıtemInfo.StrengthenLevel) ? num3 : ıtemInfo.StrengthenLevel);
							AddBaseLatentProperty(ıtemInfo, ref attack, ref defence, ref agility, ref lucky);
							AddBaseGemstoneProperty(ıtemInfo, ref attack2, ref defence2, ref agility2, ref lucky2, ref hp2);
							SubActiveConditionInfo subActiveInfo = SubActiveMgr.GetSubActiveInfo(ıtemInfo);
							if (subActiveInfo != null)
							{
								attack += subActiveInfo.GetValue("1");
								defence += subActiveInfo.GetValue("2");
								agility += subActiveInfo.GetValue("3");
								lucky += subActiveInfo.GetValue("4");
								hp += subActiveInfo.GetValue("5");
							}
							ItemInfo ıtemAt = m_player.MagicStoneBag.GetItemAt(i);
							if (ıtemAt != null)
							{
								num18 += ıtemAt.AttackCompose;
								num19 += ıtemAt.DefendCompose;
								num20 += ıtemAt.AgilityCompose;
								num21 += ıtemAt.LuckCompose;
								num22 += ıtemAt.MagicAttack;
								num23 += ıtemAt.MagicDefence;
							}
							switch (i)
							{
							case 7:
							case 8:
							case 9:
							case 10:
							case 16:
								if (ıtemInfo.IsEnchant())
								{
									MagicItemTemplateInfo magicItemTemplateInfo = MagicItemTemplateMgr.FindMagicItemTemplate(ıtemInfo.MagicLevel);
									if (magicItemTemplateInfo != null)
									{
										num30 += magicItemTemplateInfo.MagicDefence;
										num31 += magicItemTemplateInfo.MagicAttack;
									}
								}
								break;
							}
						}
						if (ıtemInfo != null && ıtemInfo.IsEquipPet())
						{
							RemoveItem(ıtemInfo);
						}
						AddBeadProperty(i, ref attack3, ref defence3, ref agility3, ref lucky3, ref hp3);
					}
					AddBaseTotemProperty(m_player.PlayerCharacter, ref attack, ref defence, ref agility, ref lucky, ref hp);
					if (m_player.Pet != null)
					{
						num8 += m_player.Pet.TotalAttack;
						num9 += m_player.Pet.TotalDefence;
						num10 += m_player.Pet.TotalAgility;
						num11 += m_player.Pet.TotalLuck;
						num12 += m_player.Pet.TotalBlood;
						PetFightPropertyInfo petFightPropertyInfo = PetMgr.FindFightProperty(m_player.PlayerCharacter.evolutionGrade);
						if (petFightPropertyInfo != null)
						{
							num8 += petFightPropertyInfo.Attack;
							num9 += petFightPropertyInfo.Defence;
							num10 += petFightPropertyInfo.Agility;
							num11 += petFightPropertyInfo.Lucky;
							num12 += petFightPropertyInfo.Blood;
						}
					}
					EatPetsInfo eatPets = m_player.PetBag.EatPets;
					if (eatPets != null)
					{
						PetMoePropertyInfo petMoePropertyInfo = PetMoePropertyMgr.FindPetMoeProperty(eatPets.weaponLevel);
						if (petMoePropertyInfo != null)
						{
							num8 += petMoePropertyInfo.Attack;
							num11 += petMoePropertyInfo.Lucky;
						}
						petMoePropertyInfo = PetMoePropertyMgr.FindPetMoeProperty(eatPets.clothesLevel);
						if (petMoePropertyInfo != null)
						{
							num10 += petMoePropertyInfo.Agility;
							num12 += petMoePropertyInfo.Blood;
						}
						petMoePropertyInfo = PetMoePropertyMgr.FindPetMoeProperty(eatPets.hatLevel);
						if (petMoePropertyInfo != null)
						{
							num9 += petMoePropertyInfo.Defence;
						}
					}
					NewTitleInfo newTitleInfo = NewTitleMgr.FindNewTitle(m_player.PlayerCharacter.honorId);
					if (newTitleInfo != null)
					{
						attack += newTitleInfo.Att;
						defence += newTitleInfo.Def;
						agility += newTitleInfo.Agi;
						lucky += newTitleInfo.Luck;
					}
					foreach (UsersCardInfo item in cards)
					{
						num4 += CardMgr.GetProp(item, 0);
						num5 += CardMgr.GetProp(item, 1);
						num6 += CardMgr.GetProp(item, 2);
						num7 += CardMgr.GetProp(item, 3);
						if (item.CardID > 0)
						{
							num4 += item.Attack;
							num5 += item.Defence;
							num6 += item.Agility;
							num7 += item.Luck;
						}
						if (item.TemplateID > 0)
						{
							CardTemplateInfo cardTemplateInfo = CardMgr.FindCardTemplate(item.TemplateID, item.CardType);
							if (cardTemplateInfo != null)
							{
								num4 += cardTemplateInfo.AddAttack;
								num5 += cardTemplateInfo.AddDefend;
								num6 += cardTemplateInfo.AddAgility;
								num7 += cardTemplateInfo.AddLucky;
							}
						}
					}
					num13 += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.attTexpExp, "A");
					num14 += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.defTexpExp, "D");
					num15 += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.spdTexpExp, "AG");
					num16 += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.lukTexpExp, "L");
					num17 += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.hpTexpExp, "H");
					EquipBeadEffect();
					int[] equipPlace = m_player.EquipPlace;
					for (int j = 0; j < equipPlace.Length; j++)
					{
						text += ",";
						text2 += ",";
						if (m_items[equipPlace[j]] != null)
						{
							object obj = text;
							text = string.Concat(obj, m_items[equipPlace[j]].TemplateID, "|", m_items[equipPlace[j]].Pic);
							text2 += m_items[equipPlace[j]].Color;
						}
					}
				}
				m_player.AvatarBag.AddPropAvatarColection(ref att, ref def, ref agi, ref luk, ref hp4);
				if (m_player.Horse.Info.curUseHorse > 0)
				{
					int curLevel = m_player.Horse.Info.curLevel;
					MountTemplateInfo mountTemplate = MountMgr.GetMountTemplate(curLevel);
					num24 += mountTemplate.MagicAttack;
					num25 += mountTemplate.MagicDefence;
					num26 = mountTemplate.AddBlood;
				}
				MountDrawDataInfo[] getPicCherishs = m_player.Horse.GetPicCherishs;
				MountDrawDataInfo[] array = getPicCherishs;
				foreach (MountDrawDataInfo mountDrawDataInfo in array)
				{
					MountDrawTemplateInfo mountDrawTemplateInfo = MountMgr.FindMountDrawInfo(mountDrawDataInfo.ID);
					if (mountDrawTemplateInfo != null)
					{
						num27 += mountDrawTemplateInfo.MagicAttack;
						num28 += mountDrawTemplateInfo.MagicDefence;
						num29 += mountDrawTemplateInfo.AddBlood;
					}
				}
				m_player.GetHalloweenCardCount();
				attack += attack2 + num4 + num8 + num13 + attack3 + att + num18;
				defence += defence2 + num5 + num9 + num14 + defence3 + def + num19;
				agility += agility2 + num6 + num10 + num15 + agility3 + agi + num20;
				lucky += lucky2 + num7 + num11 + num16 + lucky3 + luk + num21;
				hp += hp2 + num12 + num17 + hp3 + hp4 + num26 + num29;
				num += num22 + num24 + num27 + num31;
				num2 += num23 + num25 + num28 + num30;
				int enhanceAtt = 0;
				int enhanceDef = 0;
				int critBonus = 0;
				m_player.MagicHouse.UpdateEnhanceProperties(num, num2, ref enhanceAtt, ref enhanceDef, ref attack, ref defence, ref agility, ref lucky, ref critBonus);
				int enhanceHp = 0;
				int reduceDamagePow = 0;
				m_player.PetBag.UpdatePetFormProp(hp, ref enhanceHp, ref reduceDamagePow);
				enhanceHp = (int)(((double)(enhanceHp + m_player.LevelPlusBlood + defence / 10) + m_player.GetGoldBlood()) * m_player.GetBaseBlood());
				m_player.UpdateBaseProperties(attack, defence, agility, lucky, enhanceHp, enhanceAtt, enhanceDef);
				m_player.UpdateWeapon(m_items[6]);
				m_player.UpdateSecondWeapon(m_items[15]);
				m_player.UpdateReduceDame(m_items[17]);
				m_player.UpdateHealstone(m_items[18]);
				m_player.UpdateStyle(text, text2, skin);
				m_player.UpdateBatleConfig("MagicHouse", critBonus);
				m_player.UpdateBatleConfig("PetFormReduceDamage", reduceDamagePow);
				m_player.PlayerProp.CreateProp(isSelf: true, "Texp", num13, num14, num15, num16, num17);
				m_player.PlayerProp.CreateProp(isSelf: true, "Card", num4, num5, num6, num7, 0);
				m_player.PlayerProp.CreateProp(isSelf: true, "Pet", num8, num9, num10, num11, num12);
				m_player.PlayerProp.CreateProp(isSelf: true, "Gem", attack2, defence2, agility2, lucky2, hp2);
				m_player.PlayerProp.CreateProp(isSelf: true, "Bead", attack3, defence3, agility3, lucky3, hp3);
				m_player.PlayerProp.CreateProp(isSelf: true, "Avatar", att, def, agi, luk, hp4);
				m_player.PlayerProp.CreateProp(isSelf: true, "MagicStone", num18, num19, num20, num21, 0);
				m_player.PlayerProp.CreateProp(isSelf: true, "Horse", 0, 0, 0, 0, num26);
				m_player.PlayerProp.CreateProp(isSelf: true, "HorsePicCherish", 0, 0, 0, 0, num29);
				m_player.PlayerProp.UpadateBaseProp(isSelf: true, "MagicAttack", "MagicStone", num22);
				m_player.PlayerProp.UpadateBaseProp(isSelf: true, "MagicDefence", "MagicStone", num23);
				m_player.PlayerProp.UpadateBaseProp(isSelf: true, "MagicAttack", "Horse", num24);
				m_player.PlayerProp.UpadateBaseProp(isSelf: true, "MagicDefence", "Horse", num25);
				m_player.PlayerProp.UpadateBaseProp(isSelf: true, "MagicAttack", "HorsePicCherish", num27);
				m_player.PlayerProp.UpadateBaseProp(isSelf: true, "MagicDefence", "HorsePicCherish", num28);
				m_player.PlayerProp.UpadateBaseProp(isSelf: true, "MagicAttack", "Enchant", num31);
				m_player.PlayerProp.UpadateBaseProp(isSelf: true, "MagicDefence", "Enchant", num30);
				m_player.UpdateFightPower();
				m_player.ApertureEquip(num3);
				m_player.PlayerProp.ViewCurrent();
				GetUserNimbus();
			}
			finally
			{
				m_player.CommitChanges();
			}
		}

		public Dictionary<string, int> GetProp(int attack, int defence, int agility, int lucky, int hp)
		{
			Dictionary<string, int> dictionary = new Dictionary<string, int>();
			dictionary.Add("Attack", attack);
			dictionary.Add("Defence", defence);
			dictionary.Add("Agility", agility);
			dictionary.Add("Luck", lucky);
			dictionary.Add("HP", hp);
			return dictionary;
		}

		public void GetUserNimbus()
		{
			int num = 0;
			int num2 = 0;
			for (int i = 0; i < 31; i++)
			{
				ItemInfo ıtemAt = GetItemAt(i);
				if (ıtemAt == null)
				{
					continue;
				}
				if (ıtemAt.IsGold)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num > 1) ? num : 5);
					}
					if (ıtemAt.Template.CategoryID == 7)
					{
						num2 = ((num2 > 1) ? num2 : 5);
					}
				}
				if (ıtemAt.StrengthenLevel >= 5 && ıtemAt.StrengthenLevel <= 8)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num <= 1) ? 1 : num);
					}
					if (ıtemAt.Template.CategoryID == 7)
					{
						num2 = ((num2 <= 1) ? 1 : num2);
					}
				}
				if (ıtemAt.StrengthenLevel >= 9 && ıtemAt.StrengthenLevel <= 11)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num > 1) ? num : 2);
					}
					if (ıtemAt.Template.CategoryID == 7)
					{
						num2 = ((num2 > 1) ? num2 : 2);
					}
				}
				if (ıtemAt.StrengthenLevel >= 12 && ıtemAt.StrengthenLevel <= 14)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num > 1) ? num : 3);
					}
					if (ıtemAt.Template.CategoryID == 7)
					{
						num2 = ((num2 > 1) ? num2 : 3);
					}
				}
				if (ıtemAt.StrengthenLevel >= 15)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num > 1) ? num : 5);
					}
					if (ıtemAt.Template.CategoryID == 7)
					{
						num2 = ((num2 > 1) ? num2 : 4);
					}
				}
				if (ıtemAt.IsGold)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num > 1) ? num : 5);
					}
					if (ıtemAt.Template.CategoryID == 27)
					{
						num2 = ((num2 > 1) ? num2 : 5);
					}
				}
				if (ıtemAt.StrengthenLevel >= 5 && ıtemAt.StrengthenLevel <= 8)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num <= 1) ? 1 : num);
					}
					if (ıtemAt.Template.CategoryID == 27)
					{
						num2 = ((num2 <= 1) ? 1 : num2);
					}
				}
				if (ıtemAt.StrengthenLevel >= 9 && ıtemAt.StrengthenLevel <= 11)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num > 1) ? num : 2);
					}
					if (ıtemAt.Template.CategoryID == 27)
					{
						num2 = ((num2 > 1) ? num2 : 2);
					}
				}
				if (ıtemAt.StrengthenLevel >= 12 && ıtemAt.StrengthenLevel <= 14)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num > 1) ? num : 3);
					}
					if (ıtemAt.Template.CategoryID == 27)
					{
						num2 = ((num2 > 1) ? num2 : 3);
					}
				}
				if (ıtemAt.StrengthenLevel >= 15)
				{
					if (ıtemAt.Template.CategoryID == 1 || ıtemAt.Template.CategoryID == 5)
					{
						num = ((num > 1) ? num : 4);
					}
					if (ıtemAt.Template.CategoryID == 27)
					{
						num2 = ((num2 > 1) ? num2 : 4);
					}
				}
			}
			m_player.PlayerCharacter.Nimbus = num * 100 + num2;
			m_player.Out.SendUpdatePublicPlayer(m_player.PlayerCharacter, m_player.BattleData.MatchInfo);
		}

		public void EquipBeadEffect()
		{
			m_player.EquipEffect.Clear();
			int[] array = new int[3] { 1, 2, 3 };
			for (int i = 0; i < array.Length; i++)
			{
				ItemInfo ıtemAt = m_player.BeadBag.GetItemAt(array[i]);
				if (ıtemAt != null && ((ıtemAt.Template.Property1 == 31 && ıtemAt.Template.Property2 == 1) || (ıtemAt.Template.Property1 == 31 && ıtemAt.Template.Property2 == 2)))
				{
					m_player.AddBeadEffect(ıtemAt);
				}
			}
		}

		public void AddBeadProperty(int place, ref int attack, ref int defence, ref int agility, ref int lucky, ref int hp)
		{
			ItemInfo ıtemAt = m_player.BeadBag.GetItemAt(place);
			if (ıtemAt != null)
			{
				AddRuneProperty(ıtemAt, ref attack, ref defence, ref agility, ref lucky, ref hp);
			}
		}

		public void AddRuneProperty(ItemInfo item, ref int attack, ref int defence, ref int agility, ref int lucky, ref int hp)
		{
			RuneTemplateInfo runeTemplateInfo = RuneMgr.FindRuneByTemplateID(item.TemplateID);
			if (runeTemplateInfo == null)
			{
				return;
			}
			string[] array = runeTemplateInfo.Attribute1.Split('|');
			string[] array2 = runeTemplateInfo.Attribute2.Split('|');
			int num = 0;
			int num2 = 0;
			if (item.Hole1 > runeTemplateInfo.BaseLevel)
			{
				if (array.Length > 1)
				{
					num = 1;
				}
				if (array2.Length > 1)
				{
					num2 = 1;
				}
			}
			int num3 = Convert.ToInt32(array[num]);
			int num4 = Convert.ToInt32(array2[num2]);
			switch (runeTemplateInfo.Type1)
			{
			case 31:
				attack += num3;
				hp += num4;
				break;
			case 32:
				defence += num3;
				hp += num4;
				break;
			case 33:
				agility += num3;
				hp += num4;
				break;
			case 34:
				lucky += num3;
				hp += num4;
				break;
			case 35:
				hp += num4;
				break;
			case 36:
				hp += num4;
				break;
			case 37:
				hp += num3;
				break;
			}
		}

		public void AddBaseTotemProperty(PlayerInfo p, ref int attack, ref int defence, ref int agility, ref int lucky, ref int hp)
		{
			attack += TotemMgr.GetTotemProp(p.totemId, "att");
			defence += TotemMgr.GetTotemProp(p.totemId, "def");
			agility += TotemMgr.GetTotemProp(p.totemId, "agi");
			lucky += TotemMgr.GetTotemProp(p.totemId, "luc");
			hp += TotemMgr.GetTotemProp(p.totemId, "blo");
		}

		public void AddBaseLatentProperty(ItemInfo item, ref int attack, ref int defence, ref int agility, ref int lucky)
		{
			if (item != null && !item.IsValidLatentEnergy())
			{
				string[] array = item.latentEnergyCurStr.Split(',');
				attack += Convert.ToInt32(array[0]);
				defence += Convert.ToInt32(array[1]);
				agility += Convert.ToInt32(array[2]);
				lucky += Convert.ToInt32(array[3]);
			}
		}

		public void AddBaseGemstoneProperty(ItemInfo item, ref int attack, ref int defence, ref int agility, ref int lucky, ref int hp)
		{
			List<UserGemStone> gemStone = m_player.GemStone;
			foreach (UserGemStone item2 in gemStone)
			{
				int figSpiritId = item2.FigSpiritId;
				int lv = Convert.ToInt32(item2.FigSpiritIdValue.Split('|')[0].Split(',')[0]);
				int num = item2.FigSpiritIdValue.Split('|').Length;
				int place = item.Place;
				switch (item.Place)
				{
				case 2:
					attack += FightSpiritTemplateMgr.getProp(figSpiritId, lv, place) * num;
					break;
				case 3:
					lucky += FightSpiritTemplateMgr.getProp(figSpiritId, lv, place) * num;
					break;
				case 5:
					agility += FightSpiritTemplateMgr.getProp(figSpiritId, lv, place) * num;
					break;
				case 11:
					defence += FightSpiritTemplateMgr.getProp(figSpiritId, lv, place) * num;
					break;
				case 13:
					hp += FightSpiritTemplateMgr.getProp(figSpiritId, lv, place) * num;
					break;
				}
			}
		}

		static PlayerEquipInventory()
		{
			log = LogManager.GetLogger("ItemLogger");
		}
	}
}
