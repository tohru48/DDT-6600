using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class FightMatchWinCondition : BaseCondition
	{
		public FightMatchWinCondition(BaseAchievement quest, AchievementConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.GameOver += method_0;
		}

		private void method_0(AbstractGame abstractGame_0, bool bool_0, int int_1)
		{
			if (abstractGame_0.GameType == eGameType.Free && abstractGame_0.RoomType == eRoomType.Match)
			{
				base.Value++;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.GameOver -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
