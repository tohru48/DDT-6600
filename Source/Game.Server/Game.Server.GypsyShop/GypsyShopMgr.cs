using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Threading;
using Bussiness;
using Game.Server.GameObjects;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GypsyShop
{
	public class GypsyShopMgr
	{
		private static readonly ILog ilog_0;

		private static ThreadSafeRandom threadSafeRandom_0;

		protected static Timer _dbTimer;

		private static bool bool_0;

		private static bool bool_1;

		private static Dictionary<int, List<MysteryShopInfo>> dictionary_0;

		[CompilerGenerated]
		private static Func<MysteryShopInfo, int> func_0;

		public static bool OpenOrClose => bool_0;

		public static void BeginTimer()
		{
			int num = 60000;
			if (_dbTimer == null)
			{
				_dbTimer = new Timer(GypsyTimeCheck, null, num, num);
			}
			else
			{
				_dbTimer.Change(num, num);
			}
		}

		protected static void GypsyTimeCheck(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				int num = int.Parse(GameProperties.MysteryShopOpenTime.Split('|')[0]);
				int num2 = int.Parse(GameProperties.MysteryShopOpenTime.Split('|')[1]);
				int hour = DateTime.Now.Hour;
				GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				if (hour >= num2 && hour < num && bool_0)
				{
					bool_0 = false;
					GamePlayer[] array = allPlayers;
					for (int i = 0; i < array.Length; i++)
					{
						array[i]?.Actives.SendGypsyShopOpenClose(open: false);
					}
				}
				else if (hour >= num && !bool_0)
				{
					bool_0 = true;
					GamePlayer[] array2 = allPlayers;
					foreach (GamePlayer gamePlayer in array2)
					{
						if (gamePlayer != null && gamePlayer != null)
						{
							gamePlayer.Actives.ResetMysteryShop();
							gamePlayer.Actives.SendGypsyShopOpenClose(open: true);
						}
					}
				}
				int mysteryShopFreshTime = GameProperties.MysteryShopFreshTime;
				if (mysteryShopFreshTime == hour && !bool_1)
				{
					bool_1 = true;
					GamePlayer[] array3 = allPlayers;
					foreach (GamePlayer gamePlayer2 in array3)
					{
						if (gamePlayer2 != null)
						{
							gamePlayer2?.Actives.RefreshMysteryShopByHour();
						}
					}
				}
				if (hour != mysteryShopFreshTime && bool_1)
				{
					bool_1 = false;
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
			}
			catch (Exception ex)
			{
				Console.WriteLine("Gypsy TimeCheck: " + ex);
			}
		}

		public static void StopAllTimer()
		{
			if (_dbTimer != null)
			{
				_dbTimer.Dispose();
				_dbTimer = null;
			}
		}

		public static bool Init()
		{
			try
			{
				bool_0 = false;
				threadSafeRandom_0 = new ThreadSafeRandom();
				MysteryShopInfo[] array = LoadMysteryShopDb();
				Dictionary<int, List<MysteryShopInfo>> value = LoadMysteryShops(array);
				if (array.Length > 0)
				{
					Interlocked.Exchange(ref dictionary_0, value);
				}
				return true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("ReLoad MysteryShop", exception);
				}
				return false;
			}
			finally
			{
				BeginTimer();
			}
		}

		public static MysteryShopInfo[] LoadMysteryShopDb()
		{
			using ProduceBussiness produceBussiness = new ProduceBussiness();
			return produceBussiness.GetAllMysteryShop();
		}

		public static Dictionary<int, List<MysteryShopInfo>> LoadMysteryShops(MysteryShopInfo[] MysteryShop)
		{
			Dictionary<int, List<MysteryShopInfo>> dictionary = new Dictionary<int, List<MysteryShopInfo>>();
			foreach (MysteryShopInfo info in MysteryShop)
			{
				if (!dictionary.Keys.Contains(info.LableType))
				{
					IEnumerable<MysteryShopInfo> source = MysteryShop.Where((MysteryShopInfo s) => s.LableType == info.LableType);
					dictionary.Add(info.LableType, source.ToList());
				}
			}
			return dictionary;
		}

		public static List<MysteryShopInfo> FindMysteryShop(int LableType)
		{
			List<MysteryShopInfo> list = new List<MysteryShopInfo>();
			if (dictionary_0.ContainsKey(LableType))
			{
				List<MysteryShopInfo> list2 = dictionary_0[LableType];
				foreach (MysteryShopInfo item in list2)
				{
					list.Add(item);
				}
			}
			return list;
		}

		public static List<MysteryShopInfo> GetRateMysteryShop()
		{
			List<MysteryShopInfo> list = new List<MysteryShopInfo>();
			List<MysteryShopInfo> list2 = FindMysteryShop(2);
			int num = ((list2.Count > 6) ? 6 : list2.Count);
			for (int i = 0; i < num; i++)
			{
				MysteryShopInfo item = list2[i];
				list.Add(item);
			}
			return list;
		}

		public static List<MysteryShopInfo> GetMysteryShop()
		{
			List<MysteryShopInfo> list = new List<MysteryShopInfo>();
			int num = 0;
			while (list.Count < 8)
			{
				List<MysteryShopInfo> rateAward = GetRateAward();
				foreach (MysteryShopInfo item in rateAward)
				{
					list.Add(item);
				}
				num++;
			}
			return list;
		}

		public static List<MysteryShopInfo> GetRateAward()
		{
			List<MysteryShopInfo> list = new List<MysteryShopInfo>();
			List<MysteryShopInfo> list2 = FindMysteryShop(1);
			int num = 1;
			IEnumerable<MysteryShopInfo> source = list2;
			int maxRound = ThreadSafeRandom.NextStatic(source.Select((MysteryShopInfo mysteryShopInfo_0) => mysteryShopInfo_0.Random).Max());
			List<MysteryShopInfo> list3 = list2.Where((MysteryShopInfo s) => s.Random >= maxRound).ToList();
			int num2 = list3.Count();
			if (num2 > 0)
			{
				num = ((num > num2) ? num2 : num);
				int[] randomUnrepeatArray = GetRandomUnrepeatArray(0, num2 - 1, num);
				int[] array = randomUnrepeatArray;
				foreach (int index in array)
				{
					MysteryShopInfo item = list3[index];
					list.Add(item);
				}
			}
			return list;
		}

		public static int[] GetRandomUnrepeatArray(int minValue, int maxValue, int count)
		{
			int[] array = new int[count];
			for (int i = 0; i < count; i++)
			{
				int num = threadSafeRandom_0.Next(minValue, maxValue + 1);
				int num2 = 0;
				for (int j = 0; j < i; j++)
				{
					if (array[j] == num)
					{
						num2++;
					}
				}
				if (num2 == 0)
				{
					array[i] = num;
				}
				else
				{
					i--;
				}
			}
			return array;
		}

		[CompilerGenerated]
		private static int smethod_0(MysteryShopInfo mysteryShopInfo_0)
		{
			return mysteryShopInfo_0.Random;
		}

		static GypsyShopMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			dictionary_0 = new Dictionary<int, List<MysteryShopInfo>>();
		}
	}
}
