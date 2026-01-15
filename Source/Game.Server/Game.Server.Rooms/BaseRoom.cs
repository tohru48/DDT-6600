using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Object;
using Game.Server.Battle;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Rooms
{
	public class BaseRoom
	{
		private static readonly ILog ilog_0;

		private GamePlayer[] gamePlayer_0;

		private int[] int_0;

		private byte[] byte_0;

		private int int_1;

		private int int_2;

		private bool bool_0;

		private GamePlayer gamePlayer_1;

		public bool IsPlaying;

		public int RoomId;

		public int PickUpNpcId;

		public int maxViewerCnt;

		private int int_3;

		public int GameStyle;

		public int barrierNum;

		public string Name;

		public string Pic;

		public string Password;

		public bool isCrosszone;

		public bool isWithinLeageTime;

		public bool isOpenBoss;

		public eRoomType RoomType;

		public eGameType GameType;

		public eHardLevel HardLevel;

		public int LevelLimits;

		public int currentFloor;

		public byte TimeMode;

		public int MapId;

		public string m_roundName;

		public int ZoneId;

		private bool bool_1;

		private int int_4;

		private AbstractGame abstractGame_0;

		public BattleServer BattleServer;

		public int viewerCnt => int_3;

		public GamePlayer Host => gamePlayer_1;

		public byte[] PlayerState
		{
			get
			{
				return byte_0;
			}
			set
			{
				byte_0 = value;
			}
		}

		public int PlayerCount => int_1;

		public int PlacesCount => int_2;

		public int GuildId => gamePlayer_1.PlayerCharacter.ConsortiaID;

		public bool IsUsing => bool_0;

		public string RoundName
		{
			get
			{
				return m_roundName;
			}
			set
			{
				m_roundName = value;
			}
		}

		public bool StartWithNpc
		{
			get
			{
				return bool_1;
			}
			set
			{
				bool_1 = value;
			}
		}

		public bool NeedPassword => !string.IsNullOrEmpty(Password);

		public bool IsEmpty => int_1 == 0;

		public int AvgLevel => int_4;

		public AbstractGame Game => abstractGame_0;

		public BaseRoom(int roomId)
		{
			int_2 = 10;
			maxViewerCnt = 2;
			RoomId = roomId;
			gamePlayer_0 = new GamePlayer[10];
			int_0 = new int[10];
			byte_0 = new byte[8];
			PickUpNpcId = -1;
			method_0();
		}

		public void Start()
		{
			if (!bool_0)
			{
				bool_0 = true;
				method_0();
			}
		}

		public void Stop()
		{
			if (bool_0)
			{
				bool_0 = false;
				if (abstractGame_0 != null)
				{
					abstractGame_0.GameStopped -= method_1;
					abstractGame_0 = null;
					IsPlaying = false;
				}
				RoomMgr.WaitingRoom.SendUpdateCurrentRoom(this);
			}
		}

		private void method_0()
		{
			for (int i = 0; i < 10; i++)
			{
				gamePlayer_0[i] = null;
				int_0[i] = -1;
				if (i < 8)
				{
					byte_0[i] = 0;
				}
			}
			gamePlayer_1 = null;
			IsPlaying = false;
			int_2 = 10;
			int_1 = 0;
			HardLevel = eHardLevel.Easy;
			PickUpNpcId = -1;
		}

		public bool CanStart()
		{
			if (RoomType == eRoomType.Freedom)
			{
				int num = 0;
				int num2 = 0;
				for (int i = 0; i < 8; i++)
				{
					if (i % 2 == 0)
					{
						if (byte_0[i] > 0)
						{
							num++;
						}
					}
					else if (byte_0[i] > 0)
					{
						num2++;
					}
				}
				return num > 0 && num2 > 0;
			}
			int num3 = 0;
			for (int j = 0; j < 8; j++)
			{
				if (byte_0[j] > 0)
				{
					num3++;
				}
			}
			return num3 == int_1;
		}

		public bool CanAddPlayer()
		{
			return int_1 < int_2;
		}

		public List<GamePlayer> GetPlayers()
		{
			List<GamePlayer> list = new List<GamePlayer>();
			lock (gamePlayer_0)
			{
				for (int i = 0; i < 10; i++)
				{
					if (gamePlayer_0[i] != null)
					{
						list.Add(gamePlayer_0[i]);
					}
				}
			}
			return list;
		}

		public void SetHost(GamePlayer player)
		{
			if (gamePlayer_1 != player)
			{
				if (gamePlayer_1 != null)
				{
					UpdatePlayerState(player, 0, sendToClient: false);
				}
				gamePlayer_1 = player;
				UpdatePlayerState(player, 2, sendToClient: true);
			}
		}

		public void UpdateRoom(string name, string pwd, eRoomType roomType, byte timeMode, int mapId)
		{
			Name = name;
			Password = pwd;
			RoomType = roomType;
			TimeMode = timeMode;
			MapId = mapId;
			UpdateRoomGameType();
			if (roomType == eRoomType.Freedom)
			{
				int_2 = 8;
			}
			else
			{
				int_2 = 4;
			}
		}

		public void UpdateRoomGameType()
		{
			switch (RoomType)
			{
			case eRoomType.Match:
			case eRoomType.Freedom:
				GameType = eGameType.Free;
				break;
			case eRoomType.BattleRoom:
				GameType = eGameType.BattleGame;
				break;
			case eRoomType.FightLib:
				GameType = eGameType.FightLib;
				break;
			case eRoomType.Freshman:
				GameType = eGameType.Freshman;
				break;
			case eRoomType.Encounter:
				GameType = eGameType.Encounter;
				break;
			case eRoomType.ConsortiaBoss:
				GameType = eGameType.ConsortiaBoss;
				break;
			case eRoomType.ConsortiaBattle:
				GameType = eGameType.ConsortiaBattle;
				break;
			case eRoomType.CampBattleBattle:
				GameType = eGameType.CampBattleModelPve;
				break;
			case eRoomType.RingStation:
				GameType = eGameType.RingStation;
				break;
			case eRoomType.FightFootballTime:
				GameType = eGameType.FightFootballTime;
				break;
			case eRoomType.Entertainment:
				GameType = eGameType.EntertainmentMode;
				break;
			case eRoomType.EntertainmentPK:
				GameType = eGameType.EntertainmentModePK;
				break;
			case eRoomType.Dungeon:
			case eRoomType.AcademyDungeon:
			case eRoomType.Lanbyrinth:
			case eRoomType.ActivityDungeon:
			case eRoomType.SpecialActivityDungeon:
			case eRoomType.FarmBoss:
			case eRoomType.Christmas:
			case eRoomType.Cryptboss:
				GameType = eGameType.Dungeon;
				break;
			default:
				GameType = eGameType.ALL;
				break;
			}
		}

		public void UpdatePlayerState(GamePlayer player, byte state, bool sendToClient)
		{
			byte_0[player.CurrentRoomIndex] = state;
			if (sendToClient)
			{
				SendPlayerState();
			}
		}

		public void UpdateAvgLevel()
		{
			int num = 0;
			for (int i = 0; i < 8; i++)
			{
				if (gamePlayer_0[i] != null)
				{
					num += gamePlayer_0[i].PlayerCharacter.Grade;
				}
			}
			int_4 = num / int_1;
		}

		public void SendToAll(GSPacketIn pkg)
		{
			SendToAll(pkg, null);
		}

		public void SendToAll(GSPacketIn pkg, GamePlayer except)
		{
			GamePlayer[] array = null;
			lock (gamePlayer_0)
			{
				array = (GamePlayer[])gamePlayer_0.Clone();
			}
			if (array == null)
			{
				return;
			}
			for (int i = 0; i < array.Length; i++)
			{
				if (array[i] != null && array[i] != except)
				{
					array[i].Out.SendTCP(pkg);
				}
			}
		}

		public void SendToTeam(GSPacketIn pkg, int team)
		{
			SendToTeam(pkg, team, null);
		}

		public void SendToTeam(GSPacketIn pkg, int team, GamePlayer except)
		{
			GamePlayer[] array = null;
			lock (gamePlayer_0)
			{
				array = (GamePlayer[])gamePlayer_0.Clone();
			}
			for (int i = 0; i < array.Length; i++)
			{
				if (array[i] != null && array[i].CurrentRoomTeam == team && array[i] != except)
				{
					array[i].Out.SendTCP(pkg);
				}
			}
		}

		public void SendToHost(GSPacketIn pkg)
		{
			GamePlayer[] array = null;
			lock (gamePlayer_0)
			{
				array = (GamePlayer[])gamePlayer_0.Clone();
			}
			for (int i = 0; i < array.Length; i++)
			{
				if (array[i] != null && array[i] == Host)
				{
					array[i].Out.SendTCP(pkg);
				}
			}
		}

		public void SendPlayerState()
		{
			GSPacketIn pkg = gamePlayer_1.Out.SendRoomUpdatePlayerStates(byte_0);
			SendToAll(pkg, gamePlayer_1);
		}

		public void SendPlaceState()
		{
			if (gamePlayer_1 != null)
			{
				GSPacketIn pkg = gamePlayer_1.Out.SendRoomUpdatePlacesStates(int_0);
				SendToAll(pkg, gamePlayer_1);
			}
		}

		public void SendCancelPickUp()
		{
			if (gamePlayer_1 != null)
			{
				GSPacketIn pkg = gamePlayer_1.Out.SendRoomPairUpCancel(this);
				SendToAll(pkg, gamePlayer_1);
			}
		}

		public void SendStartPickUp()
		{
			if (gamePlayer_1 != null)
			{
				GSPacketIn pkg = gamePlayer_1.Out.SendRoomPairUpStart(this);
				SendToAll(pkg, gamePlayer_1);
			}
		}

		public void SendMessage(eMessageType type, string msg)
		{
			if (gamePlayer_1 != null)
			{
				GSPacketIn pkg = gamePlayer_1.Out.SendMessage(type, msg);
				SendToAll(pkg, gamePlayer_1);
			}
		}

		public void SendRoomSetupChange(BaseRoom room)
		{
			if (gamePlayer_1 != null)
			{
				GSPacketIn pkg = gamePlayer_1.Out.SendGameRoomSetupChange(room);
				SendToAll(pkg);
			}
		}

		public bool UpdatePosUnsafe(int pos, bool isOpened, int place, int placeView)
		{
			if (pos < 0 || pos > 9)
			{
				return false;
			}
			if (int_0[pos] != place)
			{
				if (gamePlayer_0[pos] != null)
				{
					RemovePlayerUnsafe(gamePlayer_0[pos]);
				}
				int_0[pos] = place;
				SendPlaceState();
				if (place == -1)
				{
					if (pos < 8)
					{
						int_2++;
					}
				}
				else if (pos < 8)
				{
					int_2--;
				}
				return true;
			}
			return false;
		}

		public bool IsAllSameGuild()
		{
			int guildId = GuildId;
			if (guildId == 0)
			{
				return false;
			}
			List<GamePlayer> players = GetPlayers();
			if (players.Count >= 2)
			{
				foreach (GamePlayer item in players)
				{
					if (item.PlayerCharacter.ConsortiaID != guildId)
					{
						return false;
					}
				}
				return true;
			}
			return false;
		}

		public void UpdateGameStyle()
		{
			if (gamePlayer_1 != null && RoomType == eRoomType.Match)
			{
				if (IsAllSameGuild())
				{
					GameStyle = 1;
					GameType = eGameType.Guild;
				}
				else
				{
					GameStyle = 0;
					GameType = eGameType.Free;
				}
				GSPacketIn pkg = gamePlayer_1.Out.SendRoomType(gamePlayer_1, this);
				SendToAll(pkg);
			}
		}

		public bool AddPlayerUnsafe(GamePlayer player)
		{
			int num = -1;
			lock (gamePlayer_0)
			{
				for (int i = 0; i < 10; i++)
				{
					if (gamePlayer_0[i] == null && int_0[i] == -1)
					{
						gamePlayer_0[i] = player;
						int_0[i] = player.PlayerId;
						int_1++;
						num = i;
						break;
					}
				}
			}
			if (num != -1)
			{
				UpdatePosUnsafe(8, isOpened: false, 0, -100);
				UpdatePosUnsafe(9, isOpened: false, 0, -100);
				player.CurrentRoom = this;
				player.CurrentRoomIndex = num;
				if (RoomType == eRoomType.Freedom)
				{
					player.CurrentRoomTeam = num % 2 + 1;
				}
				else
				{
					player.CurrentRoomTeam = 1;
				}
				GSPacketIn pkg = player.Out.SendRoomPlayerAdd(player);
				SendToAll(pkg, player);
				GSPacketIn pkg2 = player.Out.SendBufferList(player, player.BufferList.GetAllBufferByTemplate());
				SendToAll(pkg2, player);
				List<GamePlayer> players = GetPlayers();
				foreach (GamePlayer item in players)
				{
					if (item != player)
					{
						player.Out.SendRoomPlayerAdd(item);
						player.Out.SendBufferList(item, item.BufferList.GetAllBufferByTemplate());
					}
				}
				if (gamePlayer_1 == null)
				{
					gamePlayer_1 = player;
					UpdatePlayerState(player, 2, sendToClient: true);
				}
				else
				{
					UpdatePlayerState(player, 0, sendToClient: true);
				}
				SendPlaceState();
				UpdateGameStyle();
			}
			return num != -1;
		}

		public bool RemovePlayerUnsafe(GamePlayer player)
		{
			return RemovePlayerUnsafe(player, isKick: false);
		}

		public bool RemovePlayerUnsafe(GamePlayer player, bool isKick)
		{
			int num = -1;
			lock (gamePlayer_0)
			{
				for (int i = 0; i < 10; i++)
				{
					if (gamePlayer_0[i] == player)
					{
						gamePlayer_0[i] = null;
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
				UpdatePosUnsafe(num, isOpened: false, -1, -100);
				player.CurrentRoom = null;
				player.TempBag.ClearBag();
				GSPacketIn pkg = player.Out.SendRoomPlayerRemove(player);
				SendToAll(pkg);
				if (isKick)
				{
					player.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("Game.Server.SceneGames.KickRoom"));
				}
				bool flag = false;
				if (gamePlayer_1 == player)
				{
					if (int_1 > 0)
					{
						for (int j = 0; j < 10; j++)
						{
							if (gamePlayer_0[j] != null)
							{
								SetHost(gamePlayer_0[j]);
								flag = true;
								break;
							}
						}
					}
					else
					{
						gamePlayer_1 = null;
					}
				}
				if (IsPlaying)
				{
					if (abstractGame_0 != null)
					{
						if (flag && abstractGame_0 is PVEGame)
						{
							PVEGame pVEGame = abstractGame_0 as PVEGame;
							foreach (Player value in pVEGame.Players.Values)
							{
								if (value.PlayerDetail == gamePlayer_1)
								{
									value.Ready = false;
								}
							}
						}
						abstractGame_0.RemovePlayer(player, isKick);
					}
					if (BattleServer != null)
					{
						if (abstractGame_0 != null)
						{
							BattleServer.Server.SendPlayerDisconnet(Game.Id, player.GamePlayerId, RoomId);
							if (PlayerCount == 0)
							{
								BattleServer.RemoveRoom(this);
							}
						}
						else
						{
							SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("Game.Server.SceneGames.PairUp.Failed"));
							RoomMgr.AddAction(new CancelPickupAction(BattleServer, this));
							BattleServer.RemoveRoom(this);
							IsPlaying = false;
						}
					}
				}
				else
				{
					UpdateGameStyle();
					if (flag)
					{
						if (RoomType == eRoomType.Dungeon)
						{
							HardLevel = eHardLevel.Normal;
						}
						else
						{
							HardLevel = eHardLevel.Easy;
						}
						foreach (GamePlayer player2 in GetPlayers())
						{
							player2.Out.SendGameRoomSetupChange(this);
						}
					}
				}
			}
			return num != -1;
		}

		public void RemovePlayerAtUnsafe(int pos)
		{
			if (pos >= 0 && pos <= 9 && gamePlayer_0[pos] != null)
			{
				if (gamePlayer_0[pos].KickProtect)
				{
					string translation = LanguageMgr.GetTranslation("Game.Server.SceneGames.Protect", gamePlayer_0[pos].PlayerCharacter.NickName);
					GSPacketIn gSPacketIn = new GSPacketIn(3);
					gSPacketIn.WriteInt(0);
					gSPacketIn.WriteString(translation);
					SendToHost(gSPacketIn);
				}
				else
				{
					RemovePlayerUnsafe(gamePlayer_0[pos], isKick: true);
				}
			}
		}

		public bool SwitchTeamUnsafe(GamePlayer m_player)
		{
			if (RoomType == eRoomType.Match)
			{
				return false;
			}
			int num = -1;
			lock (gamePlayer_0)
			{
				for (int i = (m_player.CurrentRoomIndex + 1) % 2; i < 8; i += 2)
				{
					if (gamePlayer_0[i] == null && int_0[i] == -1)
					{
						num = i;
						gamePlayer_0[m_player.CurrentRoomIndex] = null;
						gamePlayer_0[i] = m_player;
						int_0[m_player.CurrentRoomIndex] = -1;
						int_0[i] = m_player.PlayerId;
						byte_0[i] = byte_0[m_player.CurrentRoomIndex];
						byte_0[m_player.CurrentRoomIndex] = 0;
						break;
					}
				}
			}
			if (num != -1)
			{
				m_player.CurrentRoomIndex = num;
				m_player.CurrentRoomTeam = num % 2 + 1;
				GSPacketIn pkg = m_player.Out.SendRoomPlayerChangedTeam(m_player);
				SendToAll(pkg, m_player);
				SendPlaceState();
				return true;
			}
			return false;
		}

		public eLevelLimits GetLevelLimit(GamePlayer player)
		{
			if (player.PlayerCharacter.Grade <= 10)
			{
				return eLevelLimits.ZeroToTen;
			}
			if (player.PlayerCharacter.Grade <= 20)
			{
				return eLevelLimits.ElevenToTwenty;
			}
			return eLevelLimits.TwentyOneToThirty;
		}

		public void StartGame(AbstractGame game)
		{
			if (abstractGame_0 != null)
			{
				List<GamePlayer> players = GetPlayers();
				foreach (GamePlayer item in players)
				{
					abstractGame_0.RemovePlayer(item, IsKick: false);
				}
				method_1(abstractGame_0);
			}
			abstractGame_0 = game;
			IsPlaying = true;
			abstractGame_0.GameStopped += method_1;
		}

		private void method_1(AbstractGame abstractGame_1)
		{
			if (abstractGame_1 != null)
			{
				abstractGame_0.GameStopped -= method_1;
				abstractGame_0 = null;
				IsPlaying = false;
				UpdateGameStyle();
				ResetPlayerState();
				if (RoomType == eRoomType.Dungeon)
				{
					Pic = "";
					HardLevel = eHardLevel.Easy;
					MapId = 10000;
					currentFloor = 0;
					isOpenBoss = false;
					SendRoomSetupChange(this);
				}
				RoomMgr.WaitingRoom.SendUpdateCurrentRoom(this);
			}
		}

		public void ResetPlayerState()
		{
			for (int i = 0; i < byte_0.Length; i++)
			{
				if (byte_0[i] != 2)
				{
					byte_0[i] = 0;
				}
			}
		}

		public string GetNameByMapId()
		{
			string text = LanguageMgr.GetTranslation("BaseRoom.Msg1");
			string translation = LanguageMgr.GetTranslation("BaseRoom.Msg2");
			MapInfo mapInfo = MapMgr.FindMapInfo(MapId);
			if (mapInfo != null)
			{
				text = mapInfo.Name;
			}
			PveInfo pveInfoById = PveInfoMgr.GetPveInfoById(MapId);
			if (pveInfoById != null)
			{
				text = pveInfoById.Name + GetNameHardLv();
			}
			else
			{
				translation = LanguageMgr.GetTranslation("BaseRoom.Msg3");
			}
			return translation + text;
		}

		public string GetNameHardLv()
		{
			string translation = LanguageMgr.GetTranslation("BaseRoom.Msg4");
			switch (HardLevel)
			{
			case eHardLevel.Normal:
				translation = LanguageMgr.GetTranslation("BaseRoom.Msg5");
				break;
			case eHardLevel.Hard:
				translation = LanguageMgr.GetTranslation("BaseRoom.Msg6");
				break;
			case eHardLevel.Terror:
				translation = LanguageMgr.GetTranslation("BaseRoom.Msg7");
				break;
			case eHardLevel.Epic:
				translation = LanguageMgr.GetTranslation("BaseRoom.Msg8");
				break;
			}
			return translation;
		}

		public void ProcessData(GSPacketIn packet)
		{
			if (abstractGame_0 != null)
			{
				abstractGame_0.ProcessData(packet);
			}
		}

		public void RemoveAllPlayer()
		{
			for (int i = 0; i < 10; i++)
			{
				if (gamePlayer_0[i] != null)
				{
					RoomMgr.AddAction(new ExitRoomAction(this, gamePlayer_0[i]));
					RoomMgr.AddAction(new EnterWaitingRoomAction(gamePlayer_0[i]));
				}
			}
		}

		public override string ToString()
		{
			return $"Id:{RoomId},player:{PlayerCount},game:{Game},isPlaying:{IsPlaying}";
		}

		static BaseRoom()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
