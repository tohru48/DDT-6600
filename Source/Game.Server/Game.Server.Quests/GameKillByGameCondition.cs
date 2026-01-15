using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class GameKillByGameCondition : BaseCondition
	{
		public GameKillByGameCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.AfterKillingLiving += method_1;
			player.QuestOneKeyFinish += method_0;
		}

		private void method_0(QuestConditionInfo questConditionInfo_0)
		{
			if (questConditionInfo_0.QuestID == m_info.QuestID && questConditionInfo_0.Para2 <= m_info.Para2 && base.Value < m_info.Para2)
			{
				base.Value = questConditionInfo_0.Para2;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.QuestOneKeyFinish -= method_0;
			player.AfterKillingLiving -= method_1;
		}

		private void method_1(AbstractGame abstractGame_0, int int_1, int int_2, bool bool_0, int int_3)
		{
			if (bool_0 || int_1 != 1)
			{
				return;
			}
			switch (abstractGame_0.GameType)
			{
			case eGameType.Free:
				if ((m_info.Para1 == 0 || m_info.Para1 == -1) && base.Value < m_info.Para2)
				{
					base.Value++;
				}
				break;
			case eGameType.Guild:
				if ((m_info.Para1 == 1 || m_info.Para1 == -1) && base.Value < m_info.Para2)
				{
					base.Value++;
				}
				break;
			case eGameType.Training:
				if ((m_info.Para1 == 2 || m_info.Para1 == -1) && base.Value < m_info.Para2)
				{
					base.Value++;
				}
				break;
			case eGameType.ALL:
				if ((m_info.Para1 == 4 || m_info.Para1 == -1) && base.Value < m_info.Para2)
				{
					base.Value++;
				}
				break;
			case eGameType.Exploration:
				if ((m_info.Para1 == 5 || m_info.Para1 == -1) && base.Value < m_info.Para2)
				{
					base.Value++;
				}
				break;
			case eGameType.FightLib:
				if ((m_info.Para1 == 8 || m_info.Para1 == -1) && base.Value < m_info.Para2)
				{
					base.Value++;
				}
				break;
			case eGameType.matchNpc:
				if ((m_info.Para1 == 9 || m_info.Para1 == -1) && base.Value < m_info.Para2)
				{
					base.Value++;
				}
				break;
			}
			if (base.Value >= m_info.Para2)
			{
				base.Value = m_info.Para2;
			}
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Para2;
		}
	}
}
