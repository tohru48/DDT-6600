using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class FightKillPlayerCondition : BaseCondition
	{
		public FightKillPlayerCondition(BaseAchievement quest, AchievementConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.AfterKillingLiving += method_0;
		}

		private void method_0(AbstractGame abstractGame_0, int int_1, int int_2, bool bool_0, int int_3)
		{
			if (int_1 == 1 && !bool_0)
			{
				base.Value++;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.AfterKillingLiving -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
