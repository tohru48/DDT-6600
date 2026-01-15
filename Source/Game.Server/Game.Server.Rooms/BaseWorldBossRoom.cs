using System;
using System.Collections.Generic;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.Rooms
{
	public class BaseWorldBossRoom
	{
		private Dictionary<int, GamePlayer> dictionary_0;

		private long long_0;

		private long long_1;

		private string string_0;

		private string string_1;

		private DateTime dateTime_0;

		private DateTime dateTime_1;

		private int int_0;

		private bool gyBpxBhOv9;

		private bool bool_0;

		private bool bool_1;

		private int int_1;

		private bool bool_2;

		public int playerDefaultPosX;

		public int playerDefaultPosY;

		public int ticketID;

		public int need_ticket_count;

		public int timeCD;

		public int reviveMoney;

		public int reFightMoney;

		public int addInjureBuffMoney;

		public int addInjureValue;

		public long MaxBlood => long_0;

		public long Blood
		{
			get
			{
				return long_1;
			}
			set
			{
				long_1 = value;
			}
		}

		public string name => string_0;

		public string bossResourceId => string_1;

		public DateTime begin_time => dateTime_0;

		public DateTime end_time => dateTime_1;

		public int Int32_0 => int_0;

		public bool fightOver => gyBpxBhOv9;

		public bool roomClose => bool_0;

		public bool worldOpen => bool_1;

		public int fight_time => int_1;

		public bool IsDie
		{
			get
			{
				return bool_2;
			}
			set
			{
				bool_2 = value;
			}
		}

		public BaseWorldBossRoom()
		{
			playerDefaultPosX = 265;
			playerDefaultPosY = 1030;
			ticketID = 11573;
			timeCD = 15;
			reviveMoney = 10000;
			reFightMoney = 12000;
			addInjureBuffMoney = 30000;
			addInjureValue = 200;
			dictionary_0 = new Dictionary<int, GamePlayer>();
			bool_2 = false;
			bool_1 = false;
			gyBpxBhOv9 = true;
			bool_0 = true;
			string_0 = "boss";
			string_1 = "0";
			int_0 = 0;
		}

		public void UpdateRank(int damage, int honor, string nickName)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(81);
			gSPacketIn.WriteInt(damage);
			gSPacketIn.WriteInt(honor);
			gSPacketIn.WriteString(nickName);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public void ShowRank()
		{
			GSPacketIn packet = new GSPacketIn(86);
			GameServer.Instance.LoginServer.SendPacket(packet);
		}

		public void UpdateWorldBoss(GSPacketIn pkg)
		{
			long num = pkg.ReadLong();
			long num2 = pkg.ReadLong();
			string text = pkg.ReadString();
			string text2 = pkg.ReadString();
			int num3 = pkg.ReadInt();
			gyBpxBhOv9 = pkg.ReadBoolean();
			bool_0 = pkg.ReadBoolean();
			dateTime_0 = pkg.ReadDateTime();
			dateTime_1 = pkg.ReadDateTime();
			int_1 = pkg.ReadInt();
			bool flag = pkg.ReadBoolean();
			long_0 = num;
			long_1 = num2;
			string_0 = text;
			string_1 = text2;
			int_0 = num3;
			bool_1 = flag;
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer.Out.SendOpenWorldBoss(gamePlayer.X, gamePlayer.Y);
			}
		}

		public void WorldBossClose()
		{
			bool_1 = false;
			GamePlayer[] playersSafe = GetPlayersSafe();
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer player in array)
			{
				RemovePlayer(player);
			}
		}

		public void FightOver()
		{
			GSPacketIn packet = new GSPacketIn(82);
			GameServer.Instance.LoginServer.SendPacket(packet);
		}

		public void ReduceBlood(int value)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(84);
			gSPacketIn.WriteInt(value);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public void SendFightOver()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(102);
			gSPacketIn.WriteByte(8);
			gSPacketIn.WriteBoolean(val: true);
			SendToALLPlayers(gSPacketIn);
		}

		public void SendRoomClose()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(102);
			gSPacketIn.WriteByte(9);
			SendToALLPlayers(gSPacketIn);
		}

		public void UpdateWorldBossRankCrosszone(GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(102);
			gSPacketIn.WriteByte(10);
			bool flag = packet.ReadBoolean();
			int num = packet.ReadInt();
			gSPacketIn.WriteBoolean(flag);
			gSPacketIn.WriteInt(num);
			for (int i = 0; i < num; i++)
			{
				int val = packet.ReadInt();
				string str = packet.ReadString();
				int val2 = packet.ReadInt();
				gSPacketIn.WriteInt(val);
				gSPacketIn.WriteString(str);
				gSPacketIn.WriteInt(val2);
			}
			if (flag)
			{
				SendToALLPlayers(gSPacketIn);
			}
			else
			{
				method_0(gSPacketIn);
			}
		}

		public void SendPrivateInfo(string name)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(85);
			gSPacketIn.WriteString(name);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public void SendPrivateInfo(string name, int damage, int honor)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(102);
			gSPacketIn.WriteByte(22);
			gSPacketIn.WriteInt(damage);
			gSPacketIn.WriteInt(honor);
			GamePlayer[] playersSafe = GetPlayersSafe();
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.NickName == name)
				{
					gamePlayer.Out.SendTCP(gSPacketIn);
					break;
				}
			}
		}

		public void SendUpdateBlood(GSPacketIn packet)
		{
			long val = packet.ReadLong();
			long_1 = packet.ReadLong();
			GSPacketIn gSPacketIn = new GSPacketIn(102);
			gSPacketIn.WriteByte(5);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteLong(val);
			gSPacketIn.WriteLong(long_1);
			method_0(gSPacketIn);
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
					ShowRank();
					SendPrivateInfo(player.PlayerCharacter.NickName);
				}
			}
			if (flag)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(102);
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(player.PlayerCharacter.Grade);
				gSPacketIn.WriteInt(player.PlayerCharacter.Hide);
				gSPacketIn.WriteInt(player.PlayerCharacter.Repute);
				gSPacketIn.WriteInt(player.PlayerCharacter.ID);
				gSPacketIn.WriteString(player.PlayerCharacter.NickName);
				gSPacketIn.WriteByte(player.PlayerCharacter.typeVIP);
				gSPacketIn.WriteInt(player.PlayerCharacter.VIPLevel);
				gSPacketIn.WriteBoolean(player.PlayerCharacter.Sex);
				gSPacketIn.WriteString(player.PlayerCharacter.Style);
				gSPacketIn.WriteString(player.PlayerCharacter.Colors);
				gSPacketIn.WriteString(player.PlayerCharacter.Skin);
				gSPacketIn.WriteInt(player.X);
				gSPacketIn.WriteInt(player.Y);
				gSPacketIn.WriteInt(player.PlayerCharacter.FightPower);
				gSPacketIn.WriteInt(player.PlayerCharacter.Win);
				gSPacketIn.WriteInt(player.PlayerCharacter.Total);
				gSPacketIn.WriteInt(player.PlayerCharacter.Offer);
				gSPacketIn.WriteByte(player.States);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(player.PlayerCharacter.MountsType);
				gSPacketIn.WriteInt(player.PlayerCharacter.PetsID);
				method_0(gSPacketIn);
			}
			return flag;
		}

		public void ViewOtherPlayerRoom(GamePlayer player)
		{
			GamePlayer[] playersSafe = GetPlayersSafe();
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer != player)
				{
					GSPacketIn gSPacketIn = new GSPacketIn(102);
					gSPacketIn.WriteByte(3);
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
					gSPacketIn.WriteInt(gamePlayer.X);
					gSPacketIn.WriteInt(gamePlayer.Y);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.FightPower);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Win);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Total);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Offer);
					gSPacketIn.WriteByte(gamePlayer.States);
					gSPacketIn.WriteInt(0);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.MountsType);
					player.SendTCP(gSPacketIn);
				}
			}
		}

		public bool RemovePlayer(GamePlayer player)
		{
			bool flag = false;
			lock (dictionary_0)
			{
				flag = dictionary_0.Remove(player.PlayerId);
				GSPacketIn gSPacketIn = new GSPacketIn(102);
				gSPacketIn.WriteByte(4);
				gSPacketIn.WriteInt(player.PlayerId);
				method_0(gSPacketIn);
			}
			if (flag)
			{
				GSPacketIn packet = player.Out.SendSceneRemovePlayer(player);
				method_1(packet, player);
			}
			return true;
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
	}
}
