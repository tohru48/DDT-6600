using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class UsingItemCondition : BaseCondition
	{
		private int int_1;

		public UsingItemCondition(BaseAchievement quest, AchievementConditionInfo info, int templateid, int value)
			: base(quest, info, value)
		{
			int_1 = templateid;
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.AfterUsingItem += method_0;
		}

		private void method_0(int int_2)
		{
			if (int_1 == int_2)
			{
				base.Value++;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.AfterUsingItem -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
