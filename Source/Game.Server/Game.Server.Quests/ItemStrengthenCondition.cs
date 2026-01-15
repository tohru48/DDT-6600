using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class ItemStrengthenCondition : BaseCondition
	{
		public ItemStrengthenCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.ItemStrengthen += method_0;
		}

		private void method_0(int int_1, int int_2)
		{
			if (m_info.Para1 == int_1 && m_info.Para2 <= int_2)
			{
				base.Value = m_info.Para2;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.ItemStrengthen -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Para2;
		}
	}
}
