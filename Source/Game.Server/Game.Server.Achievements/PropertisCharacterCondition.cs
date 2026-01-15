using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class PropertisCharacterCondition : BaseCondition
	{
		private string string_0;

		public PropertisCharacterCondition(BaseAchievement quest, AchievementConditionInfo info, int value, string type)
			: base(quest, info, value)
		{
			string_0 = type;
		}

		public override void AddTrigger(GamePlayer player)
		{
			player.PropertisChange += method_0;
		}

		private void method_0(PlayerInfo playerInfo_0)
		{
			switch (string_0)
			{
			case "attack":
				base.Value = playerInfo_0.Attack;
				break;
			case "agility":
				base.Value = playerInfo_0.Agility;
				break;
			case "luck":
				base.Value = playerInfo_0.Luck;
				break;
			case "defence":
				base.Value = playerInfo_0.Defence;
				break;
			case "fightpower":
				base.Value = playerInfo_0.FightPower;
				break;
			}
		}

		public override void RemoveTrigger(GamePlayer player)
		{
			player.PropertisChange -= method_0;
		}

		public override bool IsCompleted(GamePlayer player)
		{
			return base.Value >= m_info.Condiction_Para2;
		}
	}
}
