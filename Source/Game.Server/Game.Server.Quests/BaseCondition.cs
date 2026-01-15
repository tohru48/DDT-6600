using System.Reflection;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class BaseCondition
	{
		protected QuestConditionInfo m_info;

		private static readonly ILog ilog_0;

		private int int_0;

		private BaseQuest baseQuest_0;

		public QuestConditionInfo Info => m_info;

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
					baseQuest_0.Update();
				}
			}
		}

		public BaseCondition(BaseQuest quest, QuestConditionInfo info, int value)
		{
			baseQuest_0 = quest;
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

		public virtual bool CancelFinish(GamePlayer player)
		{
			return true;
		}

		public virtual void Reset(GamePlayer player)
		{
			switch (m_info.CondictionType)
			{
			default:
				int_0 = 0;
				break;
			case 1:
			case 2:
			case 3:
			case 14:
			case 15:
			case 16:
			case 17:
			case 18:
			case 20:
			case 21:
			case 99:
				if (m_info.QuestID == 339)
				{
					int_0 = 0;
				}
				else
				{
					int_0 = m_info.Para2;
				}
				break;
			}
		}

		public static BaseCondition CreateCondition(BaseQuest quest, QuestConditionInfo info, int value)
		{
			return info.CondictionType switch
			{
				1 => new OwnGradeCondition(quest, info, value), 
				2 => new ItemMountingCondition(quest, info, value), 
				3 => new UsingItemCondition(quest, info, value), 
				4 => new GameKillByRoomCondition(quest, info, value), 
				5 => new GameFightByRoomCondition(quest, info, value), 
				6 => new GameOverByRoomCondition(quest, info, value), 
				7 => new GameCopyOverCondition(quest, info, value), 
				8 => new GameCopyPassCondition(quest, info, value), 
				9 => new ItemStrengthenCondition(quest, info, value), 
				10 => new ShopCondition(quest, info, value), 
				11 => new ItemFusionCondition(quest, info, value), 
				12 => new ItemMeltCondition(quest, info, value), 
				13 => new GameMonsterCondition(quest, info, value), 
				14 => new OwnPropertyCondition(quest, info, value), 
				15 => new TurnPropertyCondition(quest, info, value), 
				16 => new DirectFinishCondition(quest, info, value), 
				17 => new OwnMarryCondition(quest, info, value), 
				18 => new OwnConsortiaCondition(quest, info, value), 
				19 => new ItemComposeCondition(quest, info, value), 
				20 => new ClientModifyCondition(quest, info, value), 
				21 => new GameMissionOverCondition(quest, info, value), 
				22 => new GameKillByGameCondition(quest, info, value), 
				23 => new GameFightByGameCondition(quest, info, value), 
				24 => new GameOverByGameCondition(quest, info, value), 
				25 => new ItemInsertCondition(quest, info, value), 
				26 => new MarryCondition(quest, info, value), 
				27 => new EnterSpaCondition(quest, info, value), 
				28 => new FightWifeHusbandCondition(quest, info, value), 
				30 => new AchievementCondition(quest, info, value), 
				31 => new GameFightByGameCondition(quest, info, value), 
				32 => new SharePersonalStatusCondition(quest, info, value), 
				33 => new SendGiftForFriendCondition(quest, info, value), 
				34 => new GameFihgt2v2Condition(quest, info, value), 
				35 => new MasterApprenticeshipCondition(quest, info, value), 
				36 => new GameFightApprenticeshipCondition(quest, info, value), 
				37 => new GameFightMasterApprenticeshipCondition(quest, info, value), 
				38 => new CashCondition(quest, info, value), 
				39 => new NewGearCondition(quest, info, value), 
				42 => new AccuontInfoCondition(quest, info, value), 
				43 => new LoginMissionCondition(quest, info, value), 
				44 => new SetPasswordTwoCondition(quest, info, value), 
				45 => new FightWithPetCondition(quest, info, value), 
				46 => new CombiePetFeedCondition(quest, info, value), 
				47 => new FriendFarmCondition(quest, info, value), 
				48 => new AdoptPetCondition(quest, info, value), 
				49 => new CropPrimaryCondition(quest, info, value), 
				50 => new UpLevelPetCondition(quest, info, value), 
				51 => new SeedFoodPetCondition(quest, info, value), 
				52 => new UserSkillPetCondition(quest, info, value), 
				54 => new UserToemGemstoneCondition(quest, info, value), 
				64 => new CollectionTaskCondition(quest, info, value), 
				_ => new UnknowQuestCondition(quest, info, value), 
			};
		}

		static BaseCondition()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
