using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using Bussiness;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class ActiveSystermAwardMgr
	{
		private static readonly ILog imtzRqviW;

		private static Dictionary<int, List<TreasurePuzzleRewardInfo>> dictionary_0;

		private static Dictionary<int, List<BoguAdventureRewardInfo>> dictionary_1;

		private static ThreadSafeRandom threadSafeRandom_0;

		public static bool ReLoad()
		{
			bool result;
			try
			{
				TreasurePuzzleRewardInfo[] array = LoadTreasurePuzzleRewardDb();
				Dictionary<int, List<TreasurePuzzleRewardInfo>> value = LoadTreasurePuzzleRewards(array);
				if (array.Length > 0)
				{
					Interlocked.Exchange(ref dictionary_0, value);
				}
				BoguAdventureRewardInfo[] array2 = LoadBoguAdventureRewardDb();
				Dictionary<int, List<BoguAdventureRewardInfo>> value2 = LoadBoguAdventureRewards(array2);
				if (array2.Length > 0)
				{
					Interlocked.Exchange(ref dictionary_1, value2);
				}
				return true;
			}
			catch (Exception exception)
			{
				if (imtzRqviW.IsErrorEnabled)
				{
					imtzRqviW.Error("ReLoad ActiveSystermAwardMgr", exception);
				}
				result = false;
			}
			return result;
		}

		public static bool Init()
		{
			return ReLoad();
		}

		public static BoguAdventureRewardInfo[] LoadBoguAdventureRewardDb()
		{
			using ProduceBussiness produceBussiness = new ProduceBussiness();
			return produceBussiness.GetAllBoguAdventureReward();
		}

		public static Dictionary<int, List<BoguAdventureRewardInfo>> LoadBoguAdventureRewards(BoguAdventureRewardInfo[] BoguAdventureReward)
		{
			Dictionary<int, List<BoguAdventureRewardInfo>> dictionary = new Dictionary<int, List<BoguAdventureRewardInfo>>();
			foreach (BoguAdventureRewardInfo info in BoguAdventureReward)
			{
				if (!dictionary.Keys.Contains(info.AwardID))
				{
					IEnumerable<BoguAdventureRewardInfo> source = BoguAdventureReward.Where((BoguAdventureRewardInfo s) => s.AwardID == info.AwardID);
					dictionary.Add(info.AwardID, source.ToList());
				}
			}
			return dictionary;
		}

		public static List<BoguAdventureRewardInfo> FindBoguAdventureReward(int AwardID)
		{
			if (dictionary_1.ContainsKey(AwardID))
			{
				return dictionary_1[AwardID];
			}
			return null;
		}

		public static TreasurePuzzleRewardInfo[] LoadTreasurePuzzleRewardDb()
		{
			using ProduceBussiness produceBussiness = new ProduceBussiness();
			return produceBussiness.GetAllTreasurePuzzleReward();
		}

		public static Dictionary<int, List<TreasurePuzzleRewardInfo>> LoadTreasurePuzzleRewards(TreasurePuzzleRewardInfo[] TreasurePuzzleReward)
		{
			Dictionary<int, List<TreasurePuzzleRewardInfo>> dictionary = new Dictionary<int, List<TreasurePuzzleRewardInfo>>();
			foreach (TreasurePuzzleRewardInfo info in TreasurePuzzleReward)
			{
				if (!dictionary.Keys.Contains(info.PuzzleID))
				{
					IEnumerable<TreasurePuzzleRewardInfo> source = TreasurePuzzleReward.Where((TreasurePuzzleRewardInfo s) => s.PuzzleID == info.PuzzleID);
					dictionary.Add(info.PuzzleID, source.ToList());
				}
			}
			return dictionary;
		}

		public static List<TreasurePuzzleRewardInfo> FindTreasurePuzzleReward(int PuzzleID)
		{
			if (dictionary_0.ContainsKey(PuzzleID))
			{
				return dictionary_0[PuzzleID];
			}
			return null;
		}

		static ActiveSystermAwardMgr()
		{
			imtzRqviW = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			dictionary_0 = new Dictionary<int, List<TreasurePuzzleRewardInfo>>();
			dictionary_1 = new Dictionary<int, List<BoguAdventureRewardInfo>>();
			threadSafeRandom_0 = new ThreadSafeRandom();
		}
	}
}
