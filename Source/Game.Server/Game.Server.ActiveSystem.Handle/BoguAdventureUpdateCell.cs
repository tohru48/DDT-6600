using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(91)]
	public class BoguAdventureUpdateCell : IActiveSystemCommandHadler
	{
		public static ThreadSafeRandom random;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = 1;
			if (num != 3)
			{
				num2 = packet.ReadInt();
			}
			int val = Player.Actives.SPACE;
			BoguCeilInfo boguCeilInfo = Player.Actives.FindCeilBoguMap(num2);
			BoguAdventureDataInfo boguAdventure = Player.Actives.BoguAdventure;
			switch (num)
			{
			case 1:
				if (boguCeilInfo != null && boguCeilInfo.State == Player.Actives.NOT_OPEN)
				{
					boguCeilInfo.State = 1;
					Player.Actives.UpdateCeilBoguMap(boguCeilInfo);
				}
				break;
			case 2:
				if (boguCeilInfo != null && boguCeilInfo.State == Player.Actives.SIGN)
				{
					boguCeilInfo.State = 3;
					Player.Actives.UpdateCeilBoguMap(boguCeilInfo);
				}
				break;
			case 3:
				if (boguAdventure.hp > 0 && boguAdventure.currentIndex > 0)
				{
					BoguCeilInfo[] totalMineAroundNotOpen = Player.Actives.GetTotalMineAroundNotOpen(boguAdventure.currentIndex);
					if (totalMineAroundNotOpen.Length > 0)
					{
						int num3 = random.Next(0, totalMineAroundNotOpen.Length - 1);
						BoguCeilInfo boguCeilInfo2 = totalMineAroundNotOpen[num3];
						if (boguCeilInfo2 != null && Player.MoneyDirect(Player.Actives.findMinePrice))
						{
							boguCeilInfo2.State = 2;
							Player.Actives.UpdateCeilBoguMap(boguCeilInfo2);
							num2 = boguCeilInfo2.Index;
							val = -1;
						}
					}
					else
					{
						Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureUpdateCell.MineNotFound"));
					}
				}
				else
				{
					Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureUpdateCell.NotHaveMineAround"));
				}
				break;
			case 4:
				if (boguCeilInfo == null)
				{
					break;
				}
				if (boguCeilInfo.State == Player.Actives.NOT_OPEN && boguAdventure.hp > 0)
				{
					if (boguCeilInfo.Result == Player.Actives.MINE)
					{
						boguAdventure.hp--;
						val = -1;
					}
					else if (Player.Actives.UpdateAwardCount(num2))
					{
						boguAdventure.openCount++;
						if (random.Next(100) < 25)
						{
							List<BoguAdventureRewardInfo> list = ActiveSystermAwardMgr.FindBoguAdventureReward(0);
							if (list.Count > 0)
							{
								BoguAdventureRewardInfo boguAdventureRewardInfo = list[random.Next(list.Count)];
								ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(boguAdventureRewardInfo.TemplateID);
								if (ıtemTemplateInfo != null)
								{
									ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
									ıtemInfo.Count = boguAdventureRewardInfo.Count;
									ıtemInfo.IsBinds = boguAdventureRewardInfo.IsBinds;
									ıtemInfo.StrengthenLevel = boguAdventureRewardInfo.StrengthenLevel;
									ıtemInfo.AttackCompose = boguAdventureRewardInfo.AttackCompose;
									ıtemInfo.DefendCompose = boguAdventureRewardInfo.DefendCompose;
									ıtemInfo.AgilityCompose = boguAdventureRewardInfo.AgilityCompose;
									ıtemInfo.LuckCompose = boguAdventureRewardInfo.LuckCompose;
									val = ıtemTemplateInfo.TemplateID;
									Player.AddTemplate(ıtemInfo);
									boguCeilInfo.Result = ıtemTemplateInfo.TemplateID;
									Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureUpdateCell.GetLuckyAward", ıtemTemplateInfo.Name, ıtemInfo.Count));
								}
							}
						}
					}
					boguCeilInfo.State = Player.Actives.OPEN;
					Player.Actives.UpdateCeilBoguMap(boguCeilInfo);
				}
				boguAdventure.currentIndex = boguCeilInfo.Index;
				break;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(91);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteInt(num2);
			gSPacketIn.WriteInt(val);
			gSPacketIn.WriteInt(Player.Actives.findMinePrice);
			if (num == 4)
			{
				gSPacketIn.WriteInt(boguAdventure.hp);
				gSPacketIn.WriteInt(boguAdventure.openCount);
			}
			Player.SendTCP(gSPacketIn);
			return true;
		}

		static BoguAdventureUpdateCell()
		{
			random = new ThreadSafeRandom();
		}
	}
}
