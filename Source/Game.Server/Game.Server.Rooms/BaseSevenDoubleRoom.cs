using System.Collections.Generic;
using System.Drawing;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.Rooms
{
	public class BaseSevenDoubleRoom
	{
		public static ThreadSafeRandom random;

		public static int LIVIN;

		public static int DEAD;

		public static int FIGHTING;

		public static int MonterAddCount;

		protected int lastMonterID;

		private int[] int_0;

		private Point[] point_0;

		private Dictionary<int, GamePlayer> dictionary_0;

		private Dictionary<int, MonterInfo> dictionary_1;

		public int DefaultPosX;

		public int DefaultPosY;

		public int RoomId;

		private GamePlayer[] gamePlayer_0;

		private int[] int_1;

		private byte[] byte_0;

		public bool IsPlaying;

		private int int_2;

		private int int_3;

		public Dictionary<int, MonterInfo> Monters => dictionary_1;

		public BaseSevenDoubleRoom(int roomId)
		{
			lastMonterID = 1000;
			int_0 = new int[3] { 0, 1, 2 };
			point_0 = new Point[5]
			{
				new Point(353, 570),
				new Point(246, 760),
				new Point(593, 590),
				new Point(466, 898),
				new Point(800, 950)
			};
			dictionary_0 = new Dictionary<int, GamePlayer>();
			dictionary_1 = new Dictionary<int, MonterInfo>();
			DefaultPosX = 500;
			DefaultPosY = 500;
			int_3 = 5;
			RoomId = roomId;
			gamePlayer_0 = new GamePlayer[5];
			int_1 = new int[5];
			byte_0 = new byte[5];
			method_0();
		}

		private void method_0()
		{
			for (int i = 0; i < 5; i++)
			{
				gamePlayer_0[i] = null;
				int_1[i] = -1;
				if (i < 5)
				{
					byte_0[i] = 0;
				}
			}
			IsPlaying = false;
			int_3 = 5;
			int_2 = 0;
		}

		public void AddFistMonters()
		{
			lock (dictionary_1)
			{
				for (int i = 0; i < MonterAddCount; i++)
				{
					MonterInfo monterInfo = new MonterInfo();
					monterInfo.ID = lastMonterID;
					monterInfo.type = random.Next(int_0.Length);
					monterInfo.MonsterPos = point_0[i];
					monterInfo.MonsterNewPos = point_0[i];
					monterInfo.state = LIVIN;
					monterInfo.PlayerID = 0;
					if (!dictionary_1.ContainsKey(monterInfo.ID))
					{
						dictionary_1.Add(monterInfo.ID, monterInfo);
					}
					lastMonterID++;
				}
			}
		}

		private int method_1()
		{
			int num = 0;
			foreach (MonterInfo value in Monters.Values)
			{
				if (value.state == LIVIN)
				{
					num++;
				}
			}
			return num;
		}

		public void AddMoreMonters()
		{
			if (method_1() < dictionary_0.Count)
			{
				AddMonters();
			}
		}

		public void AddMonters()
		{
			lock (dictionary_1)
			{
				MonterInfo monterInfo = new MonterInfo();
				monterInfo.ID = lastMonterID;
				monterInfo.type = random.Next(int_0.Length);
				int num = random.Next(point_0.Length);
				monterInfo.MonsterPos = point_0[num];
				monterInfo.MonsterNewPos = point_0[num];
				monterInfo.state = LIVIN;
				monterInfo.PlayerID = 0;
				if (!dictionary_1.ContainsKey(monterInfo.ID))
				{
					dictionary_1.Add(monterInfo.ID, monterInfo);
				}
				lastMonterID++;
			}
		}

		public bool SetFightMonter(int Id, int playerId)
		{
			bool result = false;
			lock (dictionary_1)
			{
				if (dictionary_1.ContainsKey(Id))
				{
					dictionary_1[Id].state = FIGHTING;
					dictionary_1[Id].PlayerID = playerId;
					result = true;
				}
			}
			AddMonters();
			return result;
		}

		public void SetMonterDie(int playerId)
		{
			int num = -1;
			foreach (MonterInfo value in dictionary_1.Values)
			{
				if (value.PlayerID == playerId)
				{
					num = value.ID;
					break;
				}
			}
			if (num <= -1)
			{
				return;
			}
			lock (dictionary_1)
			{
				if (dictionary_1.ContainsKey(num))
				{
					dictionary_1.Remove(num);
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(145);
			gSPacketIn.WriteByte(22);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(num);
			method_2(gSPacketIn);
		}

		public void AddPlayer(GamePlayer player)
		{
			lock (dictionary_0)
			{
				if (!dictionary_0.ContainsKey(player.PlayerId))
				{
					dictionary_0.Add(player.PlayerId, player);
					player.Actives.BeginChristmasTimer();
				}
			}
			UpdateRoom();
		}

		public void UpdateRoom()
		{
			GamePlayer[] playersSafe = GetPlayersSafe();
			GSPacketIn gSPacketIn = new GSPacketIn(145);
			gSPacketIn.WriteByte(18);
			gSPacketIn.WriteInt(playersSafe.Length);
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Grade);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Hide);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Repute);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ID);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.NickName);
				gSPacketIn.WriteByte(gamePlayer.PlayerCharacter.typeVIP);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.VIPLevel);
				gSPacketIn.WriteBoolean(gamePlayer.PlayerCharacter.Sex);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Style);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Colors);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Skin);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.FightPower);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Win);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Total);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Offer);
				gSPacketIn.WriteInt(gamePlayer.X);
				gSPacketIn.WriteInt(gamePlayer.Y);
				gSPacketIn.WriteByte(gamePlayer.States);
			}
			method_2(gSPacketIn);
		}

		public void ViewOtherPlayerRoom(GamePlayer player)
		{
			GamePlayer[] playersSafe = GetPlayersSafe();
			GSPacketIn gSPacketIn = new GSPacketIn(145);
			gSPacketIn.WriteByte(18);
			gSPacketIn.WriteInt(playersSafe.Length);
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Grade);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Hide);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Repute);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ID);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.NickName);
				gSPacketIn.WriteByte(gamePlayer.PlayerCharacter.typeVIP);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.VIPLevel);
				gSPacketIn.WriteBoolean(gamePlayer.PlayerCharacter.Sex);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Style);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Colors);
				gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Skin);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.FightPower);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Win);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Total);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Offer);
				gSPacketIn.WriteInt(gamePlayer.X);
				gSPacketIn.WriteInt(gamePlayer.Y);
				gSPacketIn.WriteByte(gamePlayer.States);
			}
			player.SendTCP(gSPacketIn);
		}

		public bool RemovePlayer(GamePlayer player)
		{
			bool flag = false;
			lock (dictionary_0)
			{
				player.Actives.StopChristmasTimer();
				flag = dictionary_0.Remove(player.PlayerId);
			}
			if (flag)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(145);
				gSPacketIn.WriteByte(19);
				gSPacketIn.WriteInt(player.PlayerId);
				method_2(gSPacketIn);
				player.Out.SendSceneRemovePlayer(player);
			}
			return flag;
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

		public void SendToALLPlayers(GSPacketIn packet)
		{
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer.SendTCP(packet);
			}
		}

		public void method_2(GSPacketIn packet)
		{
			method_3(packet, null);
		}

		public void method_3(GSPacketIn packet, GamePlayer except)
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

		static BaseSevenDoubleRoom()
		{
			random = new ThreadSafeRandom();
			LIVIN = 0;
			DEAD = 2;
			FIGHTING = 1;
			MonterAddCount = 15;
		}
	}
}
