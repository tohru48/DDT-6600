using System.Reflection;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class BaseCondition
	{
		protected AchievementConditionInfo m_info;

		private static readonly ILog ilog_0;

		private int int_0;

		private BaseAchievement baseAchievement_0;

		public AchievementConditionInfo Info => m_info;

		public int Value
		{
			get
			{
				return int_0;
			}
			set
			{
				if (int_0 != value)
				{
					int_0 = value;
					baseAchievement_0.Update();
				}
			}
		}

		public BaseCondition(BaseAchievement ach, AchievementConditionInfo info, int value)
		{
			baseAchievement_0 = ach;
			m_info = info;
			int_0 = value;
		}

		public virtual void AddTrigger(GamePlayer player)
		{
		}

		public virtual void RemoveTrigger(GamePlayer player)
		{
		}

		public virtual bool IsCompleted(GamePlayer player)
		{
			return false;
		}

		public virtual bool Finish(GamePlayer player)
		{
			return true;
		}

		public static BaseCondition CreateCondition(BaseAchievement ach, AchievementConditionInfo info, int value)
		{
			return info.CondictionType switch
			{
				1 => new PropertisCharacterCondition(ach, info, value, "attack"), 
				2 => new PropertisCharacterCondition(ach, info, value, "defence"), 
				3 => new PropertisCharacterCondition(ach, info, value, "agility"), 
				4 => new PropertisCharacterCondition(ach, info, value, "luck"), 
				5 => new DefaultCondition(ach, info, value), 
				6 => new DefaultCondition(ach, info, value), 
				7 => new DefaultCondition(ach, info, value), 
				8 => new DefaultCondition(ach, info, value), 
				9 => new PropertisCharacterCondition(ach, info, value, "fightpower"), 
				10 => new LevelUpgradeCondition(ach, info, value), 
				11 => new FightCompleteCondition(ach, info, value), 
				13 => new OnlineTimeCondition(ach, info, value), 
				14 => new FightMatchWinCondition(ach, info, value), 
				15 => new GuildFightWinCondition(ach, info, value), 
				19 => new FightKillPlayerCondition(ach, info, value), 
				21 => new QuestGreenFinishCondition(ach, info, value), 
				22 => new QuestDailyFinishCondition(ach, info, value), 
				24 => new DefaultCondition(ach, info, value), 
				25 => new DefaultCondition(ach, info, value), 
				26 => new DefaultCondition(ach, info, value), 
				27 => new DefaultCondition(ach, info, value), 
				28 => new GameOverPassCondition(ach, info, 5, value), 
				29 => new GameOverPassCondition(ach, info, 4, value), 
				30 => new GameOverPassCondition(ach, info, 3, value), 
				31 => new DefaultCondition(ach, info, value), 
				32 => new DefaultCondition(ach, info, value), 
				33 => new HotSpingEnterCondition(ach, info, value), 
				34 => new UsingItemCondition(ach, info, 10020, value), 
				35 => new UsingItemCondition(ach, info, 10022, value), 
				36 => new DefaultCondition(ach, info, value), 
				37 => new DefaultCondition(ach, info, value), 
				38 => new GoldCollectionCondition(ach, info, value), 
				39 => new GiftTokenCollectionCondition(ach, info, value), 
				40 => new DefaultCondition(ach, info, value), 
				41 => new FightOneBloodIsWinCondition(ach, info, value), 
				42 => new ItemEquipCondition(ach, info, value, 17002), 
				45 => new DefaultCondition(ach, info, value), 
				47 => new UseBigBugleCondition(ach, info, value), 
				48 => new UseSmaillBugleCondition(ach, info, value), 
				50 => new FightAddOfferCondition(ach, info, value), 
				51 => new DefaultCondition(ach, info, value), 
				52 => new DefaultCondition(ach, info, value), 
				53 => new DefaultCondition(ach, info, value), 
				54 => new DefaultCondition(ach, info, value), 
				55 => new DefaultCondition(ach, info, value), 
				56 => new DefaultCondition(ach, info, value), 
				59 => new DefaultCondition(ach, info, value), 
				60 => new DefaultCondition(ach, info, value), 
				61 => new DefaultCondition(ach, info, value), 
				62 => new DefaultCondition(ach, info, value), 
				64 => new DefaultCondition(ach, info, value), 
				65 => new DefaultCondition(ach, info, value), 
				66 => new DefaultCondition(ach, info, value), 
				67 => new DefaultCondition(ach, info, value), 
				68 => new DefaultCondition(ach, info, value), 
				69 => new DefaultCondition(ach, info, value), 
				70 => new DefaultCondition(ach, info, value), 
				71 => new DefaultCondition(ach, info, value), 
				72 => new DefaultCondition(ach, info, value), 
				73 => new DefaultCondition(ach, info, value), 
				74 => new GClass0(ach, info, value), 
				75 => new DefaultCondition(ach, info, value), 
				76 => new DefaultCondition(ach, info, value), 
				77 => new DefaultCondition(ach, info, value), 
				78 => new DefaultCondition(ach, info, value), 
				79 => new DefaultCondition(ach, info, value), 
				80 => new GameOverPassCondition(ach, info, 2, value), 
				81 => new DefaultCondition(ach, info, value), 
				82 => new GameOverPassCondition(ach, info, 1, value), 
				83 => new DefaultCondition(ach, info, value), 
				84 => new DefaultCondition(ach, info, value), 
				85 => new DefaultCondition(ach, info, value), 
				86 => new DefaultCondition(ach, info, value), 
				87 => new DefaultCondition(ach, info, value), 
				88 => new DefaultCondition(ach, info, value), 
				89 => new DefaultCondition(ach, info, value), 
				90 => new DefaultCondition(ach, info, value), 
				91 => new DefaultCondition(ach, info, value), 
				92 => new DefaultCondition(ach, info, value), 
				93 => new DefaultCondition(ach, info, value), 
				94 => new DefaultCondition(ach, info, value), 
				95 => new DefaultCondition(ach, info, value), 
				_ => null, 
			};
		}

		static BaseCondition()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
