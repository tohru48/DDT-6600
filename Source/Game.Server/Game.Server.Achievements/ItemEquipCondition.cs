using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class ItemEquipCondition : BaseCondition
	{
		private int int_1;

		public ItemEquipCondition(BaseAchievement quest, AchievementConditionInfo info, int value, int templateid)
			: base(quest, info, value)
		{
			int_1 = templateid;
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.NewGearEvent += method_0;
		}

		private void method_0(int int_2)
		{
			if (int_2 == int_1)
			{
				base.Value++;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.NewGearEvent -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
