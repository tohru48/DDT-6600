using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Xml.Linq;
using Game.Server.Rooms;
using log4net;

namespace Game.Server.Battle
{
	public class BattleMgr
	{
		public static readonly ILog log;

		public static List<BattleServer> m_list;

		public static bool AutoReconnect;

		public static bool Setup()
		{
			if (File.Exists("battle.xml"))
			{
				try
				{
					XDocument xDocument = XDocument.Load("battle.xml");
					foreach (XElement item in xDocument.Root.Nodes())
					{
						try
						{
							int serverId = int.Parse(item.Attribute("id").Value);
							string value = item.Attribute("ip").Value;
							int num = int.Parse(item.Attribute("port").Value);
							string value2 = item.Attribute("key").Value;
							AddBattleServer(new BattleServer(serverId, value, num, value2));
							log.InfoFormat("Battle server {0}:{1} loaded...", value, num);
						}
						catch (Exception exception)
						{
							log.Error("BattleMgr setup error:", exception);
						}
					}
				}
				catch (Exception exception2)
				{
					log.Error("BattleMgr setup error:", exception2);
				}
			}
			log.InfoFormat("Total {0} battle server loaded.", m_list.Count);
			return true;
		}

		public static void AddBattleServer(BattleServer battle)
		{
			if (battle != null)
			{
				m_list.Add(battle);
				battle.Disconnected += smethod_0;
			}
		}

		private static void smethod_0(object sender, EventArgs e)
		{
			BattleServer battleServer = sender as BattleServer;
			log.WarnFormat("Disconnect from battle server {0}:{1}", battleServer.Ip, battleServer.Port);
			if (battleServer == null || !AutoReconnect || !m_list.Contains(battleServer))
			{
				return;
			}
			RemoveServer(battleServer);
			if ((DateTime.Now - battleServer.LastRetryTime).TotalMinutes > 3.0)
			{
				battleServer.RetryCount = 0;
			}
			if (battleServer.RetryCount < 3)
			{
				BattleServer battleServer2 = battleServer.Clone();
				AddBattleServer(battleServer2);
				battleServer2.RetryCount++;
				battleServer2.LastRetryTime = DateTime.Now;
				try
				{
					battleServer2.Start();
				}
				catch (Exception ex)
				{
					log.ErrorFormat("Batter server {0}:{1} can't connected!", battleServer.Ip, battleServer.Port);
					log.Error(ex.Message);
					battleServer.RetryCount = 0;
				}
			}
		}

		public static void ConnectTo(int id, string ip, int port, string key)
		{
			BattleServer battleServer = new BattleServer(id, ip, port, key);
			AddBattleServer(battleServer);
			try
			{
				battleServer.Start();
			}
			catch (Exception ex)
			{
				log.ErrorFormat("Batter server {0}:{1} can't connected!", battleServer.Ip, battleServer.Port);
				log.Error(ex.Message);
			}
		}

		public static void Disconnet(int id)
		{
			BattleServer server = GetServer(id);
			if (server != null && server.IsActive)
			{
				server.LastRetryTime = DateTime.Now;
				server.RetryCount = 4;
				server.Connector.Disconnect();
			}
		}

		public static void RemoveServer(BattleServer server)
		{
			if (server != null)
			{
				m_list.Remove(server);
				server.Disconnected += smethod_0;
			}
		}

		public static BattleServer GetServer(int id)
		{
			foreach (BattleServer item in m_list)
			{
				if (item.ServerId == id)
				{
					return item;
				}
			}
			return null;
		}

		public static void Start()
		{
			foreach (BattleServer item in m_list)
			{
				try
				{
					item.Start();
				}
				catch (Exception ex)
				{
					log.ErrorFormat("Batter server {0}:{1} can't connected!", item.Ip, item.Port);
					log.Error(ex.Message);
				}
			}
		}

		public static BattleServer FindActiveServer(bool isCrosszone)
		{
			lock (m_list)
			{
				foreach (BattleServer item in m_list)
				{
					if (isCrosszone && item.ServerId == 2 && item.IsActive)
					{
						return item;
					}
					if (!isCrosszone && item.IsActive)
					{
						return item;
					}
				}
			}
			return null;
		}

		public static BattleServer AddRoom(BaseRoom room)
		{
			BattleServer battleServer = FindActiveServer(room.isCrosszone);
			if (battleServer != null && battleServer.AddRoom(room))
			{
				return battleServer;
			}
			return null;
		}

		public static List<BattleServer> GetAllBattles()
		{
			return m_list;
		}

		static BattleMgr()
		{
			log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			m_list = new List<BattleServer>();
			AutoReconnect = true;
		}
	}
}
