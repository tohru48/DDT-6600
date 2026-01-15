using System;
using System.Collections.Generic;
using System.Configuration;
using System.Reflection;
using System.Threading;
using log4net;

namespace Tank.Request
{
	public class PlayerManager
	{
		private class PlayerData
		{
			public string Name;

			public string Pass;

			public DateTime Date;

			public int Count;
		}

		private static Dictionary<string, PlayerData> m_players = new Dictionary<string, PlayerData>();

		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private static object sys_obj = new object();

		private static Timer m_timer;

		private static int m_timeout = 3000;

		public static void Setup()
		{
			m_timeout = int.Parse(ConfigurationManager.AppSettings["LoginSessionTimeOut"]);
			m_timer = new Timer(CheckTimerCallback, null, 0, 60000);
		}

		protected static bool CheckTimeOut(DateTime dt)
		{
			return (DateTime.Now - dt).TotalMinutes > (double)m_timeout;
		}

		private static void CheckTimerCallback(object state)
		{
			bool lockTaken = false;
			object obj = default(object);
			try
			{
				obj = sys_obj;
				Monitor.Enter(obj, ref lockTaken);
				List<string> list = new List<string>();
				foreach (PlayerData current in m_players.Values)
				{
					if (CheckTimeOut(current.Date))
					{
						list.Add(current.Name);
					}
				}
				foreach (string current2 in list)
				{
					m_players.Remove(current2);
				}
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(obj);
				}
			}
		}

		public static void Add(string name, string pass)
		{
			bool lockTaken = false;
			object obj = default(object);
			try
			{
				obj = sys_obj;
				Monitor.Enter(obj, ref lockTaken);
				if (m_players.ContainsKey(name))
				{
					m_players[name].Name = name;
					m_players[name].Pass = pass;
					m_players[name].Date = DateTime.Now;
					m_players[name].Count = 0;
				}
				else
				{
					PlayerData playerData = new PlayerData();
					playerData.Name = name;
					playerData.Pass = pass;
					playerData.Date = DateTime.Now;
					m_players.Add(name, playerData);
				}
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(obj);
				}
			}
		}

		public static bool Login(string name, string pass)
		{
			bool lockTaken = false;
			object obj = default(object);
			try
			{
				obj = sys_obj;
				Monitor.Enter(obj, ref lockTaken);
				if (m_players.ContainsKey(name))
				{
					PlayerData playerData = m_players[name];
					if (playerData.Pass != pass || CheckTimeOut(playerData.Date))
					{
						return false;
					}
					return true;
				}
				return false;
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(obj);
				}
			}
		}

		public static bool Update(string name, string pass)
		{
			bool lockTaken = false;
			object obj = default(object);
			try
			{
				obj = sys_obj;
				Monitor.Enter(obj, ref lockTaken);
				if (m_players.ContainsKey(name))
				{
					m_players[name].Pass = pass;
					PlayerData playerData = m_players[name];
					playerData.Count++;
					return true;
				}
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(obj);
				}
			}
			return false;
		}

		public static bool Remove(string name)
		{
			bool lockTaken = false;
			object obj = default(object);
			try
			{
				obj = sys_obj;
				Monitor.Enter(obj, ref lockTaken);
				return m_players.Remove(name);
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(obj);
				}
			}
		}

		public static bool GetByUserIsFirst(string name)
		{
			bool lockTaken = false;
			object obj = default(object);
			try
			{
				obj = sys_obj;
				Monitor.Enter(obj, ref lockTaken);
				if (m_players.ContainsKey(name))
				{
					return m_players[name].Count == 0;
				}
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(obj);
				}
			}
			return false;
		}
	}
}
