using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Server.Battle;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.RingStation.Battle;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.RingStation
{
	public class RingStationMgr
	{
		private static ThreadSafeRandom threadSafeRandom_0;

		private static readonly ILog ilog_0;

		protected static object m_lock;

		private static Dictionary<int, RingStationGamePlayer> dictionary_0;

		private static RingStationBattleServer ringStationBattleServer_0;

		private static readonly string string_0;

		private static VirtualPlayerInfo virtualPlayerInfo_0;

		private static string[] string_1;

		private static List<VirtualPlayerInfo> list_0;

		private static Dictionary<int, UserRingStationInfo> dictionary_1;

		private static List<UserRingStationInfo> list_1;

		private static Dictionary<int, List<RingstationBattleFieldInfo>> dictionary_2;

		private static RingstationConfigInfo ringstationConfigInfo_0;

		private static int int_0;

		protected static Timer m_statusScanTimer;

		[CompilerGenerated]
		private static Func<RingstationBattleFieldInfo, DateTime> func_0;

		[CompilerGenerated]
		private static Func<UserRingStationInfo, bool> func_1;

		[CompilerGenerated]
		private static Func<UserRingStationInfo, int> func_2;

		[CompilerGenerated]
		private static Func<UserRingStationInfo, int> func_3;

		[CompilerGenerated]
		private static Func<UserRingStationInfo, bool> func_4;

		[CompilerGenerated]
		private static Func<UserRingStationInfo, int> func_5;

		public static RingstationConfigInfo ConfigInfo => ringstationConfigInfo_0;

		public static VirtualPlayerInfo NormalPlayer
		{
			get
			{
				return virtualPlayerInfo_0;
			}
			set
			{
				virtualPlayerInfo_0 = value;
			}
		}

		public static RingStationBattleServer RingStationBattle => ringStationBattleServer_0;

		public static bool Init()
		{
			bool result = false;
			try
			{
				BattleServer server = BattleMgr.GetServer(1);
				if (server == null)
				{
					return false;
				}
				ringStationBattleServer_0 = new RingStationBattleServer(RingStationConfiguration.ServerID, server.Ip, server.Port, "1,7road");
				if (ringStationBattleServer_0 != null)
				{
					string_1 = GameProperties.VirtualName.Split(',');
					lock (m_lock)
					{
						dictionary_0.Clear();
					}
					ringStationBattleServer_0.Start();
					if (!SetupVirtualPlayer())
					{
						return false;
					}
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						ringstationConfigInfo_0 = playerBussiness.GetAllRingstationConfig();
						if (ringstationConfigInfo_0 == null)
						{
							ringstationConfigInfo_0 = new RingstationConfigInfo();
							ringstationConfigInfo_0.buyCount = 10;
							ringstationConfigInfo_0.buyPrice = 8000;
							ringstationConfigInfo_0.cdPrice = 10000;
							ringstationConfigInfo_0.AwardTime = DateTime.Now.AddDays(3.0);
							ringstationConfigInfo_0.AwardNum = 450;
							ringstationConfigInfo_0.AwardFightWin = "1-50,25|51-100,20|101-1000000,15";
							ringstationConfigInfo_0.AwardFightLost = "1-50,15|51-100,10|101-1000000,5";
							ringstationConfigInfo_0.ChampionText = "";
							ringstationConfigInfo_0.ChallengeNum = 10;
							ringstationConfigInfo_0.IsFirstUpdateRank = true;
							playerBussiness.AddRingstationConfig(ringstationConfigInfo_0);
						}
					}
					BeginTimer();
					ReLoadUserRingStation();
					ReLoadBattleField();
					result = true;
				}
			}
			catch (Exception exception)
			{
				ilog_0.Error("RingStationMgr Init", exception);
			}
			return result;
		}

		public static bool ReLoadBattleField()
		{
			bool result;
			try
			{
				RingstationBattleFieldInfo[] array = LoadRingstationBattleFieldDb();
				Dictionary<int, List<RingstationBattleFieldInfo>> value = LoadRingstationBattleFields(array);
				if (array.Length > 0)
				{
					Interlocked.Exchange(ref dictionary_2, value);
				}
				return true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("ReLoad RingstationBattleField", exception);
				}
				result = false;
			}
			return result;
		}

		public static RingstationBattleFieldInfo[] LoadRingstationBattleFieldDb()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			return playerBussiness.GetAllRingstationBattleField();
		}

		public static Dictionary<int, List<RingstationBattleFieldInfo>> LoadRingstationBattleFields(RingstationBattleFieldInfo[] RingstationBattleField)
		{
			Dictionary<int, List<RingstationBattleFieldInfo>> dictionary = new Dictionary<int, List<RingstationBattleFieldInfo>>();
			foreach (RingstationBattleFieldInfo info in RingstationBattleField)
			{
				if (!dictionary.Keys.Contains(info.UserID))
				{
					IEnumerable<RingstationBattleFieldInfo> source = RingstationBattleField.Where((RingstationBattleFieldInfo s) => s.UserID == info.UserID);
					dictionary.Add(info.UserID, source.ToList());
				}
			}
			return dictionary;
		}

		public static UserRingStationInfo[] GetRingStationRanks()
		{
			List<UserRingStationInfo> list = new List<UserRingStationInfo>();
			foreach (UserRingStationInfo item in list_1)
			{
				list.Add(item);
				if (list.Count >= 50)
				{
					break;
				}
			}
			return list.ToArray();
		}

		public static bool UpdateRingBattleFields(RingstationBattleFieldInfo dareFlag, RingstationBattleFieldInfo successFlag)
		{
			int num = -1;
			int num2 = -1;
			int rank = 0;
			int rank2 = 0;
			bool flag = false;
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				if (dareFlag != null)
				{
					num = dareFlag.UserID;
				}
				if (successFlag != null)
				{
					num2 = successFlag.UserID;
				}
				UserRingStationInfo singleRingStationInfos = GetSingleRingStationInfos(num);
				if (singleRingStationInfos != null)
				{
					if (singleRingStationInfos.Rank == 0)
					{
						singleRingStationInfos.Rank = list_1.Count + 1;
					}
					if (singleRingStationInfos.ChallengeNum > 0)
					{
						singleRingStationInfos.ChallengeNum--;
						singleRingStationInfos.ChallengeTime = DateTime.Now;
						singleRingStationInfos.ChallengeTime = DateTime.Now.AddMinutes(10.0);
					}
					if (dareFlag != null && dareFlag.SuccessFlag)
					{
						singleRingStationInfos.Total++;
					}
					rank = singleRingStationInfos.Rank;
				}
				UserRingStationInfo singleRingStationInfos2 = GetSingleRingStationInfos(num2);
				if (singleRingStationInfos2 != null)
				{
					rank2 = singleRingStationInfos2.Rank;
				}
				object obj = default(object);
				if (dareFlag != null)
				{
					if (singleRingStationInfos != null)
					{
						if (dareFlag.SuccessFlag && singleRingStationInfos2 != null && singleRingStationInfos.Rank > singleRingStationInfos2.Rank)
						{
							singleRingStationInfos.Rank = rank2;
							singleRingStationInfos2.Rank = rank;
							flag = true;
						}
						if (dareFlag.Level == singleRingStationInfos.Rank)
						{
							dareFlag.Level = 0;
						}
						else
						{
							dareFlag.Level = singleRingStationInfos.Rank;
						}
						UpdateRingStationInfo(singleRingStationInfos);
					}
					bool lockTaken = false;
					try
					{
						Monitor.Enter(obj = m_lock, ref lockTaken);
						if (dictionary_2.ContainsKey(num))
						{
							playerBussiness.AddRingstationBattleField(dareFlag);
							dictionary_2[num].Add(dareFlag);
						}
						else
						{
							playerBussiness.AddRingstationBattleField(dareFlag);
							List<RingstationBattleFieldInfo> list = new List<RingstationBattleFieldInfo>();
							list.Add(dareFlag);
							dictionary_2.Add(num, list);
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
				if (successFlag != null)
				{
					if (singleRingStationInfos2 != null)
					{
						if (successFlag.Level == singleRingStationInfos2.Rank)
						{
							successFlag.Level = 0;
						}
						else
						{
							successFlag.Level = singleRingStationInfos2.Rank;
						}
						if (flag)
						{
							UpdateRingStationInfo(singleRingStationInfos2);
						}
						singleRingStationInfos2.OnFight = false;
						UpdateRingStationFight(singleRingStationInfos2);
					}
					bool lockTaken2 = false;
					try
					{
						Monitor.Enter(obj = m_lock, ref lockTaken2);
						if (dictionary_2.ContainsKey(num2))
						{
							playerBussiness.AddRingstationBattleField(successFlag);
							dictionary_2[num2].Add(successFlag);
						}
						else
						{
							playerBussiness.AddRingstationBattleField(successFlag);
							List<RingstationBattleFieldInfo> list = new List<RingstationBattleFieldInfo>();
							list.Add(successFlag);
							dictionary_2.Add(num2, list);
						}
					}
					finally
					{
						if (lockTaken2)
						{
							Monitor.Exit(obj);
						}
					}
				}
			}
			return true;
		}

		public static RingstationBattleFieldInfo[] GetRingBattleFields(int playerId)
		{
			List<RingstationBattleFieldInfo> list = new List<RingstationBattleFieldInfo>();
			lock (m_lock)
			{
				if (dictionary_2.ContainsKey(playerId))
				{
					List<RingstationBattleFieldInfo> list2 = dictionary_2[playerId];
					foreach (RingstationBattleFieldInfo item in list2)
					{
						list.Add(item);
					}
				}
			}
			IEnumerable<RingstationBattleFieldInfo> source = list;
			return source.OrderByDescending((RingstationBattleFieldInfo ringstationBattleFieldInfo_0) => ringstationBattleFieldInfo_0.BattleTime).Take(10).ToArray();
		}

		public static bool ReLoadUserRingStation()
		{
			bool result;
			try
			{
				UserRingStationInfo[] array = LoadUserRingStationDb();
				Dictionary<int, UserRingStationInfo> value = LoadUserRingStations(array);
				if (array.Length > 0)
				{
					Interlocked.Exchange(ref dictionary_1, value);
					IEnumerable<UserRingStationInfo> source = array;
					IEnumerable<UserRingStationInfo> source2 = source.Where((UserRingStationInfo userRingStationInfo_0) => userRingStationInfo_0.Rank != 0);
					list_1 = source2.OrderBy((UserRingStationInfo userRingStationInfo_0) => userRingStationInfo_0.Rank).ToList();
				}
				return true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("ReLoad All UserRingStation", exception);
				}
				result = false;
			}
			return result;
		}

		public static UserRingStationInfo[] LoadUserRingStationDb()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			return playerBussiness.GetAllUserRingStation();
		}

		public static Dictionary<int, UserRingStationInfo> LoadUserRingStations(UserRingStationInfo[] UserRingStation)
		{
			Dictionary<int, UserRingStationInfo> dictionary = new Dictionary<int, UserRingStationInfo>();
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				foreach (UserRingStationInfo userRingStationInfo in UserRingStation)
				{
					if (!dictionary.Keys.Contains(userRingStationInfo.UserID))
					{
						userRingStationInfo.Info = playerBussiness.GetUserSingleByUserID(userRingStationInfo.UserID);
						if (userRingStationInfo.Info != null)
						{
							userRingStationInfo.WeaponID = GetWeaponID(userRingStationInfo.Info.Style);
							dictionary.Add(userRingStationInfo.UserID, userRingStationInfo);
						}
					}
				}
			}
			return dictionary;
		}

		public static void LoadRingStationInfo(PlayerInfo player, int dame, int guard)
		{
			if (player == null)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			if (dictionary_1.ContainsKey(player.ID))
			{
				bool flag = false;
				UserRingStationInfo userRingStationInfo = dictionary_1[player.ID];
				if (dame != userRingStationInfo.BaseDamage && userRingStationInfo.BaseGuard != guard)
				{
					userRingStationInfo.BaseDamage = dame;
					userRingStationInfo.BaseGuard = guard;
					userRingStationInfo.BaseEnergy = (int)(1.0 - (double)player.Agility * 0.001);
					flag = true;
				}
				int weaponID = GetWeaponID(player.Style);
				if (userRingStationInfo.WeaponID != weaponID)
				{
					userRingStationInfo.WeaponID = weaponID;
					flag = true;
				}
				if (flag)
				{
					playerBussiness.UpdateUserRingStation(userRingStationInfo);
				}
			}
			else
			{
				UserRingStationInfo userRingStationInfo2 = new UserRingStationInfo();
				userRingStationInfo2.UserID = player.ID;
				userRingStationInfo2.WeaponID = GetWeaponID(player.Style);
				userRingStationInfo2.BaseDamage = dame;
				userRingStationInfo2.BaseGuard = guard;
				userRingStationInfo2.BaseEnergy = (int)(1.0 - (double)player.Agility * 0.001);
				userRingStationInfo2.signMsg = LanguageMgr.GetTranslation("RingStation.signMsg");
				userRingStationInfo2.ChallengeNum = ringstationConfigInfo_0.ChallengeNum;
				userRingStationInfo2.buyCount = ringstationConfigInfo_0.buyCount;
				userRingStationInfo2.ChallengeTime = DateTime.Now;
				userRingStationInfo2.LastDate = DateTime.Now;
				userRingStationInfo2.Info = player;
				playerBussiness.AddUserRingStation(userRingStationInfo2);
				dictionary_1.Add(player.ID, userRingStationInfo2);
			}
		}

		public static int GetWeaponID(string style)
		{
			if (!string.IsNullOrEmpty(style))
			{
				string[] array = style.Split(',');
				string text = array[6];
				if (text.IndexOf("|") != -1)
				{
					return int.Parse(text.Split('|')[0]);
				}
			}
			return 7008;
		}

		public static UserRingStationInfo GetRingStationChallenge(int playerId, int rank, ref bool isAutoBot)
		{
			if (dictionary_1.ContainsKey(playerId) && rank != 0)
			{
				return dictionary_1[playerId];
			}
			isAutoBot = true;
			return BaseRingStationChallenges(playerId);
		}

		public static UserRingStationInfo GetSingleRingStationInfos(int playerId)
		{
			if (dictionary_1.ContainsKey(playerId))
			{
				return dictionary_1[playerId];
			}
			return null;
		}

		public static bool UpdateRingStationInfo(UserRingStationInfo ring)
		{
			if (ring == null)
			{
				return false;
			}
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				lock (m_lock)
				{
					if (dictionary_1.ContainsKey(ring.UserID))
					{
						dictionary_1[ring.UserID] = ring;
						playerBussiness.UpdateUserRingStation(ring);
						return true;
					}
				}
			}
			return false;
		}

		public static bool UpdateRingStationFight(UserRingStationInfo ring)
		{
			if (ring == null)
			{
				return false;
			}
			lock (m_lock)
			{
				if (dictionary_1.ContainsKey(ring.UserID))
				{
					dictionary_1[ring.UserID] = ring;
					return true;
				}
			}
			return false;
		}

		public static List<UserRingStationInfo> FindRingStationInfoByRank(int userId, int min, int max)
		{
			List<UserRingStationInfo> list = new List<UserRingStationInfo>();
			foreach (UserRingStationInfo value in dictionary_1.Values)
			{
				if (value.UserID != userId && value.Rank >= min && value.Rank <= max)
				{
					list.Add(value);
				}
			}
			return list;
		}

		public static UserRingStationInfo[] GetRingStationInfos(int userId, int rank)
		{
			NormalPlayer = GetVirtualPlayerInfo();
			Dictionary<int, UserRingStationInfo> dictionary = new Dictionary<int, UserRingStationInfo>();
			if (rank > 0)
			{
				int num = rank;
				int num2 = list_1.Count;
				int num3 = int_0 / 2;
				if (num != num2 && num2 - num >= num3)
				{
					if (num2 - num > int_0)
					{
						num = rank - num3;
						num2 = rank + num3;
					}
				}
				else
				{
					num = num2 - int_0;
				}
				if (num < num3)
				{
					num2 = num + int_0;
					num = 0;
				}
				if (num < 0)
				{
					num = 0;
				}
				List<UserRingStationInfo> list = FindRingStationInfoByRank(userId, num, num2);
				if (list.Count > 4)
				{
					int num4 = 0;
					while (dictionary.Count < 4)
					{
						UserRingStationInfo userRingStationInfo = list[threadSafeRandom_0.Next(list.Count)];
						if (userRingStationInfo != null)
						{
							if (!dictionary.ContainsKey(userRingStationInfo.UserID))
							{
								dictionary.Add(userRingStationInfo.UserID, userRingStationInfo);
							}
							list.Remove(userRingStationInfo);
						}
						num4++;
					}
				}
			}
			if (dictionary.Count == 0)
			{
				UserRingStationInfo userRingStationInfo2 = BaseRingStationChallenges(0);
				dictionary.Add(userRingStationInfo2.Info.ID, userRingStationInfo2);
			}
			return dictionary.Values.ToArray();
		}

		public static bool AddPlayer(int playerId, RingStationGamePlayer player)
		{
			lock (m_lock)
			{
				if (dictionary_0.ContainsKey(playerId))
				{
					return false;
				}
				dictionary_0.Add(playerId, player);
			}
			return true;
		}

		public static bool RemovePlayer(int playerId)
		{
			lock (m_lock)
			{
				if (dictionary_0.ContainsKey(playerId))
				{
					return dictionary_0.Remove(playerId);
				}
			}
			return false;
		}

		public static RingStationGamePlayer GetPlayerById(int playerId)
		{
			RingStationGamePlayer result = null;
			lock (m_lock)
			{
				if (dictionary_0.ContainsKey(playerId))
				{
					result = dictionary_0[playerId];
				}
			}
			return result;
		}

		public static void BeginTimer()
		{
			int num = 60000;
			if (m_statusScanTimer == null)
			{
				m_statusScanTimer = new Timer(StatusScan, null, num, num);
			}
			else
			{
				m_statusScanTimer.Change(num, num);
			}
		}

		protected static void StatusScan(object sender)
		{
			try
			{
				ilog_0.Info("Begin Scan RingStation Info....");
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				bool flag = false;
				if (ReLoadUserRingStation())
				{
					List<UserRingStationInfo> list = new List<UserRingStationInfo>();
					foreach (UserRingStationInfo value in dictionary_1.Values)
					{
						list.Add(value);
					}
					object obj = default(object);
					if (ringstationConfigInfo_0.IsFirstUpdateRank && list.Count > int_0)
					{
						IEnumerable<UserRingStationInfo> source = list;
						List<UserRingStationInfo> list2 = source.OrderByDescending((UserRingStationInfo userRingStationInfo_0) => userRingStationInfo_0.Total).ToList();
						bool lockTaken = false;
						try
						{
							Monitor.Enter(obj = m_lock, ref lockTaken);
							for (int num = 0; num < list2.Count; num++)
							{
								UserRingStationInfo userRingStationInfo = list2[num];
								userRingStationInfo.Rank = num + 1;
								UpdateRingStationInfo(userRingStationInfo);
							}
						}
						finally
						{
							if (lockTaken)
							{
								Monitor.Exit(obj);
							}
						}
						ringstationConfigInfo_0.IsFirstUpdateRank = false;
						flag = true;
					}
					IEnumerable<UserRingStationInfo> source2 = list;
					IEnumerable<UserRingStationInfo> source3 = source2.Where((UserRingStationInfo userRingStationInfo_0) => userRingStationInfo_0.Rank != 0);
					list_1 = source3.OrderBy((UserRingStationInfo userRingStationInfo_0) => userRingStationInfo_0.Rank).ToList();
					if (list_1.Count > 0)
					{
						UserRingStationInfo userRingStationInfo2 = list_1[0];
						if (userRingStationInfo2.Info != null)
						{
							ringstationConfigInfo_0.ChampionText = userRingStationInfo2.Info.NickName;
							flag = true;
						}
					}
					if (ringstationConfigInfo_0.IsEndTime())
					{
						bool lockTaken2 = false;
						try
						{
							Monitor.Enter(obj = m_lock, ref lockTaken2);
							ringstationConfigInfo_0.AwardTime = DateTime.Now;
							ringstationConfigInfo_0.AwardTime = DateTime.Now.AddDays(3.0);
							flag = true;
						}
						finally
						{
							if (lockTaken2)
							{
								Monitor.Exit(obj);
							}
						}
						if (list.Count > 0)
						{
							ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(-1000);
							string translation = LanguageMgr.GetTranslation("RingStation.RankAward");
							if (ıtemTemplateInfo != null)
							{
								foreach (UserRingStationInfo item in list)
								{
									int num2 = ringstationConfigInfo_0.AwardNumByRank(item.Rank);
									List<ItemInfo> list3 = new List<ItemInfo>();
									if (num2 > 0)
									{
										ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 102);
										ıtemInfo.Count = num2;
										ıtemInfo.ValidDate = 0;
										ıtemInfo.IsBinds = true;
										list3.Add(ıtemInfo);
										if (WorldEventMgr.SendItemsToMail(list3, item.UserID, item.Info.NickName, translation))
										{
											WorldMgr.GetPlayerById(item.UserID)?.Out.SendMailResponse(item.UserID, eMailRespose.Receiver);
										}
									}
								}
							}
						}
					}
					if (flag)
					{
						using PlayerBussiness playerBussiness = new PlayerBussiness();
						playerBussiness.UpdateRingstationConfig(ringstationConfigInfo_0);
					}
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				ilog_0.Info("End Scan RingStation Info....");
			}
			catch (Exception exception)
			{
				ilog_0.Error("StatusScan ", exception);
			}
		}

		public static bool SetupVirtualPlayer()
		{
			int[] array = new int[25]
			{
				7015, 7016, 7017, 7018, 7019, 7020, 7021, 7022, 7023, 7026,
				7027, 7028, 7031, 7032, 7031, 7046, 7047, 7048, 7049, 7050,
				7051, 7053, 7058, 7059, 7060
			};
			int[] array2 = new int[26]
			{
				1515, 1517, 1522, 1523, 1524, 1525, 1528, 1539, 1542, 1544,
				1545, 1550, 1551, 1552, 1555, 1576, 1577, 1578, 1582, 1588,
				1592, 1593, 1594, 1595, 1596, 1598
			};
			int[] array3 = new int[26]
			{
				2324, 2332, 2334, 2335, 2336, 2337, 2338, 2345, 2348, 2354,
				2357, 2400, 2401, 2402, 2403, 2404, 2405, 2407, 2408, 2409,
				2413, 2416, 2417, 2420, 2422, 2423
			};
			int[] array4 = new int[26]
			{
				3309, 3310, 3311, 3312, 3314, 3315, 3316, 3317, 3318, 3319,
				3320, 3321, 3322, 3323, 3324, 3325, 3326, 3330, 3331, 3333,
				3334, 3335, 3336, 3337, 3338, 3339
			};
			int[] array5 = new int[26]
			{
				4321, 4323, 4327, 4329, 4332, 4338, 4339, 4347, 4351, 4353,
				4355, 4401, 4402, 4403, 4404, 4405, 4406, 4407, 4408, 4409,
				4410, 4412, 4413, 4414, 4415, 4416
			};
			int[] array6 = new int[26]
			{
				5569, 5570, 5572, 5575, 5576, 5577, 5578, 5579, 5580, 5582,
				5583, 5584, 5585, 5586, 5588, 5589, 5591, 5592, 5594, 5596,
				5600, 5601, 5602, 5603, 5604, 5605
			};
			int[] array7 = new int[26]
			{
				6255, 6256, 6257, 6258, 6259, 6260, 6261, 6262, 6263, 6264,
				6265, 6266, 6267, 6268, 6269, 6270, 6271, 6272, 6273, 6274,
				6275, 6276, 6277, 6278, 6279, 6280
			};
			int[] array8 = new int[26]
			{
				15009, 15018, 15019, 15020, 15021, 15022, 15023, 15024, 15025, 15026,
				15027, 15028, 15029, 15049, 15031, 15032, 15033, 15034, 15035, 15036,
				15037, 15038, 15039, 15040, 15041, 15042
			};
			int num = array.Length;
			for (int i = 0; i < num; i++)
			{
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(array[i]);
				ItemTemplateInfo ıtemTemplateInfo2 = ItemMgr.FindItemTemplate(array2[i]);
				ItemTemplateInfo ıtemTemplateInfo3 = ItemMgr.FindItemTemplate(array3[i]);
				ItemTemplateInfo ıtemTemplateInfo4 = ItemMgr.FindItemTemplate(array4[i]);
				ItemTemplateInfo ıtemTemplateInfo5 = ItemMgr.FindItemTemplate(array5[i]);
				ItemTemplateInfo ıtemTemplateInfo6 = ItemMgr.FindItemTemplate(array6[i]);
				ItemTemplateInfo ıtemTemplateInfo7 = ItemMgr.FindItemTemplate(array7[i]);
				ItemTemplateInfo ıtemTemplateInfo8 = ItemMgr.FindItemTemplate(array8[i]);
				if (ıtemTemplateInfo != null && ıtemTemplateInfo2 != null && ıtemTemplateInfo3 != null && ıtemTemplateInfo4 != null && ıtemTemplateInfo5 != null && ıtemTemplateInfo6 != null && ıtemTemplateInfo7 != null && ıtemTemplateInfo8 != null)
				{
					string text = $"{array[i]}|{ıtemTemplateInfo.Pic}";
					string text2 = $"{array2[i]}|{ıtemTemplateInfo2.Pic}";
					string text3 = $"{array3[i]}|{ıtemTemplateInfo3.Pic}";
					string text4 = $"{array4[i]}|{ıtemTemplateInfo4.Pic}";
					string text5 = $"{array5[i]}|{ıtemTemplateInfo5.Pic}";
					string text6 = $"{array6[i]}|{ıtemTemplateInfo6.Pic}";
					string text7 = $"{array7[i]}|{ıtemTemplateInfo7.Pic}";
					string text8 = $"{array8[i]}|{ıtemTemplateInfo8.Pic}";
					string style = $"{text2},{text3},{text4},{text5},{text6},{text7},{text},,{text8},,,,,,,,,";
					VirtualPlayerInfo virtualPlayerInfo = new VirtualPlayerInfo();
					virtualPlayerInfo.Style = style;
					virtualPlayerInfo.Weapon = array[i];
					list_0.Add(virtualPlayerInfo);
				}
			}
			return list_0.Count > Math.Abs(num / 2);
		}

		public static VirtualPlayerInfo GetVirtualPlayerInfo()
		{
			int index = threadSafeRandom_0.Next(list_0.Count);
			return list_0[index];
		}

		public static int CreateRingStationChallenge(UserRingStationInfo player, int roomtype, int gametype)
		{
			int ıD = player.Info.ID;
			BaseRoomRingStation baseRoomRingStation = new BaseRoomRingStation(RingStationConfiguration.NextRoomId());
			baseRoomRingStation.RoomType = roomtype;
			baseRoomRingStation.GameType = gametype;
			baseRoomRingStation.PickUpNpcId = ıD;
			baseRoomRingStation.IsAutoBot = true;
			baseRoomRingStation.IsFreedom = false;
			RingStationGamePlayer ringStationGamePlayer = new RingStationGamePlayer();
			ringStationGamePlayer.NickName = player.Info.NickName;
			ringStationGamePlayer.GP = player.Info.GP;
			ringStationGamePlayer.Grade = player.Info.Grade;
			ringStationGamePlayer.Attack = player.Info.Attack;
			ringStationGamePlayer.Defence = player.Info.Defence;
			ringStationGamePlayer.Luck = player.Info.Luck;
			ringStationGamePlayer.Agility = player.Info.Agility;
			ringStationGamePlayer.hp = player.Info.hp;
			ringStationGamePlayer.FightPower = player.Info.FightPower;
			ringStationGamePlayer.BaseAttack = player.BaseDamage;
			ringStationGamePlayer.BaseDefence = player.BaseGuard;
			ringStationGamePlayer.BaseAgility = player.BaseEnergy;
			ringStationGamePlayer.BaseBlood = player.Info.hp;
			ringStationGamePlayer.Style = player.Info.Style;
			ringStationGamePlayer.Colors = player.Info.Colors;
			ringStationGamePlayer.Hide = player.Info.Hide;
			ringStationGamePlayer.TemplateID = player.WeaponID;
			ringStationGamePlayer.StrengthLevel = 1;
			ringStationGamePlayer.WeaklessGuildProgressStr = string_0;
			ringStationGamePlayer.ID = ıD;
			if (ringStationBattleServer_0 != null)
			{
				AddPlayer(ıD, ringStationGamePlayer);
				baseRoomRingStation.AddPlayer(ringStationGamePlayer);
				ringStationBattleServer_0.AddRoom(baseRoomRingStation);
			}
			return ıD;
		}

		public static void CreateAutoBot(GamePlayer player, int roomtype, int gametype, int npcId)
		{
			BaseRoomRingStation baseRoomRingStation = new BaseRoomRingStation(RingStationConfiguration.NextRoomId());
			baseRoomRingStation.RoomType = roomtype;
			baseRoomRingStation.GameType = gametype;
			baseRoomRingStation.PickUpNpcId = npcId;
			baseRoomRingStation.IsAutoBot = true;
			baseRoomRingStation.IsFreedom = true;
			RingStationGamePlayer ringStationGamePlayer = new RingStationGamePlayer();
			ringStationGamePlayer.NickName = string_1[threadSafeRandom_0.Next(string_1.Length)] + npcId;
			ringStationGamePlayer.GP = player.PlayerCharacter.GP;
			ringStationGamePlayer.Grade = player.PlayerCharacter.Grade;
			ringStationGamePlayer.Attack = player.PlayerCharacter.Attack;
			ringStationGamePlayer.Defence = player.PlayerCharacter.Defence;
			ringStationGamePlayer.Luck = player.PlayerCharacter.Luck;
			ringStationGamePlayer.Agility = player.PlayerCharacter.Agility;
			ringStationGamePlayer.hp = player.PlayerCharacter.hp;
			ringStationGamePlayer.FightPower = player.PlayerCharacter.FightPower;
			ringStationGamePlayer.BaseAttack = player.BaseAttack;
			ringStationGamePlayer.BaseDefence = player.BaseDefence;
			ringStationGamePlayer.BaseAgility = player.GetBaseAgility();
			ringStationGamePlayer.BaseBlood = player.PlayerCharacter.hp;
			VirtualPlayerInfo virtualPlayerInfo = GetVirtualPlayerInfo();
			ringStationGamePlayer.Style = virtualPlayerInfo.Style;
			ringStationGamePlayer.Colors = ",,,,,,,,,,,,,,,";
			ringStationGamePlayer.Hide = 1111111111;
			ringStationGamePlayer.TemplateID = virtualPlayerInfo.Weapon;
			ringStationGamePlayer.StrengthLevel = 0;
			ringStationGamePlayer.WeaklessGuildProgressStr = string_0;
			ringStationGamePlayer.ID = npcId;
			if (ringStationBattleServer_0 != null)
			{
				AddPlayer(ringStationGamePlayer.ID, ringStationGamePlayer);
				baseRoomRingStation.AddPlayer(ringStationGamePlayer);
				ringStationBattleServer_0.AddRoom(baseRoomRingStation);
			}
		}

		public static int GetAutoBot(GamePlayer player, int roomtype, int gametype)
		{
			int num = RingStationConfiguration.NextPlayerID();
			BaseRoomRingStation baseRoomRingStation = new BaseRoomRingStation(RingStationConfiguration.NextRoomId());
			baseRoomRingStation.RoomType = roomtype;
			baseRoomRingStation.GameType = gametype;
			baseRoomRingStation.PickUpNpcId = num;
			baseRoomRingStation.IsAutoBot = true;
			baseRoomRingStation.IsFreedom = false;
			RingStationGamePlayer ringStationGamePlayer = new RingStationGamePlayer();
			ringStationGamePlayer.NickName = string_1[threadSafeRandom_0.Next(string_1.Length)] + num;
			ringStationGamePlayer.GP = player.PlayerCharacter.GP;
			ringStationGamePlayer.Grade = player.PlayerCharacter.Grade;
			ringStationGamePlayer.Attack = player.PlayerCharacter.Attack;
			ringStationGamePlayer.Defence = player.PlayerCharacter.Defence;
			ringStationGamePlayer.Luck = player.PlayerCharacter.Luck;
			ringStationGamePlayer.Agility = player.PlayerCharacter.Agility;
			ringStationGamePlayer.hp = player.PlayerCharacter.hp;
			ringStationGamePlayer.FightPower = player.PlayerCharacter.FightPower;
			ringStationGamePlayer.BaseAttack = player.GetBaseAttack();
			ringStationGamePlayer.BaseDefence = player.GetBaseDefence();
			ringStationGamePlayer.BaseAgility = player.GetBaseAgility();
			ringStationGamePlayer.BaseBlood = player.PlayerCharacter.hp;
			VirtualPlayerInfo virtualPlayerInfo = GetVirtualPlayerInfo();
			ringStationGamePlayer.Style = virtualPlayerInfo.Style;
			ringStationGamePlayer.Colors = ",,,,,,,,,,,,,,,";
			ringStationGamePlayer.Hide = 1111111111;
			ringStationGamePlayer.TemplateID = virtualPlayerInfo.Weapon;
			ringStationGamePlayer.StrengthLevel = 0;
			ringStationGamePlayer.WeaklessGuildProgressStr = string_0;
			ringStationGamePlayer.ID = num;
			if (ringStationBattleServer_0 != null)
			{
				AddPlayer(num, ringStationGamePlayer);
				baseRoomRingStation.AddPlayer(ringStationGamePlayer);
				ringStationBattleServer_0.AddRoom(baseRoomRingStation);
			}
			return num;
		}

		public static void CreateBaseAutoBot(int roomtype, int gametype, int npcId)
		{
			BaseRoomRingStation baseRoomRingStation = new BaseRoomRingStation(RingStationConfiguration.NextRoomId());
			baseRoomRingStation.RoomType = roomtype;
			baseRoomRingStation.GameType = gametype;
			baseRoomRingStation.PickUpNpcId = npcId;
			baseRoomRingStation.IsAutoBot = true;
			baseRoomRingStation.IsFreedom = true;
			RingStationGamePlayer ringStationGamePlayer = new RingStationGamePlayer();
			ringStationGamePlayer.NickName = string_1[threadSafeRandom_0.Next(string_1.Length)] + npcId;
			ringStationGamePlayer.GP = 1283;
			ringStationGamePlayer.Grade = 5;
			ringStationGamePlayer.Attack = 100;
			ringStationGamePlayer.Defence = 100;
			ringStationGamePlayer.Luck = 100;
			ringStationGamePlayer.Agility = 100;
			ringStationGamePlayer.hp = 3000;
			ringStationGamePlayer.FightPower = 1200;
			ringStationGamePlayer.BaseAttack = 200.0;
			ringStationGamePlayer.BaseDefence = 120.0;
			ringStationGamePlayer.BaseAgility = 240.0;
			ringStationGamePlayer.BaseBlood = 1000.0;
			VirtualPlayerInfo virtualPlayerInfo = GetVirtualPlayerInfo();
			ringStationGamePlayer.Style = virtualPlayerInfo.Style;
			ringStationGamePlayer.Colors = ",,,,,,,,,,,,,,,";
			ringStationGamePlayer.Hide = 1111111111;
			ringStationGamePlayer.TemplateID = virtualPlayerInfo.Weapon;
			ringStationGamePlayer.StrengthLevel = 0;
			ringStationGamePlayer.WeaklessGuildProgressStr = "R/O/DeABAtgWdWsIAAAAAAAAgCAECwAAAAAAABgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
			ringStationGamePlayer.ID = npcId;
			if (ringStationBattleServer_0 != null)
			{
				AddPlayer(ringStationGamePlayer.ID, ringStationGamePlayer);
				baseRoomRingStation.AddPlayer(ringStationGamePlayer);
				ringStationBattleServer_0.AddRoom(baseRoomRingStation);
			}
		}

		public static UserRingStationInfo BaseRingStationChallenges(int id)
		{
			UserRingStationInfo userRingStationInfo = new UserRingStationInfo();
			userRingStationInfo.Rank = 0;
			userRingStationInfo.WeaponID = virtualPlayerInfo_0.Weapon;
			userRingStationInfo.signMsg = LanguageMgr.GetTranslation("BaseRingStationChallenges.Msg2");
			userRingStationInfo.BaseDamage = 242;
			userRingStationInfo.BaseGuard = 120;
			userRingStationInfo.BaseEnergy = 240;
			userRingStationInfo.Info = new PlayerInfo
			{
				ID = ((id == 0) ? RingStationConfiguration.NextPlayerID() : id),
				UserName = "NormalInfo",
				NickName = LanguageMgr.GetTranslation("BaseRingStationChallenges.Msg1"),
				typeVIP = 1,
				VIPLevel = 1,
				Grade = 25,
				Sex = false,
				Style = virtualPlayerInfo_0.Style,
				Colors = ",,,,,,,,,,,,,,,",
				Skin = "",
				ConsortiaName = "",
				Hide = 1111111111,
				Offer = 0,
				Win = 0,
				Total = 0,
				Escape = 0,
				Repute = 0,
				Nimbus = 0,
				GP = 1437053,
				FightPower = 14370,
				AchievementPoint = 0,
				Attack = 225,
				Defence = 160,
				Agility = 50,
				Luck = 60,
				hp = 3500
			};
			return userRingStationInfo;
		}

		public static void StopAllTimer()
		{
			if (m_statusScanTimer != null)
			{
				m_statusScanTimer.Change(-1, -1);
				m_statusScanTimer.Dispose();
				m_statusScanTimer = null;
			}
		}

		[CompilerGenerated]
		private static DateTime smethod_0(RingstationBattleFieldInfo ringstationBattleFieldInfo_0)
		{
			return ringstationBattleFieldInfo_0.BattleTime;
		}

		[CompilerGenerated]
		private static bool smethod_1(UserRingStationInfo userRingStationInfo_0)
		{
			return userRingStationInfo_0.Rank != 0;
		}

		[CompilerGenerated]
		private static int smethod_2(UserRingStationInfo userRingStationInfo_0)
		{
			return userRingStationInfo_0.Rank;
		}

		[CompilerGenerated]
		private static int smethod_3(UserRingStationInfo userRingStationInfo_0)
		{
			return userRingStationInfo_0.Total;
		}

		[CompilerGenerated]
		private static bool smethod_4(UserRingStationInfo userRingStationInfo_0)
		{
			return userRingStationInfo_0.Rank != 0;
		}

		[CompilerGenerated]
		private static int smethod_5(UserRingStationInfo userRingStationInfo_0)
		{
			return userRingStationInfo_0.Rank;
		}

		static RingStationMgr()
		{
			threadSafeRandom_0 = new ThreadSafeRandom();
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			m_lock = new object();
			dictionary_0 = new Dictionary<int, RingStationGamePlayer>();
			ringStationBattleServer_0 = null;
			string_0 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
			virtualPlayerInfo_0 = new VirtualPlayerInfo();
			list_0 = new List<VirtualPlayerInfo>();
			dictionary_1 = new Dictionary<int, UserRingStationInfo>();
			list_1 = new List<UserRingStationInfo>();
			dictionary_2 = new Dictionary<int, List<RingstationBattleFieldInfo>>();
			int_0 = 10;
		}
	}
}
