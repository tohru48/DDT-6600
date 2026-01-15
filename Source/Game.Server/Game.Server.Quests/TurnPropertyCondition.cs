using System.Collections.Generic;
using Bussiness.Managers;
using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class TurnPropertyCondition : BaseCondition
	{
		private BaseQuest baseQuest_1;

		private GamePlayer gamePlayer_0;

		public TurnPropertyCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
			baseQuest_1 = quest;
		}

		public override void AddTrigger(GamePlayer player)
		{
			gamePlayer_0 = player;
			player.GameKillDrop += method_0;
			base.AddTrigger(player);
		}

		public override bool IsCompleted(GamePlayer player)
		{
			bool result = false;
			if (player.GetItemCount(m_info.Para1) >= m_info.Para2)
			{
				base.Value = m_info.Para2;
				result = true;
			}
			return result;
		}

		public override bool Finish(GamePlayer player)
		{
			return player.RemoveTemplate(m_info.Para1, m_info.Para2);
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.GameKillDrop -= method_0;
			base.RemoveTrigger(player);
		}

		public override bool CancelFinish(GamePlayer player)
		{
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(m_info.Para1);
			if (ıtemTemplateInfo != null)
			{
				ItemInfo cloneItem = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, m_info.Para2, 117);
				return player.AddTemplate(cloneItem, eBageType.TempBag, m_info.Para2, eGameView.dungeonTypeGet);
			}
			return false;
		}

		private void method_0(AbstractGame abstractGame_0, int int_1, int int_2, bool bool_0)
		{
			if (gamePlayer_0.GetItemCount(m_info.Para1) >= m_info.Para2)
			{
				return;
			}
			List<ItemInfo> info = null;
			if (abstractGame_0 is PVEGame)
			{
				DropInventory.PvEQuestsDrop(int_2, ref info);
			}
			if (abstractGame_0 is PVPGame)
			{
				DropInventory.PvPQuestsDrop(abstractGame_0.RoomType, bool_0, ref info);
			}
			if (info == null)
			{
				return;
			}
			foreach (ItemInfo item in info)
			{
				if (item != null)
				{
					gamePlayer_0.AddTemplate(item, eBageType.TempBag, item.Count, eGameView.dungeonTypeGet);
				}
			}
		}
	}
}
