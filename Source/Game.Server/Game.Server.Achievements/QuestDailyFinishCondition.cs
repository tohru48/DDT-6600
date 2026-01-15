using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class QuestDailyFinishCondition : BaseCondition
	{
		public QuestDailyFinishCondition(BaseAchievement quest, AchievementConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.QuestFinishEvent += method_0;
		}

		private void method_0(QuestDataInfo questDataInfo_0, QuestInfo questInfo_0)
		{
			if (questInfo_0.QuestID == 2)
			{
				base.Value++;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.QuestFinishEvent -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
