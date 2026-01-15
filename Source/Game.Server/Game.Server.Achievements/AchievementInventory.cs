using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class AchievementInventory
	{
		private static readonly ILog ilog_0;

		private object object_0;

		protected List<BaseAchievement> m_list;

		private Dictionary<int, AchievementDataInfo> dictionary_0;

		private GamePlayer gamePlayer_0;

		protected List<BaseAchievement> m_changedAchs;

		private int int_0;

		public AchievementInventory(GamePlayer player)
		{
			m_changedAchs = new List<BaseAchievement>();
			gamePlayer_0 = player;
			object_0 = new object();
			m_list = new List<BaseAchievement>();
			dictionary_0 = new Dictionary<int, AchievementDataInfo>();
		}

		public void LoadFromDatabase(int playerId)
		{
			lock (object_0)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				AchievementDataInfo[] allAchievementData = playerBussiness.GetAllAchievementData(playerId);
				method_4();
				AchievementDataInfo[] array = allAchievementData;
				foreach (AchievementDataInfo achievementDataInfo in array)
				{
					if (achievementDataInfo.IsComplete)
					{
						dictionary_0.Add(achievementDataInfo.AchievementID, achievementDataInfo);
						continue;
					}
					AchievementInfo singleAchievement = AchievementMgr.GetSingleAchievement(achievementDataInfo.AchievementID);
					if (singleAchievement != null)
					{
						method_0(new BaseAchievement(singleAchievement, achievementDataInfo));
					}
				}
				AddAchievementPre();
				method_5();
			}
		}

		public void SaveToDatabase()
		{
			lock (object_0)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				foreach (AchievementDataInfo value in dictionary_0.Values)
				{
					if (value.IsDirty)
					{
						playerBussiness.UpdateAchievementData(value);
					}
				}
			}
		}

		public bool Finish(BaseAchievement baseAch)
		{
			AchievementInfo ınfo = baseAch.Info;
			AchievementDataInfo data = baseAch.Data;
			gamePlayer_0.BeginAllChanges();
			try
			{
				if (baseAch.Finish(gamePlayer_0))
				{
					List<AchievementRewardInfo> list = new List<AchievementRewardInfo>();
					foreach (AchievementRewardInfo item in list)
					{
						int rewardType = item.RewardType;
						if (rewardType == 1)
						{
							gamePlayer_0.Rank.AddAchievementRank(item.RewardPara);
						}
					}
					if (ınfo.AchievementPoint != 0)
					{
						gamePlayer_0.AddAchievementPoint(ınfo.AchievementPoint);
					}
					SendAchievementSuccess(data);
					if (list.Count > 0)
					{
						gamePlayer_0.Rank.UpdateRank();
					}
					method_3(data);
					gamePlayer_0.OnAchievementFinish(data);
					method_1(data.AchievementID);
					RemoveAchievement(baseAch);
				}
			}
			catch (Exception ex)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("Achivement Finish：" + ex);
				}
				return false;
			}
			finally
			{
				gamePlayer_0.CommitAllChanges();
			}
			return true;
		}

		public bool RemoveAchievement(BaseAchievement ach)
		{
			ach.RemoveFromPlayer(gamePlayer_0);
			return true;
		}

		public void AddAchievementPre()
		{
			List<AchievementInfo> list = AchievementMgr.Achievement.Values.ToList();
			foreach (AchievementInfo item in list)
			{
				if (FindAchievement(item.ID) == null && !method_2(item.ID))
				{
					AddAchievement(item);
				}
			}
		}

		private bool method_0(BaseAchievement baseAchievement_0)
		{
			lock (m_list)
			{
				m_list.Add(baseAchievement_0);
			}
			OnAchievementsChanged(baseAchievement_0);
			baseAchievement_0.AddToPlayer(gamePlayer_0);
			if (baseAchievement_0.CanCompleted(gamePlayer_0))
			{
				Finish(baseAchievement_0);
			}
			return true;
		}

		private void method_1(int int_1)
		{
			List<AchievementInfo> list = new List<AchievementInfo>();
			foreach (AchievementInfo item in list)
			{
				if (!(item.PreAchievementID != "0,"))
				{
					continue;
				}
				string[] array = item.PreAchievementID.Split(',');
				string[] array2 = array;
				foreach (string text in array2)
				{
					if (text != null && text != "")
					{
						AchievementInfo singleAchievement = AchievementMgr.GetSingleAchievement(int.Parse(text));
						if (singleAchievement != null && singleAchievement.ID == int_1)
						{
							AddAchievement(item);
							break;
						}
					}
				}
			}
		}

		public bool AddAchievement(AchievementInfo info)
		{
			try
			{
				if (info == null || gamePlayer_0.PlayerCharacter.Grade < info.NeedMinLevel || gamePlayer_0.PlayerCharacter.Grade > info.NeedMaxLevel)
				{
					return false;
				}
				if (info.PreAchievementID != "0,")
				{
					string[] array = info.PreAchievementID.Split(',');
					for (int i = 0; i < array.Length - 1; i++)
					{
						if (!method_2(Convert.ToInt32(array[i])))
						{
							return false;
						}
					}
				}
			}
			catch (Exception ex)
			{
				ilog_0.Info(ex.InnerException);
			}
			BaseAchievement baseAchievement = FindAchievement(info.ID);
			if (baseAchievement != null)
			{
				return false;
			}
			method_4();
			baseAchievement = new BaseAchievement(info, new AchievementDataInfo());
			method_0(baseAchievement);
			method_5();
			return true;
		}

		private bool method_2(int int_1)
		{
			lock (dictionary_0)
			{
				if (dictionary_0.ContainsKey(int_1))
				{
					return true;
				}
				return false;
			}
		}

		private void method_3(AchievementDataInfo achievementDataInfo_0)
		{
			lock (dictionary_0)
			{
				if (!dictionary_0.ContainsKey(achievementDataInfo_0.AchievementID))
				{
					dictionary_0.Add(achievementDataInfo_0.AchievementID, achievementDataInfo_0);
				}
			}
		}

		public BaseAchievement FindAchievement(int id)
		{
			foreach (BaseAchievement item in m_list)
			{
				if (item.Info.ID == id)
				{
					return item;
				}
			}
			return null;
		}

		public List<AchievementDataInfo> GetSuccessAchievement()
		{
			lock (dictionary_0)
			{
				return dictionary_0.Values.ToList();
			}
		}

		public AchievementDataInfo GetSuccessAchievement(int achid)
		{
			lock (dictionary_0)
			{
				if (dictionary_0.ContainsKey(achid))
				{
					return dictionary_0[achid];
				}
				return null;
			}
		}

		protected void OnAchievementsChanged(BaseAchievement ach)
		{
			if (!m_changedAchs.Contains(ach))
			{
				m_changedAchs.Add(ach);
			}
			if (int_0 <= 0 && m_changedAchs.Count > 0)
			{
				UpdateChangedAchievements();
			}
		}

		private void method_4()
		{
			Interlocked.Increment(ref int_0);
		}

		private void method_5()
		{
			int num = Interlocked.Decrement(ref int_0);
			if (num < 0)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
				}
				Thread.VolatileWrite(ref int_0, 0);
			}
			if (num <= 0 && m_changedAchs.Count > 0)
			{
				UpdateChangedAchievements();
			}
		}

		public void UpdateChangedAchievements()
		{
			m_changedAchs.Clear();
		}

		public GSPacketIn SendAchievementSuccess(AchievementDataInfo info)
		{
			if (gamePlayer_0 != null && info != null)
			{
				int year = DateTime.Now.Year;
				int month = DateTime.Now.Month;
				int day = DateTime.Now.Day;
				GSPacketIn gSPacketIn = new GSPacketIn(230, gamePlayer_0.PlayerCharacter.ID);
				gSPacketIn.WriteInt(info.AchievementID);
				gSPacketIn.WriteInt(year);
				gSPacketIn.WriteInt(month);
				gSPacketIn.WriteInt(day);
				return gSPacketIn;
			}
			return null;
		}

		public void Update(BaseAchievement ach)
		{
			OnAchievementsChanged(ach);
		}

		static AchievementInventory()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
