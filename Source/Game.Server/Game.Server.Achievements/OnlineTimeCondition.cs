using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class OnlineTimeCondition : BaseCondition
	{
		public OnlineTimeCondition(BaseAchievement quest, AchievementConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.PingTimeOnline += method_0;
		}

		private void method_0(GamePlayer gamePlayer_0)
		{
			base.Value++;
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.PingTimeOnline -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
