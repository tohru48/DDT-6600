using System.Reflection;
using Bussiness;
using Game.Server.GameObjects;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerBattle
	{
		private static readonly ILog ilog_0;

		protected object m_lock;

		public readonly int Attack;

		public readonly int Defend;

		public readonly int Agility;

		public readonly int Lucky;

		public readonly int Damage;

		public readonly int Guard;

		public readonly int Blood;

		public readonly int Energy;

		public readonly double BaseAgility;

		public readonly int LevelLimit;

		public readonly int fairBattleDayPrestige;

		public readonly int maxCount;

		protected GamePlayer m_player;

		private UserMatchInfo userMatchInfo_0;

		private bool bool_0;

		public GamePlayer Player => m_player;

		public UserMatchInfo MatchInfo
		{
			get
			{
				return userMatchInfo_0;
			}
			set
			{
				userMatchInfo_0 = value;
			}
		}

		public PlayerBattle(GamePlayer player, bool saveTodb)
		{
			m_lock = new object();
			Attack = 1700;
			Defend = 1500;
			Agility = 1600;
			Lucky = 1500;
			Damage = 1000;
			Guard = 500;
			Blood = 25000;
			Energy = 293;
			BaseAgility = -0.6000000000000001;
			LevelLimit = 15;
			fairBattleDayPrestige = 2000;
			maxCount = 30;
			m_player = player;
			bool_0 = saveTodb;
		}

		public virtual void LoadFromDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			userMatchInfo_0 = playerBussiness.GetSingleUserMatchInfo(Player.PlayerCharacter.ID);
			if (userMatchInfo_0 == null)
			{
				CreateInfo(Player.PlayerCharacter.ID);
			}
			userMatchInfo_0.maxCount = maxCount;
		}

		public void Reset()
		{
			userMatchInfo_0.dailyScore = 0;
			userMatchInfo_0.addDayPrestge = 0;
			userMatchInfo_0.restCount = 30;
		}

		public int GetRank()
		{
			return RankMgr.FindRank(Player.PlayerCharacter.ID)?.rank ?? 0;
		}

		public void Update()
		{
			if (userMatchInfo_0.restCount > 0)
			{
				userMatchInfo_0.restCount--;
				Player.Out.SendLeagueNotice(Player.PlayerCharacter.ID, MatchInfo.restCount, maxCount, 3);
			}
		}

		public void AddPrestige(bool isWin)
		{
			int totalPrestige = userMatchInfo_0.totalPrestige;
			FairBattleRewardInfo battleDataByPrestige = FairBattleRewardMgr.GetBattleDataByPrestige(totalPrestige);
			if (battleDataByPrestige == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("PVPGame.SendGameOVer.Msg5"));
				return;
			}
			int num = battleDataByPrestige.PrestigeForWin;
			string translation = LanguageMgr.GetTranslation("PVPGame.SendGameOVer.Msg3", num);
			if (!isWin)
			{
				num = battleDataByPrestige.PrestigeForLose;
				translation = LanguageMgr.GetTranslation("PVPGame.SendGameOVer.Msg4", num);
			}
			if (userMatchInfo_0.addDayPrestge < fairBattleDayPrestige)
			{
				userMatchInfo_0.addDayPrestge += num;
				userMatchInfo_0.totalPrestige += num;
			}
			Player.SendMessage(translation);
		}

		public void CreateInfo(int UserID)
		{
			userMatchInfo_0 = new UserMatchInfo();
			userMatchInfo_0.ID = 0;
			userMatchInfo_0.UserID = UserID;
			userMatchInfo_0.dailyScore = 0;
			userMatchInfo_0.dailyWinCount = 0;
			userMatchInfo_0.dailyGameCount = 0;
			userMatchInfo_0.DailyLeagueFirst = true;
			userMatchInfo_0.DailyLeagueLastScore = 0;
			userMatchInfo_0.weeklyScore = 0;
			userMatchInfo_0.weeklyGameCount = 0;
			userMatchInfo_0.weeklyRanking = 1000;
			userMatchInfo_0.addDayPrestge = 0;
			userMatchInfo_0.totalPrestige = 0;
			userMatchInfo_0.restCount = 30;
			userMatchInfo_0.maxCount = maxCount;
		}

		public virtual void SaveToDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				if (userMatchInfo_0 != null && userMatchInfo_0.IsDirty)
				{
					if (userMatchInfo_0.ID > 0)
					{
						playerBussiness.UpdateUserMatchInfo(userMatchInfo_0);
					}
					else
					{
						playerBussiness.AddUserMatchInfo(userMatchInfo_0);
					}
				}
			}
		}

		static PlayerBattle()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
