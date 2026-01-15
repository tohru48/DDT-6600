using System;
using System.Collections.Generic;
using System.Drawing;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Rooms
{
	public class BaseConsBatRoom
	{
		private Dictionary<int, GamePlayer> dictionary_0;

		private Dictionary<int, ConsortiaBattlePlayerInfo> dictionary_1;

		private Point[] point_0;

		public BaseConsBatRoom()
		{
			point_0 = new Point[8]
			{
				new Point(353, 570),
				new Point(246, 760),
				new Point(593, 590),
				new Point(466, 898),
				new Point(800, 950),
				new Point(946, 748),
				new Point(1152, 873),
				new Point(1172, 874)
			};
			dictionary_0 = new Dictionary<int, GamePlayer>();
			dictionary_1 = new Dictionary<int, ConsortiaBattlePlayerInfo>();
		}

		public ConsortiaBattlePlayerInfo CreateConsortiaBattlePlayerInfo(GamePlayer player)
		{
			ConsortiaBattlePlayerInfo consortiaBattlePlayerInfo = new ConsortiaBattlePlayerInfo();
			consortiaBattlePlayerInfo.PlayerID = player.PlayerCharacter.ID;
			consortiaBattlePlayerInfo.Sex = player.PlayerCharacter.Sex;
			consortiaBattlePlayerInfo.curHp = player.PlayerCharacter.hp;
			consortiaBattlePlayerInfo.posX = 631;
			consortiaBattlePlayerInfo.posY = 959;
			consortiaBattlePlayerInfo.consortiaID = player.PlayerCharacter.ConsortiaID;
			consortiaBattlePlayerInfo.consortiaName = player.PlayerCharacter.ConsortiaName;
			consortiaBattlePlayerInfo.tombstoneEndTime = DateTime.Now.AddMinutes(-10.0);
			consortiaBattlePlayerInfo.status = 1;
			consortiaBattlePlayerInfo.victoryCount = 0;
			consortiaBattlePlayerInfo.winningStreak = 0;
			consortiaBattlePlayerInfo.failBuffCount = 0;
			consortiaBattlePlayerInfo.score = 0;
			consortiaBattlePlayerInfo.isPowerFullUsed = false;
			consortiaBattlePlayerInfo.isDoubleScoreUsed = false;
			return consortiaBattlePlayerInfo;
		}

		public bool AddPlayer(GamePlayer player)
		{
			bool result = true;
			lock (dictionary_0)
			{
				if (!dictionary_0.ContainsKey(player.PlayerId))
				{
					dictionary_0.Add(player.PlayerId, player);
				}
			}
			ConsortiaBattlePlayerInfo consortiaBattlePlayerInfo = CreateConsortiaBattlePlayerInfo(player);
			lock (dictionary_1)
			{
				if (!dictionary_1.ContainsKey(player.PlayerId))
				{
					dictionary_1.Add(player.PlayerId, consortiaBattlePlayerInfo);
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(153, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteDateTime(consortiaBattlePlayerInfo.tombstoneEndTime);
			gSPacketIn.WriteInt(consortiaBattlePlayerInfo.posX);
			gSPacketIn.WriteInt(consortiaBattlePlayerInfo.posY);
			gSPacketIn.WriteInt(consortiaBattlePlayerInfo.curHp);
			gSPacketIn.WriteInt(consortiaBattlePlayerInfo.victoryCount);
			gSPacketIn.WriteInt(consortiaBattlePlayerInfo.winningStreak);
			gSPacketIn.WriteInt(consortiaBattlePlayerInfo.score);
			gSPacketIn.WriteBoolean(consortiaBattlePlayerInfo.isDoubleScoreUsed);
			gSPacketIn.WriteBoolean(consortiaBattlePlayerInfo.isPowerFullUsed);
			player.SendTCP(gSPacketIn);
			return result;
		}

		public bool RemovePlayer(GamePlayer player)
		{
			bool flag = false;
			lock (dictionary_0)
			{
				flag = dictionary_0.Remove(player.PlayerId) && dictionary_1.Remove(player.PlayerId);
			}
			if (flag)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(153);
				gSPacketIn.WriteByte(5);
				gSPacketIn.WriteInt(player.PlayerCharacter.ID);
				player.SendTCP(gSPacketIn);
				method_1(gSPacketIn, player);
			}
			return true;
		}

		public void SendUpdateRoom(GamePlayer player)
		{
			int count = dictionary_1.Count;
			GSPacketIn gSPacketIn = new GSPacketIn(153);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(count);
			foreach (ConsortiaBattlePlayerInfo value in dictionary_1.Values)
			{
				gSPacketIn.WriteInt(value.PlayerID);
				gSPacketIn.WriteDateTime(value.tombstoneEndTime);
				gSPacketIn.WriteByte(value.status);
				gSPacketIn.WriteInt(value.posX);
				gSPacketIn.WriteInt(value.posY);
				gSPacketIn.WriteBoolean(value.Sex);
				gSPacketIn.WriteInt(value.consortiaID);
				gSPacketIn.WriteString(value.consortiaName);
				gSPacketIn.WriteInt(value.winningStreak);
				gSPacketIn.WriteInt(value.failBuffCount);
			}
			player.SendTCP(gSPacketIn);
		}

		public void Challenge(int PlayerId, int ChallengeId)
		{
			lock (dictionary_1)
			{
				GamePlayer gamePlayer = null;
				GamePlayer gamePlayer2 = null;
				if (dictionary_1.ContainsKey(ChallengeId) && dictionary_0.ContainsKey(ChallengeId) && dictionary_1[ChallengeId].status == 1)
				{
					dictionary_1[ChallengeId].status = 2;
					SendUpdatePlayerStatus(dictionary_1[ChallengeId]);
					gamePlayer2 = dictionary_0[ChallengeId];
					gamePlayer2.isPowerFullUsed = dictionary_1[ChallengeId].isPowerFullUsed;
					gamePlayer2.winningStreak = dictionary_1[ChallengeId].winningStreak;
					gamePlayer2.PlayerCharacter.hp = dictionary_1[PlayerId].curHp;
					gamePlayer2.CurrentRoomTeam = 2;
				}
				if (dictionary_1.ContainsKey(PlayerId) && dictionary_0.ContainsKey(PlayerId) && dictionary_1[PlayerId].status == 1)
				{
					dictionary_1[PlayerId].status = 2;
					SendUpdatePlayerStatus(dictionary_1[PlayerId]);
					gamePlayer = dictionary_0[PlayerId];
					gamePlayer.isPowerFullUsed = dictionary_1[PlayerId].isPowerFullUsed;
					gamePlayer.winningStreak = dictionary_1[PlayerId].winningStreak;
					gamePlayer.PlayerCharacter.hp = dictionary_1[PlayerId].curHp;
					gamePlayer.CurrentRoomTeam = 1;
				}
				if (gamePlayer != null && gamePlayer2 != null)
				{
					RoomMgr.CreateConsortiaBattleRoom(gamePlayer, gamePlayer2);
				}
			}
		}

		public void SendUpdatePlayerStatus(ConsortiaBattlePlayerInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(153, info.PlayerID);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteInt(info.PlayerID);
			gSPacketIn.WriteDateTime(info.tombstoneEndTime);
			gSPacketIn.WriteByte(info.status);
			gSPacketIn.WriteInt(info.posX);
			gSPacketIn.WriteInt(info.posY);
			gSPacketIn.WriteInt(info.winningStreak);
			gSPacketIn.WriteInt(info.failBuffCount);
			method_0(gSPacketIn);
		}

		public void PlayerMove(int PosX, int PosY, int PlayerId)
		{
			lock (dictionary_1)
			{
				if (dictionary_1.ContainsKey(PlayerId))
				{
					dictionary_1[PlayerId].posX = PosX;
					dictionary_1[PlayerId].posY = PosY;
				}
			}
		}

		public void BattleWin(int WinPlayerId, int lostwinningStreak, int curHp)
		{
			int num = 30;
			lock (dictionary_1)
			{
				if (dictionary_1.ContainsKey(WinPlayerId))
				{
					dictionary_1[WinPlayerId].status = 1;
					dictionary_1[WinPlayerId].tombstoneEndTime = DateTime.Now.AddSeconds(-1.0);
					dictionary_1[WinPlayerId].curHp = curHp;
					dictionary_1[WinPlayerId].winningStreak++;
					dictionary_1[WinPlayerId].victoryCount++;
					if (dictionary_1[WinPlayerId].winningStreak == 3)
					{
						num = 50;
					}
					else if (dictionary_1[WinPlayerId].winningStreak == 6)
					{
						num = 70;
					}
					else if (dictionary_1[WinPlayerId].winningStreak == 10)
					{
						num = 110;
					}
					if (dictionary_1[WinPlayerId].isDoubleScoreUsed)
					{
						num *= 2;
						dictionary_1[WinPlayerId].isDoubleScoreUsed = false;
					}
					dictionary_1[WinPlayerId].score += num;
					if (lostwinningStreak >= 3 && lostwinningStreak < 6)
					{
						dictionary_1[WinPlayerId].score += 50;
					}
					else if (lostwinningStreak >= 6 && lostwinningStreak < 10)
					{
						dictionary_1[WinPlayerId].score += 70;
					}
					else if (lostwinningStreak >= 10)
					{
						dictionary_1[WinPlayerId].score += 90;
					}
					dictionary_1[WinPlayerId].isPowerFullUsed = false;
				}
			}
		}

		public void BattleLost(int LostPlayerId)
		{
			int num = 5;
			lock (dictionary_1)
			{
				if (dictionary_1.ContainsKey(LostPlayerId))
				{
					int winningStreak = dictionary_1[LostPlayerId].winningStreak;
					dictionary_1[LostPlayerId].status = 1;
					dictionary_1[LostPlayerId].winningStreak = 0;
					dictionary_1[LostPlayerId].tombstoneEndTime = DateTime.Now.AddSeconds(15.0);
					dictionary_1[LostPlayerId].posX = 631;
					dictionary_1[LostPlayerId].posY = 959;
					if (dictionary_1[LostPlayerId].isDoubleScoreUsed)
					{
						num *= 2;
						dictionary_1[LostPlayerId].isDoubleScoreUsed = false;
					}
					dictionary_1[LostPlayerId].isPowerFullUsed = false;
					dictionary_1[LostPlayerId].score += num;
				}
			}
		}

		public void SendConfirmEnterRoom(GamePlayer player)
		{
			int count = dictionary_1.Count;
			GSPacketIn gSPacketIn = new GSPacketIn(153, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(count);
			foreach (ConsortiaBattlePlayerInfo value in dictionary_1.Values)
			{
				gSPacketIn.WriteInt(value.PlayerID);
				gSPacketIn.WriteDateTime(value.tombstoneEndTime);
				gSPacketIn.WriteByte(value.status);
				gSPacketIn.WriteInt(value.posX);
				gSPacketIn.WriteInt(value.posY);
				gSPacketIn.WriteBoolean(value.Sex);
				gSPacketIn.WriteInt(value.consortiaID);
				gSPacketIn.WriteString(value.consortiaName);
				gSPacketIn.WriteInt(value.winningStreak);
				gSPacketIn.WriteInt(value.failBuffCount);
			}
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
	}
}
