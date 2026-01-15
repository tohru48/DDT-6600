using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class GameCopyPassCondition : BaseCondition
	{
		public GameCopyPassCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.MissionOver += method_1;
			player.QuestOneKeyFinish += method_0;
		}

		private void method_0(QuestConditionInfo questConditionInfo_0)
		{
			if (questConditionInfo_0.QuestID == m_info.QuestID && questConditionInfo_0.Para2 <= m_info.Para2 && base.Value > 0)
			{
				base.Value = 0;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.QuestOneKeyFinish -= method_0;
			player.MissionOver -= method_1;
		}

		private void method_1(AbstractGame abstractGame_0, int int_1, bool bool_0)
		{
			if (bool_0 && int_1 == m_info.Para1 && base.Value > 0)
			{
				base.Value--;
			}
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value <= 0;
		}
	}
}
