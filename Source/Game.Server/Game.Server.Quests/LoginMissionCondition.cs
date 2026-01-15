using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class LoginMissionCondition : BaseCondition
	{
		public LoginMissionCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
		}

		private void method_0(AbstractGame abstractGame_0, int int_1, int int_2)
		{
		}

		public override void RemoveTrigger(GamePlayer player)
		{
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value <= 0;
		}
	}
}
