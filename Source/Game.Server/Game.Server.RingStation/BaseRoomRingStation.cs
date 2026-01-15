using System.Collections.Generic;
using System.Timers;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.RingStation.Battle;

namespace Game.Server.RingStation
{
	public class BaseRoomRingStation
	{
		private List<RingStationGamePlayer> list_0;

		public RingStationBattleServer BattleServer;

		public int RoomId;

		public int PickUpNpcId;

		public bool IsAutoBot;

		public bool IsFreedom;

		private AbstractGame abstractGame_0;

		private Timer timer_0;

		public AbstractGame Game => abstractGame_0;

		public int RoomType { get; set; }

		public int GameType { get; set; }

		public int GuildId { get; set; }

		public bool IsPlaying { get; set; }

		public BaseRoomRingStation(int roomId)
		{
			timer_0 = new Timer();
			RoomId = roomId;
			list_0 = new List<RingStationGamePlayer>();
		}

		public bool AddPlayer(RingStationGamePlayer player)
		{
			lock (list_0)
			{
				player.CurRoom = this;
				list_0.Add(player);
			}
			return true;
		}

		internal List<RingStationGamePlayer> method_0()
		{
			return list_0;
		}

		public void SendToAll(GSPacketIn pkg)
		{
			SendToAll(pkg, null);
		}

		public void SendToAll(GSPacketIn pkg, RingStationGamePlayer except)
		{
			lock (list_0)
			{
				foreach (RingStationGamePlayer item in list_0)
				{
					if (item != null && item != except)
					{
						item.method_0(pkg);
					}
				}
			}
		}

		internal void method_1(GSPacketIn gspacketIn_0)
		{
			if (abstractGame_0 != null)
			{
				BattleServer.Server.SendToGame(abstractGame_0.Id, gspacketIn_0);
			}
		}

		public void RemovePlayer(RingStationGamePlayer player)
		{
			if (BattleServer != null)
			{
				if (abstractGame_0 != null)
				{
					BattleServer.Server.SendPlayerDisconnet(Game.Id, player.GamePlayerId, RoomId);
					BattleServer.Server.SendRemoveRoom(this);
				}
				IsPlaying = false;
			}
			if (Game != null)
			{
				Game.Stop();
			}
			RingStationMgr.RemovePlayer(player.ID);
		}

		public void StartGame(AbstractGame game)
		{
			abstractGame_0 = game;
		}
	}
}
