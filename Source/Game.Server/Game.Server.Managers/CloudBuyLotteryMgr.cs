using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class CloudBuyLotteryMgr
	{
		private static readonly ILog ilog_0;

		private static Dictionary<int, CloudBuyLotteryInfo> dictionary_0;

		private static ThreadSafeRandom mvQbjmenn;

		protected static Timer m_cloudBuyLotteryScanTimer;

		public static bool ReLoad()
		{
			try
			{
				CloudBuyLotteryInfo[] array = LoadCloudBuyLotteryDb();
				Dictionary<int, CloudBuyLotteryInfo> value = LoadCloudBuyLotterys(array);
				if (array.Length > 0)
				{
					Interlocked.Exchange(ref dictionary_0, value);
				}
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("ReLoad CloudBuyLottery", exception);
				}
				return false;
			}
			finally
			{
				BeginTimer();
			}
			return true;
		}

		public static bool Init()
		{
			return ReLoad();
		}

		public static CloudBuyLotteryInfo[] LoadCloudBuyLotteryDb()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			return playerBussiness.GetAllCloudBuyLottery();
		}

		public static Dictionary<int, CloudBuyLotteryInfo> LoadCloudBuyLotterys(CloudBuyLotteryInfo[] CloudBuyLottery)
		{
			Dictionary<int, CloudBuyLotteryInfo> dictionary = new Dictionary<int, CloudBuyLotteryInfo>();
			foreach (CloudBuyLotteryInfo cloudBuyLotteryInfo in CloudBuyLottery)
			{
				if (!dictionary.Keys.Contains(cloudBuyLotteryInfo.ID))
				{
					dictionary.Add(cloudBuyLotteryInfo.ID, cloudBuyLotteryInfo);
				}
			}
			return dictionary;
		}

		public static CloudBuyLotteryInfo FindCloudBuyLottery(int ID)
		{
			if (dictionary_0.ContainsKey(ID))
			{
				return dictionary_0[ID];
			}
			return null;
		}

		public static CloudBuyLotteryInfo GetCloudBuyLottery()
		{
			foreach (CloudBuyLotteryInfo value in dictionary_0.Values)
			{
				if (value.currentNum > 0)
				{
					return value;
				}
			}
			return null;
		}

		public static void UpdateCloudBuyLottery(int count, ref bool isGetAward)
		{
			CloudBuyLotteryInfo cloudBuyLottery = GetCloudBuyLottery();
			if (cloudBuyLottery == null)
			{
				return;
			}
			cloudBuyLottery.currentNum -= count;
			lock (dictionary_0)
			{
				if (dictionary_0.ContainsKey(cloudBuyLottery.ID))
				{
					dictionary_0[cloudBuyLottery.ID] = cloudBuyLottery;
				}
			}
			if (cloudBuyLottery.currentNum <= 0)
			{
				SendCloudBuyLotteryRandomReward(cloudBuyLottery);
				isGetAward = true;
			}
		}

		public static void SendCloudBuyLotteryRandomReward(CloudBuyLotteryInfo info)
		{
			if (info == null)
			{
				return;
			}
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(info.templateId);
			if (ıtemTemplateInfo != null)
			{
				ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
				ıtemInfo.IsBinds = true;
				ıtemInfo.Count = info.templatedIdCount;
				ıtemInfo.ValidDate = info.validDate;
				string[] array = info.property.Split(',');
				if (array.Length == 5)
				{
					ıtemInfo.StrengthenLevel = int.Parse(array[0]);
					ıtemInfo.AttackCompose = int.Parse(array[1]);
					ıtemInfo.DefendCompose = int.Parse(array[2]);
					ıtemInfo.AgilityCompose = int.Parse(array[3]);
					ıtemInfo.LuckCompose = int.Parse(array[4]);
				}
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				ActiveSystemInfo[] allActiveSystemData = playerBussiness.GetAllActiveSystemData();
				List<ActiveSystemInfo> list = new List<ActiveSystemInfo>();
				ActiveSystemInfo[] array2 = allActiveSystemData;
				foreach (ActiveSystemInfo activeSystemInfo in array2)
				{
					if (activeSystemInfo.luckCount > 0)
					{
						list.Add(activeSystemInfo);
					}
				}
				if (list.Count <= 0)
				{
					return;
				}
				ActiveSystemInfo activeSystemInfo2 = list[mvQbjmenn.Next(list.Count)];
				WorldEventMgr.SendItemToMail(ıtemInfo, activeSystemInfo2.UserID, activeSystemInfo2.NickName, LanguageMgr.GetTranslation("SendCloudBuyLotteryRandomReward.Success"));
				string translation = LanguageMgr.GetTranslation("SendCloudBuyLotteryRandomReward.Notice", activeSystemInfo2.NickName, "@");
				GSPacketIn packet = WorldMgr.SendSysNotice(eMessageType.ChatNormal, translation, ıtemInfo.ItemID, ıtemInfo.TemplateID, "", GameServer.Instance.Configuration.AreaId);
				GameServer.Instance.LoginServer.SendPacket(packet);
				playerBussiness.AddCloudBuyLog(new CloudBuyLogInfo
				{
					UserID = activeSystemInfo2.UserID,
					nickName = activeSystemInfo2.NickName,
					templateId = info.templateId,
					validate = info.validDate,
					count = info.templatedIdCount,
					property = info.property
				});
				CloudBuyLotteryInfo cloudBuyLottery = GetCloudBuyLottery();
				GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				GamePlayer[] array3 = allPlayers;
				foreach (GamePlayer gamePlayer in array3)
				{
					if (gamePlayer != null)
					{
						if (info != null)
						{
							gamePlayer.Actives.SendCloudBuyLotteryUpdateInfos(cloudBuyLottery, isGame: true);
						}
						else
						{
							gamePlayer.Actives.SendCloudBuyLotteryUpdateInfos(info, isGame: false);
						}
						gamePlayer.Actives.ResetLuckCount();
					}
				}
				playerBussiness.ResetLuckCount();
				return;
			}
			if (ilog_0.IsErrorEnabled)
			{
				ilog_0.Error("CloudBuyLottery not found ItemTemplateID: " + info.templateId);
			}
		}

		public static void SaveCloudBuyLottery()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			foreach (CloudBuyLotteryInfo value in dictionary_0.Values)
			{
				playerBussiness.UpdateCloudBuyLottery(value);
			}
		}

		public static void BeginTimer()
		{
			int num = 300000;
			if (m_cloudBuyLotteryScanTimer == null)
			{
				m_cloudBuyLotteryScanTimer = new Timer(CloudBuyLotteryScan, null, num, num);
			}
			else
			{
				m_cloudBuyLotteryScanTimer.Change(num, num);
			}
		}

		protected static void CloudBuyLotteryScan(object sender)
		{
			try
			{
				ilog_0.Info("Begin Save CloudBuyLottery to DB ....");
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				SaveCloudBuyLottery();
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				ilog_0.Info("End CloudBuyLottery Scan....");
			}
			catch (Exception exception)
			{
				ilog_0.Error("CloudBuyLottery Scan ", exception);
			}
		}

		public static void StopAllTimer()
		{
			if (m_cloudBuyLotteryScanTimer != null)
			{
				m_cloudBuyLotteryScanTimer.Dispose();
				m_cloudBuyLotteryScanTimer = null;
			}
		}

		static CloudBuyLotteryMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			dictionary_0 = new Dictionary<int, CloudBuyLotteryInfo>();
			mvQbjmenn = new ThreadSafeRandom();
		}
	}
}
