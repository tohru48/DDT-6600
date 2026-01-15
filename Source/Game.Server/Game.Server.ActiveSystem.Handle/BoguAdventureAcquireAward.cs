using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(93)]
	public class BoguAdventureAcquireAward : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			if (Player.Actives.IsAcquireAward(num) == 0)
			{
				List<BoguAdventureRewardInfo> list = ActiveSystermAwardMgr.FindBoguAdventureReward(num + 1);
				List<ItemInfo> list2 = new List<ItemInfo>();
				foreach (BoguAdventureRewardInfo item in list)
				{
					ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(item.TemplateID);
					if (ıtemTemplateInfo != null)
					{
						ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
						ıtemInfo.Count = item.Count;
						ıtemInfo.IsBinds = item.IsBinds;
						ıtemInfo.StrengthenLevel = item.StrengthenLevel;
						ıtemInfo.AttackCompose = item.AttackCompose;
						ıtemInfo.DefendCompose = item.DefendCompose;
						ıtemInfo.AgilityCompose = item.AgilityCompose;
						ıtemInfo.LuckCompose = item.LuckCompose;
						list2.Add(ıtemInfo);
					}
				}
				if (list2.Count > 0)
				{
					BoguAdventureDataInfo boguAdventure = Player.Actives.BoguAdventure;
					string translation = LanguageMgr.GetTranslation("BoguAdventureAcquireAward.Newbie");
					switch (num)
					{
					case 0:
						boguAdventure.isAcquireAward1 = 1;
						break;
					case 1:
						boguAdventure.isAcquireAward2 = 1;
						translation = LanguageMgr.GetTranslation("BoguAdventureAcquireAward.Pro");
						break;
					case 2:
						boguAdventure.isAcquireAward3 = 1;
						translation = LanguageMgr.GetTranslation("BoguAdventureAcquireAward.Master");
						break;
					}
					WorldEventMgr.SendItemsToMail(list2, Player.PlayerCharacter.ID, Player.PlayerCharacter.NickName, LanguageMgr.GetTranslation("BoguAdventureAcquireAward.Title", translation));
					Player.Actives.SaveBoguAdventureDatabase();
					Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureUpdateCell.GetAwardSuccess"));
					Player.Actives.SendBoguAdventureEnter();
				}
				else
				{
					Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureUpdateCell.AwardError", num + 1));
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("BoguAdventureUpdateCell.GotAward"));
			}
			return true;
		}
	}
}
