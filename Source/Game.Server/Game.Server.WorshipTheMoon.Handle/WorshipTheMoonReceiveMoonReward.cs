using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.WorshipTheMoon.Handle
{
	[Attribute16(5)]
	public class WorshipTheMoonReceiveMoonReward : IWorshipTheMoonCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = int.Parse(GameProperties.WorshipMoonGift.Split('|')[0]);
			if (Player.Actives.Info.updateWorshipedCounts >= num)
			{
				int templateId = int.Parse(GameProperties.WorshipMoonGift.Split('|')[1]);
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(templateId);
				if (ıtemTemplateInfo != null)
				{
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
					ıtemInfo.IsBinds = true;
					Player.AddTemplate(ıtemInfo);
					Player.SendMessage(LanguageMgr.GetTranslation("WorshipTheMoonReceiveMoonReward.Success"));
				}
				Player.Actives.Info.update200State++;
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("WorshipTheMoonReceiveMoonReward.Fail"));
			}
			Player.Actives.SendUpdateFreeCount();
			return false;
		}
	}
}
