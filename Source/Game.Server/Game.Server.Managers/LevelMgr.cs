using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class LevelMgr
	{
		private static readonly ILog ilog_0;

		private static Dictionary<int, LevelInfo> dictionary_0;

		private static ThreadSafeRandom threadSafeRandom_0;

		public static int MaxLevel => dictionary_0.Count;

		public static bool Init()
		{
			try
			{
				dictionary_0 = new Dictionary<int, LevelInfo>();
				threadSafeRandom_0 = new ThreadSafeRandom();
				return smethod_0(dictionary_0);
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("LevelMgr", exception);
				}
				return false;
			}
		}

		public static bool ReLoad()
		{
			try
			{
				Dictionary<int, LevelInfo> level = new Dictionary<int, LevelInfo>();
				if (smethod_0(level))
				{
					try
					{
						dictionary_0 = level;
						return true;
					}
					catch
					{
					}
				}
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("LevelMgr", exception);
				}
			}
			return false;
		}

		private static bool smethod_0(Dictionary<int, LevelInfo> Level)
		{
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				LevelInfo[] allLevel = playerBussiness.GetAllLevel();
				LevelInfo[] array = allLevel;
				foreach (LevelInfo levelInfo in array)
				{
					if (!Level.ContainsKey(levelInfo.Grade))
					{
						Level.Add(levelInfo.Grade, levelInfo);
					}
				}
			}
			return true;
		}

		public static LevelInfo FindLevel(int Grade)
		{
			if (dictionary_0.ContainsKey(Grade))
			{
				return dictionary_0[Grade];
			}
			return null;
		}

		public static int LevelPlusBlood(int Grade)
		{
			if (dictionary_0.ContainsKey(Grade))
			{
				return dictionary_0[Grade].Blood;
			}
			ilog_0.ErrorFormat("Level {0} not found!", Grade);
			return 0;
		}

		public static int GetLevel(int GP)
		{
			if (GP >= FindLevel(MaxLevel).GP)
			{
				return MaxLevel;
			}
			for (int i = 1; i <= MaxLevel; i++)
			{
				if (GP < FindLevel(i).GP)
				{
					if (i - 1 != 0)
					{
						return i - 1;
					}
					return 1;
				}
			}
			return 1;
		}

		public static int GetGP(int level)
		{
			if (MaxLevel > level && level > 0)
			{
				return FindLevel(level - 1).GP;
			}
			return 0;
		}

		public static int ReduceGP(int level, int totalGP)
		{
			if (MaxLevel <= level || level <= 0)
			{
				return 0;
			}
			totalGP -= FindLevel(level - 1).GP;
			if (totalGP >= level * 12)
			{
				return level * 12;
			}
			if (totalGP >= 0)
			{
				return totalGP;
			}
			return 0;
		}

		public static int IncreaseGP(int level, int totalGP)
		{
			if (MaxLevel > level && level > 0)
			{
				return level * 12;
			}
			return 0;
		}

		static LevelMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
