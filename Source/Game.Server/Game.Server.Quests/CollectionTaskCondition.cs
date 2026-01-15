using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class CollectionTaskCondition : BaseCondition
	{
		public CollectionTaskCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.CollectionTaskEvent += method_0;
		}

		private void method_0(int int_1)
		{
			if (m_info.Para1 == int_1 && base.Value < m_info.Para1)
			{
				base.Value++;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.CollectionTaskEvent -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Para2;
		}
	}
}
