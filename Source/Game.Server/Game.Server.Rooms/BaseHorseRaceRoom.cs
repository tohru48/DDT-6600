using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.BuffHorseRace;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Rooms
{
	public class BaseHorseRaceRoom
	{
		public static ThreadSafeRandom random;

		public int RoomId;

		public eStepHorseRace StepProcess;

		private GamePlayer[] AwDmtZvIuq;

		private int[] int_0;

		private byte[] byte_0;

		public bool IsPlaying;

		public bool IsWaiting;

		private int int_1;

		private int int_2;

		public DateTime TimeStartGame;

		protected Timer _startGameTimer;

		public DateTime CountDownEnd;

		private Dictionary<int, GamePlayer> dictionary_0;

		private int int_3;

		[CompilerGenerated]
		private static Func<GamePlayer, bool> ompmaukqZL;

		[CompilerGenerated]
		private static Func<GamePlayer, int> func_0;

		[CompilerGenerated]
		private static Func<GamePlayer, DateTime> func_1;

		public BaseHorseRaceRoom(int roomId)
		{
			int_3 = GameProperties.HorseGamePlayerCount;
			RoomId = roomId;
			AwDmtZvIuq = new GamePlayer[int_3];
			int_0 = new int[int_3];
			byte_0 = new byte[int_3];
			int_2 = int_3;
			method_3();
		}

		public void StartGameTimer()
		{
			if (!IsPlaying)
			{
				IsPlaying = true;
				IsWaiting = false;
				method_4();
				int num = 1000;
				if (_startGameTimer == null)
				{
					_startGameTimer = new Timer(method_0, null, num, num);
				}
				else
				{
					_startGameTimer.Change(num, num);
				}
			}
		}

		public void StopGameTimer()
		{
			if (_startGameTimer != null)
			{
				_startGameTimer.Dispose();
				_startGameTimer = null;
			}
		}

		private void method_0(object object_0)
		{
			try
			{
				int tickCount = Environment.TickCount;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				switch (StepProcess)
				{
				case eStepHorseRace.WAITING:
					SendBeginStartGame();
					StepProcess = eStepHorseRace.COUNTDOWN;
					break;
				case eStepHorseRace.COUNTDOWN:
					TimeStartGame = DateTime.Now.AddSeconds(10.0);
					SendCountDown((DateTime.Now - TimeStartGame).Milliseconds);
					StepProcess = eStepHorseRace.WAIT_COUNTDOWN;
					break;
				case eStepHorseRace.WAIT_COUNTDOWN:
					if (!(DateTime.Now >= TimeStartGame))
					{
						break;
					}
					SendStartGame();
					lock (AwDmtZvIuq)
					{
						GamePlayer[] awDmtZvIuq = AwDmtZvIuq;
						foreach (GamePlayer gamePlayer2 in awDmtZvIuq)
						{
							if (gamePlayer2 != null && gamePlayer2.CurrentHorseRaceInfo != null)
							{
								gamePlayer2.CurrentHorseRaceInfo.Reset();
								SendUpdateBuffItem(gamePlayer2, successpingzhang: false);
							}
						}
					}
					StepProcess = eStepHorseRace.STARTING_RACE;
					break;
				case eStepHorseRace.STARTING_RACE:
					if (CanStopGame())
					{
						SendAllFinish();
						StepProcess = eStepHorseRace.END_RACE;
					}
					else
					{
						method_2();
						SendSynGame();
					}
					break;
				case eStepHorseRace.END_RACE:
				{
					StopGameTimer();
					List<GamePlayer> playersWithRank = GetPlayersWithRank();
					foreach (GamePlayer item in playersWithRank)
					{
						method_1(item.CurrentHorseRaceInfo.Rank, item.PlayerCharacter.NickName, item.PlayerCharacter.ID);
					}
					GamePlayer[] playersUnSafe = GetPlayersUnSafe();
					GamePlayer[] array = playersUnSafe;
					foreach (GamePlayer gamePlayer in array)
					{
						if (gamePlayer != null && gamePlayer.CurrentHorseRaceRoom != null)
						{
							gamePlayer.CurrentHorseRaceRoom.RemovePlayerUnsafe(gamePlayer);
						}
					}
					method_3();
					break;
				}
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
			}
			catch (Exception ex)
			{
				Console.WriteLine("HorseRace Timer Error: " + ex.ToString());
			}
		}

		private void method_1(int int_4, string string_0, int int_5)
		{
			int[] array = new int[5] { 201574, 201575, 201576, 201577, 201578 };
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(array[int_4 - 1]);
			if (ıtemTemplateInfo != null)
			{
				ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 101);
				ıtemInfo.IsBinds = true;
				ıtemInfo.ValidDate = 0;
				WorldEventMgr.SendItemToMail(ıtemInfo, int_5, string_0, LanguageMgr.GetTranslation("GameServer.HorseGame.MailAwardTitle", int_4));
			}
		}

		private void method_2()
		{
			lock (AwDmtZvIuq)
			{
				List<GamePlayer> list = new List<GamePlayer>();
				GamePlayer[] awDmtZvIuq = AwDmtZvIuq;
				foreach (GamePlayer gamePlayer in awDmtZvIuq)
				{
					if (gamePlayer != null && gamePlayer.CurrentHorseRaceInfo != null)
					{
						if (gamePlayer.CurrentHorseRaceInfo.CheckBuff())
						{
							SendUpdateBuffItem(gamePlayer, successpingzhang: false);
						}
						if (!gamePlayer.CurrentHorseRaceInfo.IsSendSpeed)
						{
							list.Add(gamePlayer);
							gamePlayer.CurrentHorseRaceInfo.IsSendSpeed = true;
						}
						if (gamePlayer.CurrentHorseRaceInfo.RaceLength < RoomMgr.MaxRaceLength)
						{
							gamePlayer.CurrentHorseRaceInfo.ChangePos();
						}
						if (gamePlayer.CurrentHorseRaceInfo.RaceLength >= RoomMgr.MaxRaceLength && !dictionary_0.ContainsKey(gamePlayer.PlayerCharacter.ID))
						{
							gamePlayer.SendMessage(LanguageMgr.GetTranslation("GameServer.HorseGame.CompleteNotice"));
							gamePlayer.CurrentHorseRaceInfo.RaceLength = RoomMgr.MaxRaceLength;
							dictionary_0.Add(gamePlayer.PlayerCharacter.ID, gamePlayer);
							SendPlayerFinish(dictionary_0.Values.ToList());
						}
					}
				}
				if (list.Count > 0)
				{
					SendUpdateSpeed(list);
				}
			}
		}

		private void method_3()
		{
			for (int i = 0; i < int_3; i++)
			{
				AwDmtZvIuq[i] = null;
				int_0[i] = -1;
				byte_0[i] = 0;
			}
			IsPlaying = false;
			IsWaiting = false;
			int_2 = int_3;
			int_1 = 0;
			StepProcess = eStepHorseRace.WAITING;
			TimeStartGame = DateTime.Now;
			CountDownEnd = DateTime.Now;
			dictionary_0 = new Dictionary<int, GamePlayer>();
		}

		public bool CanAddPlayer()
		{
			return int_1 < int_2;
		}

		public bool CanStartGame()
		{
			return !IsPlaying && int_1 >= int_2;
		}

		public bool CanStopGame()
		{
			if (IsPlaying && StepProcess == eStepHorseRace.STARTING_RACE)
			{
				if (int_1 == 0)
				{
					return true;
				}
				int num = 0;
				int num2 = 0;
				GamePlayer[] awDmtZvIuq = AwDmtZvIuq;
				foreach (GamePlayer gamePlayer in awDmtZvIuq)
				{
					if (gamePlayer != null)
					{
						num2++;
						if (gamePlayer.CurrentHorseRaceInfo != null && gamePlayer.CurrentHorseRaceInfo.RaceLength >= RoomMgr.MaxRaceLength)
						{
							num++;
						}
					}
				}
				if (num >= num2)
				{
					return true;
				}
			}
			return false;
		}

		public bool AddPlayerUnsafe(GamePlayer player)
		{
			int num = -1;
			lock (AwDmtZvIuq)
			{
				for (int i = 0; i < int_3; i++)
				{
					if (AwDmtZvIuq[i] == null && int_0[i] == -1)
					{
						AwDmtZvIuq[i] = player;
						int_0[i] = player.PlayerId;
						int_1++;
						num = i;
						break;
					}
				}
			}
			if (num != -1)
			{
				player.CurrentHorseRaceRoom = this;
				player.CurrentHorseRaceInfo = new UserHorseRaceInfo(player.PlayerCharacter.ID, player.PlayerCharacter.NickName, player.PlayerCharacter.MountLv, num, 10);
			}
			return num != -1;
		}

		public bool RemovePlayerUnsafe(GamePlayer player)
		{
			int num = -1;
			lock (AwDmtZvIuq)
			{
				for (int i = 0; i < int_3; i++)
				{
					if (AwDmtZvIuq[i] == player)
					{
						AwDmtZvIuq[i] = null;
						byte_0[i] = 0;
						int_0[i] = -1;
						int_1--;
						num = i;
						break;
					}
				}
			}
			if (num != -1)
			{
				if (player.CurrentHorseRaceInfo != null)
				{
					player.CurrentHorseRaceInfo.Stop();
				}
				player.CurrentHorseRaceRoom = null;
				player.CurrentHorseRaceInfo = null;
				player.TempBag.ClearBag();
			}
			if (int_1 <= 0 && _startGameTimer == null)
			{
				method_3();
			}
			return num != -1;
		}

		public void SendBeginStartGame()
		{
			GamePlayer[] playersSafe = GetPlayersSafe();
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(RoomId);
			gSPacketIn.WriteInt(playersSafe.Length);
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ID);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.NickName);
				gSPacketIn.WriteBoolean(gamePlayer.PlayerCharacter.Sex);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Hide);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Style);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Colors);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Skin);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Grade);
				gSPacketIn.WriteInt(gamePlayer.CurrentHorseRaceInfo.Index);
				gSPacketIn.WriteInt(gamePlayer.CurrentHorseRaceInfo.Speed);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.MountsType);
			}
			method_5(gSPacketIn);
		}

		public void SendCountDown(int timerLeft)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(timerLeft);
			method_5(gSPacketIn);
		}

		public void SendStartGame()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(4);
			method_5(gSPacketIn);
		}

		public void SendPlayerFinish(List<GamePlayer> player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(10);
			gSPacketIn.WriteInt(player.Count);
			foreach (GamePlayer item in player)
			{
				gSPacketIn.WriteInt(item.PlayerCharacter.ID);
			}
			method_5(gSPacketIn);
		}

		public void SendAllFinish()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(6);
			gSPacketIn.WriteInt(dictionary_0.Count);
			foreach (int key in dictionary_0.Keys)
			{
				gSPacketIn.WriteInt(key);
			}
			method_5(gSPacketIn);
		}

		public void SendUpdateBuffItem(GamePlayer p, bool successpingzhang)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteInt(p.CurrentHorseRaceInfo.BuffItem1);
			gSPacketIn.WriteInt(p.CurrentHorseRaceInfo.BuffItem2);
			gSPacketIn.WriteBoolean(successpingzhang);
			p.SendTCP(gSPacketIn);
		}

		public void SendShowMsg(string attacker, string buffName, string defender)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(11);
			gSPacketIn.WriteString(attacker);
			gSPacketIn.WriteString(buffName);
			gSPacketIn.WriteString(defender);
			method_5(gSPacketIn);
		}

		public void SendUpdateSpeed(List<GamePlayer> lists)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(9);
			gSPacketIn.WriteInt(lists.Count);
			foreach (GamePlayer list in lists)
			{
				gSPacketIn.WriteInt(list.PlayerCharacter.ID);
				gSPacketIn.WriteInt(list.CurrentHorseRaceInfo.Speed);
			}
			method_5(gSPacketIn);
		}

		public void SendSynGame()
		{
			GamePlayer[] playersSafe = GetPlayersSafe();
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(5);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(playersSafe.Length);
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				bool val = dictionary_0.ContainsKey(gamePlayer.PlayerCharacter.ID);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ID);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(gamePlayer.CurrentHorseRaceInfo.RaceLength);
				gSPacketIn.WriteBoolean(val);
				List<AbstractHorseRaceBuffer> allBuffers = gamePlayer.CurrentHorseRaceInfo.BuffList.GetAllBuffers();
				gSPacketIn.WriteInt(allBuffers.Count);
				foreach (AbstractHorseRaceBuffer item in allBuffers)
				{
					gSPacketIn.WriteByte((byte)item.Info.Type);
					gSPacketIn.WriteInt(0);
					gSPacketIn.WriteInt(0);
					gSPacketIn.WriteInt(0);
				}
			}
			method_5(gSPacketIn);
		}

		private void method_4()
		{
			GamePlayer[] playersUnSafe = GetPlayersUnSafe();
			GamePlayer[] array = playersUnSafe;
			for (int i = 0; i < array.Length; i++)
			{
				array[i]?.RemoveHorseRaceTimes(1);
			}
		}

		public GamePlayer[] GetPlayersSafe()
		{
			GamePlayer[] array = null;
			List<GamePlayer> list = new List<GamePlayer>();
			lock (AwDmtZvIuq)
			{
				GamePlayer[] awDmtZvIuq = AwDmtZvIuq;
				foreach (GamePlayer gamePlayer in awDmtZvIuq)
				{
					if (gamePlayer != null)
					{
						list.Add(gamePlayer);
					}
				}
				array = new GamePlayer[list.Count];
				list.CopyTo(array, 0);
			}
			if (array != null)
			{
				return array;
			}
			return new GamePlayer[0];
		}

		public GamePlayer[] GetPlayersUnSafe()
		{
			List<GamePlayer> list = new List<GamePlayer>();
			lock (AwDmtZvIuq)
			{
				GamePlayer[] awDmtZvIuq = AwDmtZvIuq;
				foreach (GamePlayer gamePlayer in awDmtZvIuq)
				{
					if (gamePlayer != null)
					{
						list.Add(gamePlayer);
					}
				}
			}
			return list.ToArray();
		}

		public GamePlayer GetPlayerByID(int userId)
		{
			GamePlayer result;
			lock (AwDmtZvIuq)
			{
				GamePlayer[] awDmtZvIuq = AwDmtZvIuq;
				foreach (GamePlayer gamePlayer in awDmtZvIuq)
				{
					if (gamePlayer != null && gamePlayer.PlayerCharacter.ID == userId)
					{
						result = gamePlayer;
						return result;
					}
				}
				result = null;
			}
			return result;
		}

		public List<GamePlayer> GetPlayersWithRank()
		{
			List<GamePlayer> list = new List<GamePlayer>();
			GamePlayer[] playersSafe = GetPlayersSafe();
			IEnumerable<GamePlayer> source = playersSafe;
			IEnumerable<GamePlayer> source2 = source.Where((GamePlayer gamePlayer_0) => gamePlayer_0.CurrentHorseRaceInfo.RaceLength > 0);
			IOrderedEnumerable<GamePlayer> source3 = source2.OrderBy((GamePlayer gamePlayer_0) => gamePlayer_0.CurrentHorseRaceInfo.RaceLength);
			IOrderedEnumerable<GamePlayer> orderedEnumerable = source3.ThenByDescending((GamePlayer gamePlayer_0) => gamePlayer_0.CurrentHorseRaceInfo.FinishTime);
			int num = 1;
			foreach (GamePlayer item in orderedEnumerable)
			{
				item.CurrentHorseRaceInfo.Rank = num;
				list.Add(item);
				num++;
			}
			return list;
		}

		public void method_5(GSPacketIn packet)
		{
			method_6(packet, null);
		}

		public void method_6(GSPacketIn packet, GamePlayer except)
		{
			GamePlayer[] playersSafe = GetPlayersSafe();
			if (playersSafe == null)
			{
				return;
			}
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer != null && gamePlayer != except)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		[CompilerGenerated]
		private static bool smethod_0(GamePlayer gamePlayer_0)
		{
			return gamePlayer_0.CurrentHorseRaceInfo.RaceLength > 0;
		}

		[CompilerGenerated]
		private static int smethod_1(GamePlayer gamePlayer_0)
		{
			return gamePlayer_0.CurrentHorseRaceInfo.RaceLength;
		}

		[CompilerGenerated]
		private static DateTime smethod_2(GamePlayer gamePlayer_0)
		{
			return gamePlayer_0.CurrentHorseRaceInfo.FinishTime;
		}

		static BaseHorseRaceRoom()
		{
			random = new ThreadSafeRandom();
		}
	}
}
