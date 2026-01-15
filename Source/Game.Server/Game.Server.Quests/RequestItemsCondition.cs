using System.Collections.Generic;
using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class RequestItemsCondition : BaseCondition
	{
		public RequestItemsCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
		}

		private void method_0(AbstractGame abstractGame_0, List<MapGoodsInfo> questItems)
		{
		}

		public override void RemoveTrigger(GamePlayer player)
		{
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Para1;
		}
	}
}
