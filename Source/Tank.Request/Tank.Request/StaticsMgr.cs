using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Web;
using log4net;
using Tank.Request.CelebList;

namespace Tank.Request
{
	public static class StaticsMgr
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private static Timer _timer;

		private static object _locker = new object();

		private static List<string> _list = new List<string>();

		private static int RegCount = 0;

		private static int pid;

		private static int did;

		private static int sid;

		private static string _path;

		private static long _interval;

		private static int CelebBuildDay;

		public static string CurrentPath;

		public static void Setup()
		{
			CurrentPath = HttpContext.Current.Server.MapPath("~");
			CelebBuildDay = DateTime.Now.Day;
			pid = int.Parse(ConfigurationManager.AppSettings["PID"]);
			did = int.Parse(ConfigurationManager.AppSettings["DID"]);
			sid = int.Parse(ConfigurationManager.AppSettings["SID"]);
			_path = ConfigurationManager.AppSettings["LogPath"];
			_interval = int.Parse(ConfigurationManager.AppSettings["LogInterval"]) * 60 * 1000;
			_timer = new Timer(OnTimer, null, 0L, _interval);
		}

		private static void OnTimer(object state)
		{
			try
			{
				bool lockTaken = false;
				object locker = default(object);
				try
				{
					locker = _locker;
					Monitor.Enter(locker, ref lockTaken);
					if (_list.Count > 0)
					{
						string path = $"{_path}\\payment-{pid:D2}{did:D2}{sid:D2}-{DateTime.Now:yyyyMMdd}.log";
						using FileStream fileStream = File.Open(path, FileMode.Append);
						using StreamWriter streamWriter = new StreamWriter(fileStream);
						while (_list.Count != 0)
						{
							streamWriter.WriteLine(_list[0]);
							_list.RemoveAt(0);
						}
					}
					if (RegCount > 0)
					{
						string path2 = $"{_path}\\reg-{pid:D2}{did:D2}{sid:D2}-{DateTime.Now:yyyyMMdd}.log";
						using FileStream fileStream2 = File.Open(path2, FileMode.Append);
						using StreamWriter streamWriter2 = new StreamWriter(fileStream2);
						string value = string.Format("{0},{1},{2},{3},{4}", pid, did, sid, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), RegCount);
						streamWriter2.WriteLine(value);
						RegCount = 0;
					}
				}
				finally
				{
					if (lockTaken)
					{
						Monitor.Exit(locker);
					}
				}
			}
			catch (Exception exception)
			{
				log.Error("Save log error", exception);
			}
			if (CelebBuildDay != DateTime.Now.Day && DateTime.Now.Hour > 2 && DateTime.Now.Hour < 6)
			{
				CelebBuildDay = DateTime.Now.Day;
				StringBuilder stringBuilder = new StringBuilder();
				try
				{
					stringBuilder.Append(CelebByGpList.Build());
					stringBuilder.Append(CelebByDayGPList.Build());
					stringBuilder.Append(CelebByWeekGPList.Build());
					stringBuilder.Append(CelebByOfferList.Build());
					stringBuilder.Append(CelebByDayOfferList.Build());
					stringBuilder.Append(CelebByWeekOfferList.Build());
					stringBuilder.Append(CelebByConsortiaRiches.Build());
					stringBuilder.Append(CelebByConsortiaDayRiches.Build());
					stringBuilder.Append(CelebByConsortiaWeekRiches.Build());
					stringBuilder.Append(CelebByConsortiaHonor.Build());
					stringBuilder.Append(CelebByConsortiaDayHonor.Build());
					stringBuilder.Append(CelebByConsortiaWeekHonor.Build());
					stringBuilder.Append(CelebByConsortiaLevel.Build());
					stringBuilder.Append(CelebByDayBestEquip.Build());
				}
				catch (Exception exception2)
				{
					stringBuilder.Append("CelebByList is Error!");
					log.Error(stringBuilder.ToString(), exception2);
				}
			}
		}

		public static void Log(DateTime dt, string username, bool sex, int money, string payway, decimal needMoney)
		{
			string item = string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8}", pid, did, sid, dt.ToString("yyyy-MM-dd HH:mm:ss"), username, sex ? 1 : 0, money, payway, needMoney);
			bool lockTaken = false;
			object locker = default(object);
			try
			{
				locker = _locker;
				Monitor.Enter(locker, ref lockTaken);
				_list.Add(item);
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(locker);
				}
			}
		}

		public static void RegCountAdd()
		{
			bool lockTaken = false;
			object locker = default(object);
			try
			{
				locker = _locker;
				Monitor.Enter(locker, ref lockTaken);
				RegCount++;
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(locker);
				}
			}
		}

		public static void Stop()
		{
			_timer.Dispose();
			OnTimer(null);
		}
	}
}
