using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class ShopCondition : BaseCondition
	{
		public ShopCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.Paid += method_0;
		}

		private void method_0(int int_1, int int_2, int int_3, int int_4, int int_5, string string_0)
		{
			if (m_info.Para1 == -1 && int_1 > 0)
			{
				base.Value += int_1;
			}
			if (m_info.Para1 == -2 && int_2 > 0)
			{
				base.Value += int_2;
			}
			if (m_info.Para1 == -3 && int_3 > 0)
			{
				base.Value += int_3;
			}
			if (m_info.Para1 == -4 && int_4 > 0)
			{
				base.Value += int_4;
			}
			if (m_info.Para1 == 11408 && int_5 > 0)
			{
				base.Value += int_5;
			}
			string[] array = string_0.Split(',');
			string[] array2 = array;
			foreach (string text in array2)
			{
				if (text == m_info.Para1.ToString())
				{
					base.Value++;
				}
			}
			if (base.Value > m_info.Para2)
			{
				base.Value = m_info.Para2;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.Paid -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Para2;
		}
	}
}
