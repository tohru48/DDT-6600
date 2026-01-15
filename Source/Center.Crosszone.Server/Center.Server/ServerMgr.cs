using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
namespace Center.Server
{
	public class ServerMgr
	{
		private static readonly ILog ilog_0;
		private static System.Collections.Generic.Dictionary<int, ServerInfo> dictionary_0;
		private static object object_0;
		public static ServerInfo[] Servers
		{
			get
			{
				return ServerMgr.dictionary_0.Values.ToArray<ServerInfo>();
			}
		}
		public static bool Start()
		{
			bool result;
			try
			{
				using (ServiceBussiness serviceBussiness = new ServiceBussiness())
				{
					ServerInfo[] serverList = serviceBussiness.GetServerList();
					ServerInfo[] array = serverList;
					for (int i = 0; i < array.Length; i++)
					{
						ServerInfo serverInfo = array[i];
						serverInfo.State = 1;
						serverInfo.Online = 0;
						ServerMgr.dictionary_0.Add(serverInfo.ID, serverInfo);
					}
				}
				ServerMgr.ilog_0.Info("Load server list from db.");
				result = true;
			}
			catch (System.Exception ex)
			{
				ServerMgr.ilog_0.ErrorFormat("Load server list from db failed:{0}", ex);
				result = false;
			}
			return result;
		}
		public static bool ReLoadServerList()
		{
			bool result;
			try
			{
				using (ServiceBussiness serviceBussiness = new ServiceBussiness())
				{
					lock (ServerMgr.object_0)
					{
						ServerInfo[] serverList = serviceBussiness.GetServerList();
						ServerInfo[] array = serverList;
						for (int i = 0; i < array.Length; i++)
						{
							ServerInfo serverInfo = array[i];
							if (ServerMgr.dictionary_0.ContainsKey(serverInfo.ID))
							{
								ServerMgr.dictionary_0[serverInfo.ID].IP = serverInfo.IP;
								ServerMgr.dictionary_0[serverInfo.ID].Name = serverInfo.Name;
								ServerMgr.dictionary_0[serverInfo.ID].Port = serverInfo.Port;
								ServerMgr.dictionary_0[serverInfo.ID].Room = serverInfo.Room;
								ServerMgr.dictionary_0[serverInfo.ID].Total = serverInfo.Total;
								ServerMgr.dictionary_0[serverInfo.ID].MustLevel = serverInfo.MustLevel;
								ServerMgr.dictionary_0[serverInfo.ID].LowestLevel = serverInfo.LowestLevel;
								ServerMgr.dictionary_0[serverInfo.ID].Online = serverInfo.Online;
								ServerMgr.dictionary_0[serverInfo.ID].State = serverInfo.State;
							}
							else
							{
								serverInfo.State = 1;
								serverInfo.Online = 0;
								ServerMgr.dictionary_0.Add(serverInfo.ID, serverInfo);
							}
						}
					}
				}
				ServerMgr.ilog_0.Info("ReLoad server list from db.");
				result = true;
			}
			catch (System.Exception ex)
			{
				ServerMgr.ilog_0.ErrorFormat("ReLoad server list from db failed:{0}", ex);
				result = false;
			}
			return result;
		}
		public static ServerInfo GetServerInfo(int id)
		{
			if (ServerMgr.dictionary_0.ContainsKey(id))
			{
				return ServerMgr.dictionary_0[id];
			}
			return null;
		}
		public static int GetState(int count, int total)
		{
			if (count >= total)
			{
				return 5;
			}
			if ((double)count > (double)total * 0.5)
			{
				return 4;
			}
			return 2;
		}
		public ServerMgr()
		{
			
			
		}
		static ServerMgr()
		{
			
			ServerMgr.ilog_0 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
			ServerMgr.dictionary_0 = new System.Collections.Generic.Dictionary<int, ServerInfo>();
			ServerMgr.object_0 = new object();
		}
	}
}
