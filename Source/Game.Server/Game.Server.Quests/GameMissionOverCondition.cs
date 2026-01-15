using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class GameMissionOverCondition : BaseCondition
	{
		public GameMissionOverCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.MissionTurnOver += method_1;
			player.QuestOneKeyFinish += method_0;
		}

		private void method_0(QuestConditionInfo questConditionInfo_0)
		{
			if (questConditionInfo_0.QuestID == m_info.QuestID && questConditionInfo_0.Para2 <= m_info.Para2 && base.Value > 0)
			{
				base.Value = 0;
			}
		}

		private void method_1(AbstractGame abstractGame_0, int int_1, int int_2)
		{
			if ((int_1 == m_info.Para1 || m_info.Para1 == -1) && int_2 <= m_info.Para2 && base.Value > 0)
			{
				base.Value = 0;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.MissionTurnOver -= method_1;
			player.QuestOneKeyFinish -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value <= 0;
		}
	}
}
