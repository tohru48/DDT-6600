using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Game.Logic;
using Game.Server.Battle;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Rooms
{
	public class RoomMgr
	{
		private static readonly ILog ilog_0;

		private static bool vbefgnexMo;

		private static Queue<IAction> queue_0;

		private static Thread thread_0;

		private static BaseRoom[] baseRoom_0;

		private static BaseWaitingRoom baseWaitingRoom_0;

		private static BaseWorldBossRoom baseWorldBossRoom_0;

		private static BaseSevenDoubleRoom[] baseSevenDoubleRoom_0;

		private static BaseCampBattleRoom baseCampBattleRoom_0;

		private static BaseConsBatRoom baseConsBatRoom_0;

		private static BaseChristmasRoom baseChristmasRoom_0;

		private static BaseCatchInsectRoom baseCatchInsectRoom_0;

		public static int MaxRaceLength;

		public static int TimehorseRaceCanRaceTimeDown;

		private static BaseHorseRaceRoom[] baseHorseRaceRoom_0;

		public static readonly int THREAD_INTERVAL;

		public static readonly int PICK_UP_INTERVAL;

		public static readonly int CLEAR_ROOM_INTERVAL;

		private static long long_0;

		public static BaseSevenDoubleRoom[] SevenDoubleRoom => baseSevenDoubleRoom_0;

		public static BaseCampBattleRoom CampBattleRoom => baseCampBattleRoom_0;

		public static BaseConsBatRoom ConsBatRoom => baseConsBatRoom_0;

		public static BaseChristmasRoom ChristmasRoom => baseChristmasRoom_0;

		public static BaseRoom[] Rooms => baseRoom_0;

		public static BaseWaitingRoom WaitingRoom => baseWaitingRoom_0;

		public static BaseWorldBossRoom WorldBossRoom => baseWorldBossRoom_0;

		public static BaseCatchInsectRoom CatchInsectRoom => baseCatchInsectRoom_0;

		public static BaseHorseRaceRoom[] HorseRaceRoom => baseHorseRaceRoom_0;

		public static bool Setup(int maxRoom)
		{
			maxRoom = ((maxRoom < 1) ? 1 : maxRoom);
			thread_0 = new Thread(smethod_0);
			queue_0 = new Queue<IAction>();
			baseRoom_0 = new BaseRoom[maxRoom];
			for (int i = 0; i < maxRoom; i++)
			{
				baseRoom_0[i] = new BaseRoom(i + 1);
			}
			baseSevenDoubleRoom_0 = new BaseSevenDoubleRoom[maxRoom];
			for (int j = 0; j < maxRoom; j++)
			{
				baseSevenDoubleRoom_0[j] = new BaseSevenDoubleRoom(j + 1);
			}
			baseHorseRaceRoom_0 = new BaseHorseRaceRoom[maxRoom];
			for (int k = 0; k < maxRoom; k++)
			{
				baseHorseRaceRoom_0[k] = new BaseHorseRaceRoom(k + 1);
			}
			baseWaitingRoom_0 = new BaseWaitingRoom();
			baseWorldBossRoom_0 = new BaseWorldBossRoom();
			baseChristmasRoom_0 = new BaseChristmasRoom();
			baseConsBatRoom_0 = new BaseConsBatRoom();
			baseCampBattleRoom_0 = new BaseCampBattleRoom();
			baseCatchInsectRoom_0 = new BaseCatchInsectRoom();
			return true;
		}

		public static void Start()
		{
			if (!vbefgnexMo)
			{
				vbefgnexMo = true;
				thread_0.Start();
			}
		}

		public static void Stop()
		{
			if (vbefgnexMo)
			{
				vbefgnexMo = false;
				thread_0.Join();
			}
		}

		private static void smethod_0()
		{
			Thread.CurrentThread.Priority = ThreadPriority.Highest;
			long num = 0L;
			long_0 = TickHelper.GetTickCount();
			while (vbefgnexMo)
			{
				long tickCount = TickHelper.GetTickCount();
				int num2 = 0;
				try
				{
					num2 = smethod_1();
					if (long_0 <= tickCount)
					{
						long_0 += CLEAR_ROOM_INTERVAL;
						ClearRooms(tickCount);
					}
				}
				catch (Exception exception)
				{
					ilog_0.Error("Room Mgr Thread Error:", exception);
				}
				long tickCount2 = TickHelper.GetTickCount();
				num += THREAD_INTERVAL - (tickCount2 - tickCount);
				if (tickCount2 - tickCount > THREAD_INTERVAL)
				{
					ilog_0.WarnFormat("Room Mgr is spent too much times: {0} ms,count:{1}", tickCount2 - tickCount, num2);
				}
				if (num > 0)
				{
					Thread.Sleep((int)num);
					num = 0L;
				}
				else if (num < -1000)
				{
					num += 1000;
				}
			}
		}

		private static int smethod_1()
		{
			IAction[] array = null;
			lock (queue_0)
			{
				if (queue_0.Count > 0)
				{
					array = new IAction[queue_0.Count];
					queue_0.CopyTo(array, 0);
					queue_0.Clear();
				}
			}
			if (array != null)
			{
				IAction[] array2 = array;
				foreach (IAction action in array2)
				{
					try
					{
						long tickCount = TickHelper.GetTickCount();
						action.Execute();
						long tickCount2 = TickHelper.GetTickCount();
						if (tickCount2 - tickCount > THREAD_INTERVAL)
						{
							ilog_0.WarnFormat("RoomMgr action spent too much times:{0},{1}ms!", action.GetType(), tickCount2 - tickCount);
						}
					}
					catch (Exception exception)
					{
						ilog_0.Error("RoomMgr execute action error:", exception);
					}
				}
				return array.Length;
			}
			return 0;
		}

		public static void ClearRooms(long tick)
		{
			BaseRoom[] array = baseRoom_0;
			foreach (BaseRoom baseRoom in array)
			{
				if (baseRoom.IsUsing && baseRoom.PlayerCount == 0)
				{
					baseRoom.Stop();
				}
			}
		}

		public static void AddAction(IAction action)
		{
			lock (queue_0)
			{
				queue_0.Enqueue(action);
			}
		}

		public static void CreateRoom(GamePlayer player, string name, string password, eRoomType roomType, byte timeType)
		{
			AddAction(new CreateRoomAction(player, name, password, roomType, timeType));
		}

		public static void CreateCampBattleRoom(GamePlayer player, GamePlayer ChallengePlayer)
		{
			AddAction(new CreateCampBattleRoomAction(player, ChallengePlayer));
		}

		public static void CreateCampBattleBossRoom(GamePlayer player, int mapId)
		{
			AddAction(new CreateCampBattleBossAction(player, eRoomType.CampBattleBattle, 1, mapId));
		}

		public static void CreateCryptBossRoom(GamePlayer player, int id, int level)
		{
			AddAction(new CreateCryptBossAction(player, id, level));
		}

		public static void CreateCatchBeastRoom(GamePlayer player)
		{
			AddAction(new CreateCatchBeastAction(player));
		}

		public static void CreateConsortiaBattleRoom(GamePlayer player, GamePlayer ChallengePlayer)
		{
			AddAction(new CreateConsortiaBattleRoomAction(player, ChallengePlayer));
		}

		public static void CreateRingStationRoom(GamePlayer player, UserRingStationInfo challengePlayer)
		{
			AddAction(new CreateRingStationRoomAction(player, challengePlayer));
		}

		public static void CreateBattleRoom(GamePlayer player, eRoomType roomType)
		{
			AddAction(new CreateBattleRoomAction(player, roomType));
		}

		public static void CreateFightFootballTimeRoom(GamePlayer player, eRoomType roomType)
		{
			AddAction(new CreateFightFootballTimeRoomAction(player, roomType));
		}

		public static void CreateEncounterRoom(GamePlayer player, eRoomType roomType)
		{
			AddAction(new CreateEncounterRoomAction(player, roomType));
		}

		public static void CreateGroupBattleRoom(GamePlayer player, int groupType)
		{
			AddAction(new CreateGroupBattleRoomAction(player, groupType));
		}

		public static void CreateConsortiaBossRoom(GamePlayer player, eRoomType roomType, int bossLevel)
		{
			AddAction(new CreateConsortiaBossAction(player, roomType, bossLevel));
		}

		public static void EnterRoom(GamePlayer player, int roomId, string pwd, int type)
		{
			AddAction(new Class24(player, roomId, pwd, type));
		}

		public static void EnterRoom(GamePlayer player)
		{
			EnterRoom(player, -1, null, 1);
		}

		public static void ExitRoom(BaseRoom room, GamePlayer player)
		{
			AddAction(new ExitRoomAction(room, player));
		}

		public static void StartGame(BaseRoom room)
		{
			AddAction(new StartGameAction(room));
		}

		public static void StartGameMission(BaseRoom room)
		{
			AddAction(new StartGameMissionAction(room));
		}

		public static void UpdatePlayerState(GamePlayer player, byte state)
		{
			AddAction(new UpdatePlayerStateAction(player, player.CurrentRoom, state));
		}

		public static void UpdateRoomPos(BaseRoom room, int pos, bool isOpened, int place, int placeView)
		{
			AddAction(new UpdateRoomPosAction(room, pos, isOpened, place, placeView));
		}

		public static void KickPlayer(BaseRoom baseRoom, byte index)
		{
			AddAction(new KickPlayerAction(baseRoom, index));
		}

		public static void EnterWaitingRoom(GamePlayer player)
		{
			AddAction(new EnterWaitingRoomAction(player));
		}

		public static void ExitWaitingRoom(GamePlayer player)
		{
			AddAction(new ExitWaitRoomAction(player));
		}

		public static void CancelPickup(BattleServer server, BaseRoom room)
		{
			AddAction(new CancelPickupAction(server, room));
		}

		public static void UpdateRoomGameType(BaseRoom room, eRoomType roomType, byte timeMode, eHardLevel hardLevel, int levelLimits, int mapId, string password, string roomname, bool isCrosszone, bool isOpenBoss, string Pic, int currentFloor)
		{
			AddAction(new Class23(room, roomType, timeMode, hardLevel, levelLimits, mapId, password, roomname, isCrosszone, isOpenBoss, Pic, currentFloor));
		}

		internal static void smethod_2(GamePlayer gamePlayer_0)
		{
			AddAction(new SwitchTeamAction(gamePlayer_0));
		}

		public static void CreateHorseRaceRoom(GamePlayer player)
		{
			AddAction(new CreateHorseRaceRoomAction(player));
		}

		public static void ExitHorseRaceRoom(BaseHorseRaceRoom room, GamePlayer player)
		{
		}

		public static List<BaseRoom> GetAllUsingRoom()
		{
			List<BaseRoom> list = new List<BaseRoom>();
			lock (baseRoom_0)
			{
				BaseRoom[] array = baseRoom_0;
				foreach (BaseRoom baseRoom in array)
				{
					if (baseRoom.IsUsing)
					{
						list.Add(baseRoom);
					}
				}
			}
			return list;
		}

		public static List<BaseRoom> GetAllRooms()
		{
			List<BaseRoom> list = new List<BaseRoom>();
			lock (baseRoom_0)
			{
				BaseRoom[] array = baseRoom_0;
				foreach (BaseRoom baseRoom in array)
				{
					if (!baseRoom.IsEmpty)
					{
						list.Add(baseRoom);
					}
				}
			}
			return list;
		}

		public static List<BaseRoom> GetAllRooms(BaseRoom seffRoom)
		{
			List<BaseRoom> list = new List<BaseRoom>();
			list.Add(seffRoom);
			lock (baseRoom_0)
			{
				BaseRoom[] array = baseRoom_0;
				foreach (BaseRoom baseRoom in array)
				{
					if (!baseRoom.IsEmpty)
					{
						list.Add(baseRoom);
					}
				}
			}
			return list;
		}

		public static List<BaseRoom> GetAllPveRooms()
		{
			List<BaseRoom> list = new List<BaseRoom>();
			lock (baseRoom_0)
			{
				BaseRoom[] array = baseRoom_0;
				foreach (BaseRoom baseRoom in array)
				{
					if (baseRoom.IsUsing && (baseRoom.RoomType == eRoomType.Dungeon || baseRoom.RoomType == eRoomType.AcademyDungeon || baseRoom.RoomType == eRoomType.ActivityDungeon || baseRoom.RoomType == eRoomType.SpecialActivityDungeon))
					{
						list.Add(baseRoom);
					}
				}
			}
			return list;
		}

		public static List<BaseRoom> GetAllMatchRooms()
		{
			List<BaseRoom> list = new List<BaseRoom>();
			lock (baseRoom_0)
			{
				BaseRoom[] array = baseRoom_0;
				foreach (BaseRoom baseRoom in array)
				{
					if (baseRoom.IsUsing && (baseRoom.RoomType == eRoomType.Match || baseRoom.RoomType == eRoomType.Freedom))
					{
						list.Add(baseRoom);
					}
				}
			}
			return list;
		}

		public static void StartProxyGame(BaseRoom room, ProxyGame game)
		{
			AddAction(new StartProxyGameAction(room, game));
		}

		public static void StopProxyGame(BaseRoom room)
		{
			AddAction(new StopProxyGameAction(room));
		}

		static RoomMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			MaxRaceLength = 40000;
			TimehorseRaceCanRaceTimeDown = 10;
			THREAD_INTERVAL = 200;
			PICK_UP_INTERVAL = 10000;
			CLEAR_ROOM_INTERVAL = 400;
			long_0 = 0L;
		}
	}
}
