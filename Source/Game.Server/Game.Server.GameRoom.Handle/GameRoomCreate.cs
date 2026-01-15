using System;
using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Buffer;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(0)]
	public class GameRoomCreate : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			byte timeType = packet.ReadByte();
			string name = packet.ReadString();
			string password = packet.ReadString();
			if (b == 15)
			{
				if (!Player.Labyrinth.completeChallenge)
				{
					Player.SendMessage(LanguageMgr.GetTranslation("GameRoomCreate.Msg1"));
					return false;
				}
				Player.Labyrinth.isInGame = true;
			}
			if (b == 14)
			{
				if (!RoomMgr.WorldBossRoom.worldOpen)
				{
					Player.CurrentRoom.RemovePlayerUnsafe(Player);
					return false;
				}
				double timeDelay = GetTimeDelay(Player.FightPower);
				int num = DateTime.Compare(Player.LastEnterWorldBoss.AddSeconds(timeDelay), DateTime.Now);
				if (num > 0)
				{
					Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("GameRoomCreate.Msg2", num));
					return false;
				}
				Player.LastEnterWorldBoss = DateTime.Now;
				Player.WorldbossBood = RoomMgr.WorldBossRoom.Blood;
				BufferList.CreatePayBuffer(400, 50000, 1)?.Start(Player);
				BufferList.CreatePayBuffer(406, 30000, 1)?.Start(Player);
			}
			RoomMgr.CreateRoom(Player, name, password, (eRoomType)b, timeType);
			return true;
		}

		public double GetTimeDelay(int fightPower)
		{
			if (fightPower < 1000000)
			{
				return 45.0;
			}
			if (fightPower < 2000000)
			{
				return 120.0;
			}
			if (fightPower < 4000000)
			{
				return 180.0;
			}
			if (fightPower < 6000000)
			{
				return 240.0;
			}
			if (fightPower < 8000000)
			{
				return 300.0;
			}
			return 600.0;
		}
	}
}
