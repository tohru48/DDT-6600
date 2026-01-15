using System.Collections.Generic;
using System.Drawing;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Rooms
{
	public class BaseCampBattleRoom
	{
		private Dictionary<int, GamePlayer> dictionary_0;

		public static ThreadSafeRandom random;

		private Point[] point_0;

		public BaseCampBattleRoom()
		{
			point_0 = new Point[6]
			{
				new Point(353, 570),
				new Point(246, 760),
				new Point(593, 590),
				new Point(466, 898),
				new Point(800, 950),
				new Point(946, 748)
			};
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
				SendCampInitSecen(player);
				SendUpdateRoom(player);
				SendCampSocerRank();
			}
			return flag;
		}

		public void SendPerScoreRank(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(146);
			gSPacketIn.WriteByte(21);
			gSPacketIn.WriteInt(1);
			for (int i = 0; i < 1; i++)
			{
				gSPacketIn.WriteInt(player.ZoneId);
				gSPacketIn.WriteInt(player.PlayerId);
				gSPacketIn.WriteString(player.ZoneName);
				gSPacketIn.WriteString(player.PlayerCharacter.NickName);
				gSPacketIn.WriteInt(33);
			}
			player.SendTCP(gSPacketIn);
		}

		public void SendCampSocerRank()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(146);
			gSPacketIn.WriteByte(20);
			gSPacketIn.WriteInt(4);
			for (int i = 1; i < 5; i++)
			{
				gSPacketIn.WriteInt(i);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(15);
			}
			method_0(gSPacketIn);
		}

		public void SendCampInitSecen(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(146);
			gSPacketIn.WriteByte(6);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(18);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteInt(dictionary_0.Count);
			foreach (GamePlayer value in dictionary_0.Values)
			{
				gSPacketIn.WriteInt(value.PlayerCharacter.ID);
				gSPacketIn.WriteInt(value.ZoneId);
				gSPacketIn.WriteBoolean(value.PlayerCharacter.Sex);
				gSPacketIn.WriteString(value.PlayerCharacter.NickName);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(184);
				gSPacketIn.WriteInt(281);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteBoolean(value.PlayerCharacter.typeVIP != 0);
				gSPacketIn.WriteInt(value.PlayerCharacter.VIPLevel);
			}
			gSPacketIn.WriteInt(1);
			for (int i = 0; i < 1; i++)
			{
				gSPacketIn.WriteInt(i + 1);
				gSPacketIn.WriteString("Living225");
				gSPacketIn.WriteString("Tà Linh Kate");
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(0);
			}
			gSPacketIn.WriteInt(3);
			gSPacketIn.WriteBoolean(val: false);
			player.SendTCP(gSPacketIn);
		}

		public void SendCampFightMonster(GamePlayer player)
		{
			RoomMgr.CreateCampBattleBossRoom(player, 60018);
		}

		public void SendUpdateMonsterStatus(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(146);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(1);
			method_0(gSPacketIn);
		}

		public void SendUpdatePlayerStatus(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(146);
			gSPacketIn.WriteByte(8);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(1);
			method_0(gSPacketIn);
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
				GSPacketIn gSPacketIn = new GSPacketIn(146);
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(player.ZoneId);
				gSPacketIn.WriteInt(player.PlayerId);
				player.SendTCP(gSPacketIn);
				method_1(gSPacketIn, player);
			}
			return true;
		}

		public void SendUpdateRoom(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(146);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(dictionary_0.Count);
			foreach (GamePlayer value in dictionary_0.Values)
			{
				gSPacketIn.WriteInt(value.PlayerCharacter.ID);
				gSPacketIn.WriteInt(player.ZoneId);
				gSPacketIn.WriteBoolean(value.PlayerCharacter.Sex);
				gSPacketIn.WriteString(value.PlayerCharacter.NickName);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(value.X);
				gSPacketIn.WriteInt(value.Y);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteBoolean(value.PlayerCharacter.typeVIP != 0);
				gSPacketIn.WriteInt(value.PlayerCharacter.VIPLevel);
			}
			method_1(gSPacketIn, player);
		}

		public void Challenge(int PlayerId, int ChallengeId)
		{
		}

		public void PlayerMove(GamePlayer player, int PosX, int PosY, int zoneId, int PlayerId)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(146);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(PosX);
			gSPacketIn.WriteInt(PosY);
			gSPacketIn.WriteInt(zoneId);
			gSPacketIn.WriteInt(PlayerId);
			player.SendTCP(gSPacketIn);
			method_1(gSPacketIn, player);
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

		static BaseCampBattleRoom()
		{
			random = new ThreadSafeRandom();
		}
	}
}
