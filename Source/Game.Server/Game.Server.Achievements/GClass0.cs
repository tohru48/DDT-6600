using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class GClass0 : BaseCondition
	{
		public GClass0(BaseAchievement quest, AchievementConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.Event_0 += method_0;
		}

		private void method_0(int int_1, int int_2)
		{
			if (base.Value < int_1)
			{
				base.Value = int_1;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.Event_0 -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
