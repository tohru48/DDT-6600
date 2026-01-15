using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class OwnPropertyCondition : BaseCondition
	{
		public OwnPropertyCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
		}

		private void method_0()
		{
		}

		public override void RemoveTrigger(GamePlayer player)
		{
		}

		public override bool IsCompleted(GamePlayer player)
		{
			if (player.GetItemCount(m_info.Para1) >= m_info.Para2)
			{
				base.Value = m_info.Para2;
				return true;
			}
			return false;
		}
	}
}
