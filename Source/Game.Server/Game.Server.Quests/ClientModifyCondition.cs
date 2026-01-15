using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class ClientModifyCondition : BaseCondition
	{
		public ClientModifyCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
		{
		}

		public override void Reset(GamePlayer player)
		{
			switch (m_info.Para1)
			{
			case 0:
			case 1:
				base.Value = 1;
				break;
			}
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value <= 0;
		}
	}
}
