using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class GameOverPassCondition : BaseCondition
	{
		private int int_1;

		public GameOverPassCondition(BaseAchievement quest, AchievementConditionInfo info, int type, int value)
			: base(quest, info, value)
		{
			int_1 = type;
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.MissionFullOver += method_0;
		}

		private void method_0(AbstractGame abstractGame_0, int int_2, bool bool_0, int int_3)
		{
			if (!bool_0)
			{
				return;
			}
			switch (int_1)
			{
			case 1:
				if (int_2 == 6104 || int_2 == 6204 || int_2 == 6304)
				{
					base.Value++;
				}
				break;
			case 2:
				if (int_2 == 7004 || int_2 == 7104 || int_2 == 7204)
				{
					base.Value++;
				}
				break;
			case 3:
				if (int_2 == 3106 || int_2 == 3206 || int_2 == 3306)
				{
					base.Value++;
				}
				break;
			case 4:
				if (int_2 == 1073 || int_2 == 1176 || int_2 == 1277 || int_2 == 1378)
				{
					base.Value++;
				}
				break;
			case 5:
				if (int_2 == 2002 || int_2 == 2102)
				{
					base.Value++;
				}
				break;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.MissionFullOver -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
