using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.SceneMarryRooms
{
	public class MarryRoom
	{
		private static readonly ILog ilog_0;

		private static object object_0;

		private List<GamePlayer> list_0;

		private IMarryProcessor imarryProcessor_0;

		private int int_0;

		public MarryRoomInfo Info;

		private eRoomState eRoomState_0;

		private Timer timer_0;

		private Timer timer_1;

		private List<int> list_1;

		private List<int> list_2;

		public eRoomState RoomState
		{
			get
			{
				return eRoomState_0;
			}
			set
			{
				if (eRoomState_0 != value)
				{
					eRoomState_0 = value;
					SendMarryRoomInfoUpdateToScenePlayers(this);
				}
			}
		}

		public int Count => int_0;

		public MarryRoom(MarryRoomInfo info, IMarryProcessor processor)
		{
			Info = info;
			imarryProcessor_0 = processor;
			list_0 = new List<GamePlayer>();
			int_0 = 0;
			eRoomState_0 = eRoomState.FREE;
			list_1 = new List<int>();
			list_2 = new List<int>();
		}

		public bool AddPlayer(GamePlayer player)
		{
			lock (object_0)
			{
				if (player.CurrentRoom != null || player.IsInMarryRoom)
				{
					return false;
				}
				if (list_0.Count > Info.MaxCount)
				{
					player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("MarryRoom.Msg1"));
					return false;
				}
				int_0++;
				list_0.Add(player);
				player.CurrentMarryRoom = this;
				player.MarryMap = 1;
				if (player.CurrentRoom != null)
				{
					player.CurrentRoom.RemovePlayerUnsafe(player);
				}
			}
			return true;
		}

		public void RemovePlayer(GamePlayer player)
		{
			lock (object_0)
			{
				if (RoomState == eRoomState.FREE)
				{
					int_0--;
					list_0.Remove(player);
					GSPacketIn packet = player.Out.SendPlayerLeaveMarryRoom(player);
					player.CurrentMarryRoom.SendToPlayerExceptSelfForScene(packet, player);
					player.CurrentMarryRoom = null;
					player.MarryMap = 0;
				}
				else if (RoomState == eRoomState.Hymeneal)
				{
					list_2.Add(player.PlayerCharacter.ID);
					int_0--;
					list_0.Remove(player);
					player.CurrentMarryRoom = null;
				}
				SendMarryRoomInfoUpdateToScenePlayers(this);
			}
		}

		public void BeginTimer(int interval)
		{
			if (timer_0 == null)
			{
				timer_0 = new Timer(OnTick, null, interval, interval);
			}
			else
			{
				timer_0.Change(interval, interval);
			}
		}

		protected void OnTick(object obj)
		{
			imarryProcessor_0.OnTick(this);
		}

		public void StopTimer()
		{
			if (timer_0 != null)
			{
				timer_0.Dispose();
				timer_0 = null;
			}
		}

		public void BeginTimerForHymeneal(int interval)
		{
			if (timer_1 == null)
			{
				timer_1 = new Timer(OnTickForHymeneal, null, interval, interval);
			}
			else
			{
				timer_1.Change(interval, interval);
			}
		}

		protected void OnTickForHymeneal(object obj)
		{
			try
			{
				eRoomState_0 = eRoomState.FREE;
				GSPacketIn gSPacketIn = new GSPacketIn(249);
				gSPacketIn.WriteByte(9);
				SendToAll(gSPacketIn);
				StopTimerForHymeneal();
				SendUserRemoveLate();
				SendMarryRoomInfoUpdateToScenePlayers(this);
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("OnTickForHymeneal", exception);
				}
			}
		}

		public void StopTimerForHymeneal()
		{
			if (timer_1 != null)
			{
				timer_1.Dispose();
				timer_1 = null;
			}
		}

		public GamePlayer[] GetAllPlayers()
		{
			lock (object_0)
			{
				return list_0.ToArray();
			}
		}

		public void SendToRoomPlayer(GSPacketIn packet)
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			if (allPlayers != null)
			{
				GamePlayer[] array = allPlayers;
				foreach (GamePlayer gamePlayer in array)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void SendToAll(GSPacketIn packet)
		{
			SendToAll(packet, null, isChat: false);
		}

		public void SendToAll(GSPacketIn packet, GamePlayer self, bool isChat)
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			if (allPlayers == null)
			{
				return;
			}
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (!isChat || !gamePlayer.IsBlackFriend(self.PlayerCharacter.ID))
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void SendToAllForScene(GSPacketIn packet, int sceneID)
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			if (allPlayers == null)
			{
				return;
			}
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.MarryMap == sceneID)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void SendToPlayerExceptSelf(GSPacketIn packet, GamePlayer self)
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			if (allPlayers == null)
			{
				return;
			}
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer != self)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void SendToPlayerExceptSelfForScene(GSPacketIn packet, GamePlayer self)
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			if (allPlayers == null)
			{
				return;
			}
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer != self && gamePlayer.MarryMap == self.MarryMap)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void SendToScenePlayer(GSPacketIn packet)
		{
			WorldMgr.MarryScene.method_0(packet);
		}

		public void ProcessData(GamePlayer player, GSPacketIn data)
		{
			lock (object_0)
			{
				imarryProcessor_0.OnGameData(this, player, data);
			}
		}

		public void ReturnPacket(GamePlayer player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = packet.Clone();
			gSPacketIn.ClientID = player.PlayerCharacter.ID;
			SendToPlayerExceptSelf(gSPacketIn, player);
		}

		public void ReturnPacketForScene(GamePlayer player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = packet.Clone();
			gSPacketIn.ClientID = player.PlayerCharacter.ID;
			SendToPlayerExceptSelfForScene(gSPacketIn, player);
		}

		public bool KickPlayerByUserID(GamePlayer player, int userID)
		{
			GamePlayer playerByUserID = GetPlayerByUserID(userID);
			if (playerByUserID != null && playerByUserID.PlayerCharacter.ID != player.CurrentMarryRoom.Info.GroomID && playerByUserID.PlayerCharacter.ID != player.CurrentMarryRoom.Info.BrideID)
			{
				RemovePlayer(playerByUserID);
				playerByUserID.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("Game.Server.SceneGames.KickRoom"));
				GSPacketIn packet = player.Out.SendMessage(eMessageType.const_3, playerByUserID.PlayerCharacter.NickName + "  " + LanguageMgr.GetTranslation("Game.Server.SceneGames.KickRoom2"));
				player.CurrentMarryRoom.SendToPlayerExceptSelf(packet, player);
				return true;
			}
			return false;
		}

		public void KickAllPlayer()
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				RemovePlayer(gamePlayer);
				gamePlayer.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("MarryRoom.TimeOver"));
			}
		}

		public GamePlayer GetPlayerByUserID(int userID)
		{
			lock (object_0)
			{
				foreach (GamePlayer item in list_0)
				{
					if (item.PlayerCharacter.ID == userID)
					{
						return item;
					}
				}
			}
			return null;
		}

		public void RoomContinuation(int time)
		{
			TimeSpan timeSpan = DateTime.Now - Info.BeginTime;
			int num = Info.AvailTime * 60 - timeSpan.Minutes + time * 60;
			Info.AvailTime += time;
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				playerBussiness.UpdateMarryRoomInfo(Info);
			}
			BeginTimer(60000 * num);
		}

		public void SetUserForbid(int userID)
		{
			lock (object_0)
			{
				list_1.Add(userID);
			}
		}

		public bool CheckUserForbid(int userID)
		{
			lock (object_0)
			{
				return list_1.Contains(userID);
			}
		}

		public void SendUserRemoveLate()
		{
			lock (object_0)
			{
				foreach (int item in list_2)
				{
					GSPacketIn packet = new GSPacketIn(244, item);
					SendToAllForScene(packet, 1);
				}
				list_2.Clear();
			}
		}

		public GSPacketIn SendMarryRoomInfoUpdateToScenePlayers(MarryRoom room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(255);
			bool flag = room != null;
			gSPacketIn.WriteBoolean(flag);
			if (flag)
			{
				gSPacketIn.WriteInt(room.Info.ID);
				gSPacketIn.WriteBoolean(room.Info.IsHymeneal);
				gSPacketIn.WriteString(room.Info.Name);
				gSPacketIn.WriteBoolean(!(room.Info.Pwd == ""));
				gSPacketIn.WriteInt(room.Info.MapIndex);
				gSPacketIn.WriteInt(room.Info.AvailTime);
				gSPacketIn.WriteInt(room.Count);
				gSPacketIn.WriteInt(room.Info.PlayerID);
				gSPacketIn.WriteString(room.Info.PlayerName);
				gSPacketIn.WriteInt(room.Info.GroomID);
				gSPacketIn.WriteString(room.Info.GroomName);
				gSPacketIn.WriteInt(room.Info.BrideID);
				gSPacketIn.WriteString(room.Info.BrideName);
				gSPacketIn.WriteDateTime(room.Info.BeginTime);
				gSPacketIn.WriteByte((byte)room.RoomState);
				gSPacketIn.WriteString(room.Info.RoomIntroduction);
			}
			SendToScenePlayer(gSPacketIn);
			return gSPacketIn;
		}

		static MarryRoom()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			object_0 = new object();
		}
	}
}
