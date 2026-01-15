using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Bussiness.Managers;
using Game.Server.GameObjects;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerRank
	{
		private static readonly ILog ilog_0;

		protected object m_lock;

		protected GamePlayer m_player;

		private List<UserRankInfo> list_0;

		private UserRankInfo userRankInfo_0;

		private bool bool_0;

		public GamePlayer Player => m_player;

		public List<UserRankInfo> Ranks
		{
			get
			{
				return list_0;
			}
			set
			{
				list_0 = value;
			}
		}

		public UserRankInfo CurrentRank
		{
			get
			{
				return userRankInfo_0;
			}
			set
			{
				userRankInfo_0 = value;
			}
		}

		public PlayerRank(GamePlayer player, bool saveTodb)
		{
			m_lock = new object();
			m_player = player;
			bool_0 = saveTodb;
			list_0 = new List<UserRankInfo>();
			userRankInfo_0 = GetRank(m_player.PlayerCharacter.Honor);
		}

		public virtual void LoadFromDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			try
			{
				List<UserRankInfo> singleUserRank = playerBussiness.GetSingleUserRank(Player.PlayerCharacter.ID);
				if (singleUserRank.Count == 0)
				{
					CreateRank(Player.PlayerCharacter.ID);
					return;
				}
				foreach (UserRankInfo item in singleUserRank)
				{
					if (!item.IsValidRank() && !item.IsTop())
					{
						RemoveRank(item);
						continue;
					}
					item.EndDate = DateTime.Now.AddDays(30.0);
					AddRank(item);
				}
			}
			finally
			{
				UserRankDateInfo userRankDateInfo = RankMgr.FindRankDate(Player.PlayerCharacter.ID);
				if (userRankDateInfo != null)
				{
					if (userRankDateInfo.FightPower == 1)
					{
						AddNewRank(602);
					}
					if (userRankDateInfo.MountExp == 1)
					{
						AddNewRank(615);
					}
					if (userRankDateInfo.GiftGp == 1)
					{
						AddNewRank(603);
					}
				}
			}
		}

		public void UpdateRank()
		{
			Player.Out.SendUserRanks(Player.PlayerCharacter.ID, GetRanks());
		}

		public void AddNewRank(int id)
		{
			AddNewRank(id, 0);
		}

		public void AddNewRank(int id, int days)
		{
			NewTitleInfo newTitleInfo = NewTitleMgr.FindNewTitle(id);
			if (newTitleInfo != null)
			{
				UserRankInfo rankByHonnor = GetRankByHonnor(id);
				if (rankByHonnor == null)
				{
					AddRank(new UserRankInfo
					{
						Name = newTitleInfo.Name,
						NewTitleID = newTitleInfo.ID,
						UserID = Player.PlayerCharacter.ID,
						BeginDate = DateTime.Now,
						EndDate = DateTime.Now.AddDays(days),
						Validate = days,
						IsExit = true
					});
				}
				else
				{
					rankByHonnor.IsExit = true;
					rankByHonnor.EndDate = DateTime.Now.AddDays(days);
				}
			}
		}

		public void AddAchievementRank(string name)
		{
			NewTitleInfo newTitleInfo = NewTitleMgr.FindNewTitleByName(name);
			if (newTitleInfo != null)
			{
				UserRankInfo rank = GetRank(name);
				if (rank == null)
				{
					AddRank(new UserRankInfo
					{
						Name = newTitleInfo.Name,
						NewTitleID = newTitleInfo.ID,
						UserID = Player.PlayerCharacter.ID,
						BeginDate = DateTime.Now,
						EndDate = DateTime.Now,
						Validate = 0,
						IsExit = true
					});
				}
				else
				{
					rank.IsExit = true;
					rank.EndDate = DateTime.Now;
				}
			}
		}

		public void AddRank(UserRankInfo info)
		{
			lock (list_0)
			{
				list_0.Add(info);
			}
		}

		public void RemoveRank(UserRankInfo item)
		{
			item.IsExit = false;
			AddRank(item);
		}

		public List<UserRankInfo> GetRanks()
		{
			List<UserRankInfo> list = new List<UserRankInfo>();
			foreach (UserRankInfo item in list_0)
			{
				if (item.IsExit)
				{
					list.Add(item);
				}
			}
			return list;
		}

		public UserRankInfo GetRank(string honor)
		{
			foreach (UserRankInfo item in list_0)
			{
				if (item.Name == honor)
				{
					return item;
				}
			}
			return null;
		}

		public UserRankInfo GetRankByHonnor(int honor)
		{
			foreach (UserRankInfo item in list_0)
			{
				if (item.NewTitleID == honor)
				{
					return item;
				}
			}
			return null;
		}

		public void CreateRank(int UserID)
		{
			new List<UserRankInfo>();
			NewTitleInfo newTitleInfo = NewTitleMgr.FindNewTitle(127);
			if (newTitleInfo != null)
			{
				AddRank(new UserRankInfo
				{
					ID = 0,
					UserID = UserID,
					NewTitleID = newTitleInfo.ID,
					Name = newTitleInfo.Name,
					Attack = newTitleInfo.Att,
					Defence = newTitleInfo.Def,
					Luck = newTitleInfo.Luck,
					Agility = newTitleInfo.Agi,
					HP = 0,
					Damage = 0,
					Guard = 0,
					BeginDate = DateTime.Now,
					EndDate = DateTime.Now.AddDays(30.0),
					Validate = 0,
					IsExit = true
				});
			}
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
				for (int i = 0; i < list_0.Count; i++)
				{
					UserRankInfo userRankInfo = list_0[i];
					if (userRankInfo != null && userRankInfo.IsDirty)
					{
						if (userRankInfo.ID > 0)
						{
							playerBussiness.UpdateUserRank(userRankInfo);
						}
						else
						{
							playerBussiness.AddUserRank(userRankInfo);
						}
					}
				}
			}
		}

		static PlayerRank()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
