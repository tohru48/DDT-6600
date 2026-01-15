using System.Collections.Generic;
using System.Threading;
using Game.Base;
using Game.Base.Packets;

namespace Game.Server.RingStation.Battle
{
	public class RingStationBattleServer
	{
		private int int_0;

		private RingStationFightConnector ringStationFightConnector_0;

		private Dictionary<int, BaseRoomRingStation> dictionary_0;

		private string string_0;

		private int int_1;

		public RingStationFightConnector Server => ringStationFightConnector_0;

		public bool IsActive => ringStationFightConnector_0.IsConnected;

		public string Ip => string_0;

		public int Port => int_1;

		public RingStationBattleServer(int serverId, string ip, int port, string loginKey)
		{
			int_0 = serverId;
			string_0 = ip;
			int_1 = port;
			ringStationFightConnector_0 = new RingStationFightConnector(this, ip, port, loginKey);
			dictionary_0 = new Dictionary<int, BaseRoomRingStation>();
			ringStationFightConnector_0.Disconnected += method_1;
			ringStationFightConnector_0.Connected += method_0;
		}

		public bool Start()
		{
			return ringStationFightConnector_0.Connect();
		}

		private void method_0(BaseClient baseClient_0)
		{
		}

		private void method_1(BaseClient baseClient_0)
		{
		}

		public bool AddRoom(BaseRoomRingStation room)
		{
			bool flag = false;
			BaseRoomRingStation baseRoomRingStation = null;
			bool lockTaken = false;
			Dictionary<int, BaseRoomRingStation> obj = default(Dictionary<int, BaseRoomRingStation>);
			try
			{
				Monitor.Enter(obj = dictionary_0, ref lockTaken);
				if (dictionary_0.ContainsKey(room.RoomId))
				{
					baseRoomRingStation = dictionary_0[room.RoomId];
					dictionary_0.Remove(room.RoomId);
				}
			}
			finally
			{
				if (lockTaken)
				{
					Monitor.Exit(obj);
				}
			}
			if (baseRoomRingStation != null && baseRoomRingStation.Game != null)
			{
				baseRoomRingStation.Game.Stop();
			}
			bool lockTaken2 = false;
			try
			{
				Monitor.Enter(obj = dictionary_0, ref lockTaken2);
				if (!dictionary_0.ContainsKey(room.RoomId))
				{
					dictionary_0.Add(room.RoomId, room);
					flag = true;
				}
			}
			finally
			{
				if (lockTaken2)
				{
					Monitor.Exit(obj);
				}
			}
			if (flag)
			{
				ringStationFightConnector_0.SendAddRoom(room);
			}
			room.BattleServer = this;
			room.IsPlaying = true;
			return flag;
		}

		public bool RemoveRoom(BaseRoomRingStation room)
		{
			bool result = false;
			lock (dictionary_0)
			{
				if (result = dictionary_0.ContainsKey(room.RoomId))
				{
					ringStationFightConnector_0.SendRemoveRoom(room);
				}
			}
			return result;
		}

		public void RemoveRoomImp(int roomId)
		{
			lock (dictionary_0)
			{
				if (dictionary_0.ContainsKey(roomId))
				{
					BaseRoomRingStation baseRoomRingStation = dictionary_0[roomId];
					dictionary_0.Remove(roomId);
				}
			}
		}

		public void StartGame(int roomId, ProxyRingStationGame game)
		{
			method_2(roomId)?.StartGame(game);
		}

		public void StopGame(int roomId, int gameId)
		{
			BaseRoomRingStation baseRoomRingStation = method_2(roomId);
			if (baseRoomRingStation != null)
			{
				lock (dictionary_0)
				{
					dictionary_0.Remove(roomId);
				}
			}
		}

		public void UpdateRoomId(int roomId, int fightRoomId)
		{
		}

		public void SendToRoom(int roomId, GSPacketIn pkg, int exceptId, int exceptGameId)
		{
			BaseRoomRingStation baseRoomRingStation = method_2(roomId);
			if (baseRoomRingStation == null)
			{
				return;
			}
			if (exceptId != 0)
			{
				RingStationGamePlayer playerById = RingStationMgr.GetPlayerById(exceptId);
				if (playerById != null)
				{
					if (playerById.GamePlayerId == exceptGameId)
					{
						baseRoomRingStation.SendToAll(pkg, playerById);
					}
					else
					{
						baseRoomRingStation.SendToAll(pkg);
					}
				}
			}
			else
			{
				baseRoomRingStation.SendToAll(pkg);
			}
		}

		private BaseRoomRingStation method_2(int int_2)
		{
			BaseRoomRingStation result = null;
			lock (dictionary_0)
			{
				if (dictionary_0.ContainsKey(int_2))
				{
					result = dictionary_0[int_2];
				}
			}
			return result;
		}

		public void SendToUser(int playerid, GSPacketIn pkg)
		{
		}

		public void UpdatePlayerGameId(int playerid, int gamePlayerId)
		{
			RingStationGamePlayer playerById = RingStationMgr.GetPlayerById(playerid);
			if (playerById != null)
			{
				playerById.GamePlayerId = gamePlayerId;
			}
		}

		public override string ToString()
		{
			return $"ServerID:{int_0},Ip:{ringStationFightConnector_0.RemoteEP.Address},Port:{ringStationFightConnector_0.RemoteEP.Port},IsConnected:{ringStationFightConnector_0.IsConnected},RoomCount:";
		}
	}
}
