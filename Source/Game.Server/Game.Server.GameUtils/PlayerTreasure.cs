using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerTreasure
	{
		private static readonly ILog ilog_0;

		protected object m_lock;

		protected GamePlayer m_player;

		private List<TreasureDataInfo> list_0;

		private List<TreasureDataInfo> OfdnHocvNY;

		private UserTreasureInfo userTreasureInfo_0;

		private bool bool_0;

		public GamePlayer Player => m_player;

		public List<TreasureDataInfo> TreasureData
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

		public List<TreasureDataInfo> TreasureDig
		{
			get
			{
				return OfdnHocvNY;
			}
			set
			{
				OfdnHocvNY = value;
			}
		}

		public UserTreasureInfo CurrentTreasure
		{
			get
			{
				return userTreasureInfo_0;
			}
			set
			{
				userTreasureInfo_0 = value;
			}
		}

		public PlayerTreasure(GamePlayer player, bool saveTodb)
		{
			m_lock = new object();
			m_player = player;
			bool_0 = saveTodb;
			list_0 = new List<TreasureDataInfo>();
			OfdnHocvNY = new List<TreasureDataInfo>();
			userTreasureInfo_0 = new UserTreasureInfo();
		}

		public virtual void LoadFromDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			userTreasureInfo_0 = playerBussiness.GetSingleTreasure(Player.PlayerCharacter.ID);
			List<TreasureDataInfo> singleTreasureData = playerBussiness.GetSingleTreasureData(Player.PlayerCharacter.ID);
			if (userTreasureInfo_0 == null)
			{
				CreateTreasure();
			}
			foreach (TreasureDataInfo item in singleTreasureData)
			{
				list_0.Add(item);
				if (item.pos > 0)
				{
					OfdnHocvNY.Add(item);
				}
			}
		}

		public void CreateTreasure()
		{
			if (userTreasureInfo_0 == null)
			{
				userTreasureInfo_0 = new UserTreasureInfo();
			}
			lock (userTreasureInfo_0)
			{
				userTreasureInfo_0.ID = 0;
				userTreasureInfo_0.UserID = Player.PlayerCharacter.ID;
				userTreasureInfo_0.NickName = Player.PlayerCharacter.NickName;
				userTreasureInfo_0.treasure = 1;
				userTreasureInfo_0.treasureAdd = 0;
				userTreasureInfo_0.logoinDays = 1;
				userTreasureInfo_0.friendHelpTimes = 0;
				userTreasureInfo_0.isBeginTreasure = false;
				userTreasureInfo_0.isEndTreasure = false;
				userTreasureInfo_0.LastLoginDay = DateTime.Now;
			}
		}

		public void AddfriendHelpTimes()
		{
			lock (userTreasureInfo_0)
			{
				if (userTreasureInfo_0.friendHelpTimes < 5)
				{
					userTreasureInfo_0.friendHelpTimes++;
					if (userTreasureInfo_0.friendHelpTimes == 5 && userTreasureInfo_0.treasureAdd == 0)
					{
						userTreasureInfo_0.treasureAdd++;
					}
				}
			}
		}

		public void UpdateUserTreasure(UserTreasureInfo info)
		{
			lock (userTreasureInfo_0)
			{
				userTreasureInfo_0 = info;
			}
		}

		public void Clear()
		{
			lock (OfdnHocvNY)
			{
				OfdnHocvNY = new List<TreasureDataInfo>();
			}
		}

		public void UpdateLoginDay()
		{
			int ıD = Player.PlayerCharacter.ID;
			List<TreasureDataInfo> list = list_0;
			if (list.Count == 0)
			{
				list = TreasureAwardMgr.CreateTreasureData(ıD);
				AddTreasureData(list);
			}
			else if (userTreasureInfo_0.isValidDate())
			{
				list = TreasureAwardMgr.CreateTreasureData(ıD);
				UpdateTreasureData(list);
				Clear();
			}
			lock (userTreasureInfo_0)
			{
				if (userTreasureInfo_0.isValidDate())
				{
					if ((int)DateTime.Now.Subtract(userTreasureInfo_0.LastLoginDay).TotalDays > 1)
					{
						userTreasureInfo_0.logoinDays = 0;
					}
					userTreasureInfo_0.logoinDays++;
					if (userTreasureInfo_0.logoinDays > 3)
					{
						userTreasureInfo_0.treasure = 3;
					}
					else
					{
						userTreasureInfo_0.treasure = userTreasureInfo_0.logoinDays;
					}
					userTreasureInfo_0.treasureAdd = 0;
					userTreasureInfo_0.friendHelpTimes = 0;
					userTreasureInfo_0.isBeginTreasure = false;
					userTreasureInfo_0.isEndTreasure = false;
					userTreasureInfo_0.LastLoginDay = DateTime.Now;
				}
			}
		}

		public void AddTreasureData(List<TreasureDataInfo> datas)
		{
			lock (list_0)
			{
				foreach (TreasureDataInfo data in datas)
				{
					list_0.Add(data);
				}
			}
		}

		public void UpdateTreasureData(List<TreasureDataInfo> datas)
		{
			for (int i = 0; i < list_0.Count; i++)
			{
				datas[i].ID = list_0[i].ID;
			}
			lock (list_0)
			{
				list_0 = datas;
			}
		}

		public void AddTreasureDig(TreasureDataInfo info, int index)
		{
			bool lockTaken = false;
			List<TreasureDataInfo> ofdnHocvNY = default(List<TreasureDataInfo>);
			try
			{
				Monitor.Enter(ofdnHocvNY = OfdnHocvNY, ref lockTaken);
				OfdnHocvNY.Add(info);
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(ofdnHocvNY);
				}
			}
			bool lockTaken2 = false;
			try
			{
				Monitor.Enter(ofdnHocvNY = list_0, ref lockTaken2);
				list_0[index].pos = info.pos;
			}
			finally
			{
				if (lockTaken2)
				{
					Monitor.Exit(ofdnHocvNY);
				}
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
				if (userTreasureInfo_0 != null && userTreasureInfo_0.IsDirty)
				{
					if (userTreasureInfo_0.ID > 0)
					{
						playerBussiness.UpdateUserTreasureInfo(userTreasureInfo_0);
					}
					else
					{
						playerBussiness.AddUserTreasureInfo(userTreasureInfo_0);
					}
				}
				for (int i = 0; i < list_0.Count; i++)
				{
					TreasureDataInfo treasureDataInfo = list_0[i];
					if (treasureDataInfo != null && treasureDataInfo.IsDirty)
					{
						if (treasureDataInfo.ID > 0)
						{
							playerBussiness.UpdateTreasureData(treasureDataInfo);
						}
						else
						{
							playerBussiness.AddTreasureData(treasureDataInfo);
						}
					}
				}
			}
		}

		static PlayerTreasure()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
