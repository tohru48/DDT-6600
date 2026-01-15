using System.Collections.Generic;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using log4net;

namespace Game.Server.NewHall
{
	public class NewHallRoom
	{
		private readonly ILog ilog_0;

		private Dictionary<int, GamePlayer> dictionary_0;

		private object object_0;

		public NewHallRoom()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			object_0 = new object();
			dictionary_0 = new Dictionary<int, GamePlayer>();
		}

		public void HidePlayerInfo(GamePlayer p)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(262);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteBoolean(p.HideAllFriend);
			p.SendTCP(gSPacketIn);
			SendPlayerInfo(p);
		}

		public void SendPlayerInfo(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(262);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteInt(player.PosX);
			gSPacketIn.WriteInt(player.PosY);
			GamePlayer[] playersSafe = GetPlayersSafe(player);
			gSPacketIn.WriteInt(playersSafe.Length);
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ID);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.NickName);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.VIPLevel);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.typeVIP);
				gSPacketIn.WriteBoolean(gamePlayer.PlayerCharacter.Sex);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Style);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Colors);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.MountsType);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.PetsID);
				gSPacketIn.WriteInt(gamePlayer.PosX);
				gSPacketIn.WriteInt(gamePlayer.PosY);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ConsortiaID);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.badgeID);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.ConsortiaName);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Honor);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.honorId);
			}
			player.SendTCP(gSPacketIn);
		}

		public void SendOtherFriendPlayerInfo(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(262);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(player.PlayerCharacter.ID);
			gSPacketIn.WriteString(player.PlayerCharacter.NickName);
			gSPacketIn.WriteInt(player.PlayerCharacter.VIPLevel);
			gSPacketIn.WriteInt(player.PlayerCharacter.typeVIP);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.Sex);
			gSPacketIn.WriteString(player.PlayerCharacter.Style);
			gSPacketIn.WriteString(player.PlayerCharacter.Colors);
			gSPacketIn.WriteInt(player.PlayerCharacter.MountsType);
			gSPacketIn.WriteInt(player.PlayerCharacter.PetsID);
			gSPacketIn.WriteInt(player.PosX);
			gSPacketIn.WriteInt(player.PosY);
			gSPacketIn.WriteInt(player.PlayerCharacter.ConsortiaID);
			gSPacketIn.WriteInt(player.PlayerCharacter.badgeID);
			gSPacketIn.WriteString(player.PlayerCharacter.ConsortiaName);
			gSPacketIn.WriteString(player.PlayerCharacter.Honor);
			gSPacketIn.WriteInt(player.PlayerCharacter.honorId);
			method_1(gSPacketIn, player);
		}

		public void SendAddPlayer(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(262);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(player.PlayerCharacter.ID);
			gSPacketIn.WriteString(player.PlayerCharacter.NickName);
			gSPacketIn.WriteInt(player.PlayerCharacter.VIPLevel);
			gSPacketIn.WriteInt(player.PlayerCharacter.typeVIP);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.Sex);
			gSPacketIn.WriteString(player.PlayerCharacter.Style);
			gSPacketIn.WriteString(player.PlayerCharacter.Colors);
			gSPacketIn.WriteInt(player.PlayerCharacter.MountsType);
			gSPacketIn.WriteInt(player.PlayerCharacter.PetsID);
			gSPacketIn.WriteInt(player.PosX);
			gSPacketIn.WriteInt(player.PosY);
			gSPacketIn.WriteInt(player.PlayerCharacter.ConsortiaID);
			gSPacketIn.WriteInt(player.PlayerCharacter.badgeID);
			gSPacketIn.WriteString(player.PlayerCharacter.ConsortiaName);
			gSPacketIn.WriteString(player.PlayerCharacter.Honor);
			gSPacketIn.WriteInt(player.PlayerCharacter.honorId);
			method_1(gSPacketIn, player);
		}

		public void PlayerMove(int ID, int X, int Y)
		{
			GamePlayer playerByID = GetPlayerByID(ID);
			playerByID.PosX = X;
			playerByID.PosY = Y;
			GSPacketIn gSPacketIn = new GSPacketIn(262);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(playerByID.PlayerId);
			gSPacketIn.WriteInt(playerByID.PosX);
			gSPacketIn.WriteInt(playerByID.PosY);
			method_1(gSPacketIn, playerByID);
		}

		public bool AddPlayerInfo(int playerId)
		{
			if (dictionary_0.ContainsKey(playerId))
			{
				SendAddPlayer(dictionary_0[playerId]);
			}
			return true;
		}

		public bool PlayerInfo(GamePlayer player)
		{
			if (player.CurrentRoom != null)
			{
				player.CurrentRoom.RemovePlayerUnsafe(player);
			}
			lock (object_0)
			{
				if (!dictionary_0.ContainsKey(player.PlayerCharacter.ID))
				{
					dictionary_0.Add(player.PlayerCharacter.ID, player);
				}
			}
			HidePlayerInfo(player);
			if (!player.HideAllFriend)
			{
				SendOtherFriendPlayerInfo(player);
			}
			return true;
		}

		public bool UpdatePets(int playerId, int petsId)
		{
			GamePlayer gamePlayer = null;
			lock (object_0)
			{
				if (dictionary_0.ContainsKey(playerId))
				{
					dictionary_0[playerId].PlayerCharacter.PetsID = petsId;
					gamePlayer = dictionary_0[playerId];
				}
			}
			if (gamePlayer != null)
			{
				HidePlayerInfo(gamePlayer);
				if (!gamePlayer.HideAllFriend)
				{
					SendOtherFriendPlayerInfo(gamePlayer);
				}
			}
			return true;
		}

		public bool RemovePlayer(int Id)
		{
			lock (object_0)
			{
				if (dictionary_0.Remove(Id))
				{
					GSPacketIn gSPacketIn = new GSPacketIn(262);
					gSPacketIn.WriteByte(2);
					gSPacketIn.WriteInt(Id);
					method_0(gSPacketIn);
					return true;
				}
			}
			return false;
		}

		public GamePlayer GetPlayerByID(int ID)
		{
			lock (object_0)
			{
				if (dictionary_0.ContainsKey(ID))
				{
					return dictionary_0[ID];
				}
			}
			return null;
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

		public GamePlayer[] GetPlayersSafe(GamePlayer except)
		{
			List<GamePlayer> list = new List<GamePlayer>();
			if (!except.HideAllFriend)
			{
				GamePlayer[] playersSafe = GetPlayersSafe();
				GamePlayer[] array = playersSafe;
				foreach (GamePlayer gamePlayer in array)
				{
					if (gamePlayer != null && gamePlayer != except)
					{
						list.Add(gamePlayer);
					}
				}
			}
			return list.ToArray();
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
				if (gamePlayer != null && gamePlayer != except && !gamePlayer.HideAllFriend)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}
	}
}
