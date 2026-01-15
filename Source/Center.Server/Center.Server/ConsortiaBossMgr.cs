using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Threading;
namespace Center.Server
{
	public sealed class ConsortiaBossMgr
	{
		private static readonly ILog ilog_0;
		private static System.Threading.ReaderWriterLock readerWriterLock_0;
		private static System.Collections.Generic.Dictionary<int, ConsortiaInfo> dictionary_0;
		public static int TimeCheckingAward;
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static Func<System.Collections.Generic.KeyValuePair<string, RankingPersonInfo>, int> func_0;
		public static bool Init()
		{
			bool result = false;
			try
			{
				ConsortiaBossMgr.dictionary_0.Clear();
				result = true;
			}
			catch (System.Exception ex)
			{
				ConsortiaBossMgr.ilog_0.Error("ConsortiaBossMgr Init", ex);
			}
			return result;
		}
		public static void UpdateTime()
		{
			foreach (ConsortiaInfo current in ConsortiaBossMgr.dictionary_0.Values)
			{
				if (current.endTime < System.DateTime.Now)
				{
					ConsortiaBossMgr.CloseConsortia(current.ConsortiaID, false);
				}
				if (current.LastOpenBoss.Date < System.DateTime.Now.Date)
				{
					ConsortiaBossMgr.ResetConsortia(current.ConsortiaID);
				}
			}
		}
		public static bool ExtendAvailable(int consortiaId, int riches)
		{
			ConsortiaBossMgr.readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId))
				{
					if (ConsortiaBossMgr.dictionary_0[consortiaId].extendAvailableNum <= 0)
					{
						return false;
					}
					ConsortiaBossMgr.dictionary_0[consortiaId].extendAvailableNum--;
					ConsortiaBossMgr.dictionary_0[consortiaId].endTime = ConsortiaBossMgr.dictionary_0[consortiaId].endTime.AddMinutes(10.0);
					ConsortiaBossMgr.dictionary_0[consortiaId].Riches = riches;
				}
			}
			finally
			{
				ConsortiaBossMgr.readerWriterLock_0.ReleaseWriterLock();
			}
			return true;
		}
		public static void UpdateRank(int consortiaId, int damage, int richer, int honor, string nickName, int UserID)
		{
			ConsortiaBossMgr.readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId))
				{
					if (ConsortiaBossMgr.dictionary_0[consortiaId].RankList == null)
					{
						ConsortiaBossMgr.dictionary_0[consortiaId].RankList = new System.Collections.Generic.Dictionary<string, RankingPersonInfo>();
					}
					if (ConsortiaBossMgr.dictionary_0[consortiaId].RankList.ContainsKey(nickName))
					{
						ConsortiaBossMgr.dictionary_0[consortiaId].RankList[nickName].TotalDamage += damage;
						ConsortiaBossMgr.dictionary_0[consortiaId].RankList[nickName].Damage += richer;
						ConsortiaBossMgr.dictionary_0[consortiaId].RankList[nickName].Honor += honor;
					}
					else
					{
						RankingPersonInfo rankingPersonInfo = new RankingPersonInfo();
						rankingPersonInfo.ID = ConsortiaBossMgr.dictionary_0[consortiaId].RankList.Count + 1;
						rankingPersonInfo.Name = nickName;
						rankingPersonInfo.UserID = UserID;
						rankingPersonInfo.TotalDamage = damage;
						rankingPersonInfo.Damage = richer;
						rankingPersonInfo.Honor = honor;
						ConsortiaBossMgr.dictionary_0[consortiaId].RankList.Add(nickName, rankingPersonInfo);
					}
				}
			}
			finally
			{
				ConsortiaBossMgr.readerWriterLock_0.ReleaseWriterLock();
			}
		}
		public static void UpdateBlood(int consortiaId, int damage)
		{
			ConsortiaBossMgr.readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId))
				{
					ConsortiaBossMgr.dictionary_0[consortiaId].TotalAllMemberDame += (long)damage;
					if (ConsortiaBossMgr.dictionary_0[consortiaId].TotalAllMemberDame >= ConsortiaBossMgr.dictionary_0[consortiaId].MaxBlood)
					{
						ConsortiaBossMgr.CloseConsortia(consortiaId, true);
					}
				}
			}
			finally
			{
				ConsortiaBossMgr.readerWriterLock_0.ReleaseWriterLock();
			}
		}
		public static void UpdateSendToClient(int consortiaId)
		{
			ConsortiaBossMgr.readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId))
				{
					ConsortiaBossMgr.dictionary_0[consortiaId].SendToClient = false;
				}
			}
			finally
			{
				ConsortiaBossMgr.readerWriterLock_0.ReleaseWriterLock();
			}
		}
		public static System.Collections.Generic.List<RankingPersonInfo> SelectRank(int consortiaId)
		{
			System.Collections.Generic.List<RankingPersonInfo> list = new System.Collections.Generic.List<RankingPersonInfo>();
			ConsortiaBossMgr.readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId) && ConsortiaBossMgr.dictionary_0[consortiaId].RankList != null)
				{
					System.Collections.Generic.Dictionary<string, RankingPersonInfo> rankList = ConsortiaBossMgr.dictionary_0[consortiaId].RankList;
					System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, RankingPersonInfo>> arg_5F_0 = rankList;
					if (ConsortiaBossMgr.func_0 == null)
					{
						ConsortiaBossMgr.func_0 = new Func<System.Collections.Generic.KeyValuePair<string, RankingPersonInfo>, int>(ConsortiaBossMgr.smethod_0);
					}
					IOrderedEnumerable<System.Collections.Generic.KeyValuePair<string, RankingPersonInfo>> orderedEnumerable = arg_5F_0.OrderByDescending(ConsortiaBossMgr.func_0);
					foreach (System.Collections.Generic.KeyValuePair<string, RankingPersonInfo> current in orderedEnumerable)
					{
						list.Add(current.Value);
					}
				}
			}
			finally
			{
				ConsortiaBossMgr.readerWriterLock_0.ReleaseWriterLock();
			}
			return list;
		}
		public static void CloseConsortia(int consortiaId, bool IsBossDie)
		{
			if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId) && ConsortiaBossMgr.dictionary_0[consortiaId].bossState == 1)
			{
				ConsortiaBossMgr.dictionary_0[consortiaId].bossState = 2;
				ConsortiaBossMgr.dictionary_0[consortiaId].IsSendAward = true;
				ConsortiaBossMgr.dictionary_0[consortiaId].IsBossDie = IsBossDie;
				ConsortiaBossMgr.dictionary_0[consortiaId].SendToClient = true;
			}
		}
		public static void ResetConsortia(int consortiaId)
		{
			if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId) && ConsortiaBossMgr.dictionary_0[consortiaId].bossState == 2)
			{
				ConsortiaBossMgr.dictionary_0[consortiaId].bossState = 0;
				ConsortiaBossMgr.dictionary_0[consortiaId].IsBossDie = false;
			}
		}
		public static bool UpdateConsortia(int consortiaId, int bossState, System.DateTime endTime, System.DateTime LastOpenBoss, long MaxBlood)
		{
			ConsortiaBossMgr.readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId))
				{
					ConsortiaBossMgr.dictionary_0[consortiaId].bossState = bossState;
					ConsortiaBossMgr.dictionary_0[consortiaId].endTime = endTime;
					ConsortiaBossMgr.dictionary_0[consortiaId].LastOpenBoss = LastOpenBoss;
					ConsortiaBossMgr.dictionary_0[consortiaId].MaxBlood = MaxBlood;
					ConsortiaBossMgr.dictionary_0[consortiaId].TotalAllMemberDame = 0L;
				}
			}
			finally
			{
				ConsortiaBossMgr.readerWriterLock_0.ReleaseWriterLock();
			}
			return true;
		}
		public static bool AddConsortia(int consortiaId, ConsortiaInfo consortia)
		{
			ConsortiaBossMgr.readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId))
				{
					return false;
				}
				ConsortiaBossMgr.dictionary_0.Add(consortiaId, consortia);
			}
			finally
			{
				ConsortiaBossMgr.readerWriterLock_0.ReleaseWriterLock();
			}
			return true;
		}
		public static ConsortiaInfo GetConsortiaById(int consortiaId)
		{
			ConsortiaInfo result = null;
			ConsortiaBossMgr.readerWriterLock_0.AcquireReaderLock(-1);
			try
			{
				if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaId))
				{
					result = ConsortiaBossMgr.dictionary_0[consortiaId];
				}
			}
			finally
			{
				ConsortiaBossMgr.readerWriterLock_0.ReleaseReaderLock();
			}
			return result;
		}
		public static System.Collections.Generic.List<int> GetAllConsortiaGetAward()
		{
			System.Collections.Generic.List<int> list = new System.Collections.Generic.List<int>();
			ConsortiaBossMgr.readerWriterLock_0.AcquireReaderLock(-1);
			try
			{
				foreach (ConsortiaInfo current in ConsortiaBossMgr.dictionary_0.Values)
				{
					int consortiaID = current.ConsortiaID;
					if (current.IsSendAward)
					{
						list.Add(consortiaID);
						if (ConsortiaBossMgr.dictionary_0.ContainsKey(consortiaID))
						{
							ConsortiaBossMgr.dictionary_0[consortiaID].IsSendAward = false;
						}
					}
				}
			}
			finally
			{
				ConsortiaBossMgr.readerWriterLock_0.ReleaseReaderLock();
			}
			return list;
		}
		public ConsortiaBossMgr()
		{
			
			
		}
		[System.Runtime.CompilerServices.CompilerGenerated]
		private static int smethod_0(System.Collections.Generic.KeyValuePair<string, RankingPersonInfo> pair)
		{
			return pair.Value.TotalDamage;
		}
		static ConsortiaBossMgr()
		{
			
			ConsortiaBossMgr.ilog_0 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
			ConsortiaBossMgr.readerWriterLock_0 = new System.Threading.ReaderWriterLock();
			ConsortiaBossMgr.dictionary_0 = new System.Collections.Generic.Dictionary<int, ConsortiaInfo>();
			ConsortiaBossMgr.TimeCheckingAward = 0;
		}
	}
}
