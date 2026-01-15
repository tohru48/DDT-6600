using Game.Base.Packets;
using log4net;
using System;
using System.Collections.Generic;
using System.Reflection;
namespace Center.Server.Managers
{
	public class EntertamentModeMgr
	{
		private static readonly ILog ilog_0;
		private static object object_0;
		private static object object_1;
		private static bool bool_0;
		private static System.DateTime dateTime_0;
		private static System.DateTime dateTime_1;
		private static bool bool_1;
		private static System.Collections.Generic.Dictionary<int, int> dictionary_0;
		public static void CheckOpenOrClose()
		{
			lock (EntertamentModeMgr.object_0)
			{
			}
		}
		public static GSPacketIn SendOpenOrClose(bool sendToAll)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(191);
			gSPacketIn.WriteBoolean(EntertamentModeMgr.bool_0);
			gSPacketIn.WriteDateTime(EntertamentModeMgr.dateTime_0);
			gSPacketIn.WriteDateTime(EntertamentModeMgr.dateTime_1);
			if (sendToAll)
			{
				CenterServer.Instance.method_4(gSPacketIn);
			}
			return gSPacketIn;
		}
		public static GSPacketIn SendGetPoint(int id, int point)
		{
			int num = EntertamentModeMgr.smethod_0(id);
			if (num == -1)
			{
				EntertamentModeMgr.smethod_1(id, point);
			}
			GSPacketIn gSPacketIn = new GSPacketIn(189);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteInt(point);
			return gSPacketIn;
		}
		public static void UpdatePoint(int id, int point)
		{
			lock (EntertamentModeMgr.dictionary_0)
			{
				if (EntertamentModeMgr.dictionary_0.ContainsKey(id))
				{
					System.Collections.Generic.Dictionary<int, int> dictionary;
					(dictionary = EntertamentModeMgr.dictionary_0)[id] = dictionary[id] + point;
				}
				else
				{
					EntertamentModeMgr.dictionary_0.Add(id, point);
				}
			}
		}
		private static int smethod_0(int int_0)
		{
			int result;
			lock (EntertamentModeMgr.dictionary_0)
			{
				if (EntertamentModeMgr.dictionary_0.ContainsKey(int_0))
				{
					result = EntertamentModeMgr.dictionary_0[int_0];
				}
				else
				{
					result = -1;
				}
			}
			return result;
		}
		private static void smethod_1(int int_0, int int_1)
		{
			lock (EntertamentModeMgr.dictionary_0)
			{
				if (!EntertamentModeMgr.dictionary_0.ContainsKey(int_0))
				{
					EntertamentModeMgr.dictionary_0.Add(int_0, int_1);
				}
			}
		}
		public EntertamentModeMgr()
		{
			
			
		}
		static EntertamentModeMgr()
		{
			
			EntertamentModeMgr.ilog_0 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
			EntertamentModeMgr.object_0 = new object();
			EntertamentModeMgr.object_1 = new object();
			EntertamentModeMgr.bool_0 = false;
			EntertamentModeMgr.dateTime_0 = System.DateTime.Now;
			EntertamentModeMgr.dateTime_1 = System.DateTime.Now;
			EntertamentModeMgr.bool_1 = false;
			EntertamentModeMgr.dictionary_0 = new System.Collections.Generic.Dictionary<int, int>();
		}
	}
}
