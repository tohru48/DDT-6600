using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class UseBigBugleCondition : BaseCondition
	{
		public UseBigBugleCondition(BaseAchievement quest, AchievementConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.UseBugle += method_0;
		}

		private void method_0(int int_1)
		{
			if (int_1 == 11102)
			{
				base.Value++;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.UseBugle -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
