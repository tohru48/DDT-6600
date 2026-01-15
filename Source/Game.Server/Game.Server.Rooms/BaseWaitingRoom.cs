using System.Collections.Generic;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Rooms
{
	public class BaseWaitingRoom
	{
		private Dictionary<int, GamePlayer> dictionary_0;

		public BaseWaitingRoom()
		{
			dictionary_0 = new Dictionary<int, GamePlayer>();
		}

		public bool AddPlayer(GamePlayer player)
		{
			bool flag = false;
			lock (dictionary_0)
			{
				if (!dictionary_0.ContainsKey(player.PlayerId))
				{
					dictionary_0.Add(player.PlayerId, player);
					flag = true;
				}
			}
			if (flag)
			{
				GSPacketIn packet = player.Out.SendSceneAddPlayer(player);
				method_1(packet, player);
			}
			return flag;
		}

		public bool RemovePlayer(GamePlayer player)
		{
			bool flag = false;
			lock (dictionary_0)
			{
				flag = dictionary_0.Remove(player.PlayerId);
			}
			if (flag)
			{
				GSPacketIn packet = player.Out.SendSceneRemovePlayer(player);
				method_1(packet, player);
			}
			return true;
		}

		public void SendSceneUpdate(GamePlayer player)
		{
			GSPacketIn packet = player.Out.SendSceneAddPlayer(player);
			method_1(packet, player);
			GamePlayer[] playersSafe = GetPlayersSafe();
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer != player)
				{
					player.Out.SendSceneAddPlayer(gamePlayer);
				}
			}
		}

		public void SendUpdateCurrentRoom(BaseRoom room)
		{
			List<BaseRoom> allRooms = RoomMgr.GetAllRooms(room);
			GSPacketIn gSPacketIn = null;
			foreach (GamePlayer player in room.GetPlayers())
			{
				if (gSPacketIn == null)
				{
					gSPacketIn = player.Out.SendUpdateRoomList(allRooms);
				}
				else
				{
					player.Out.SendTCP(gSPacketIn);
				}
			}
		}

		public void method_0(GSPacketIn packet)
		{
			method_1(packet, null);
		}

		public void method_1(GSPacketIn packet, GamePlayer except)
		{
			GamePlayer[] array = null;
			lock (dictionary_0)
			{
				array = new GamePlayer[dictionary_0.Count];
				dictionary_0.Values.CopyTo(array, 0);
			}
			if (array == null)
			{
				return;
			}
			GamePlayer[] array2 = array;
			foreach (GamePlayer gamePlayer in array2)
			{
				if (gamePlayer != null && gamePlayer != except)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public GamePlayer[] GetPlayersSafe()
		{
			GamePlayer[] array = null;
			lock (dictionary_0)
			{
				array = new GamePlayer[dictionary_0.Count];
				dictionary_0.Values.CopyTo(array, 0);
			}
			if (array != null)
			{
				return array;
			}
			return new GamePlayer[0];
		}
	}
}
