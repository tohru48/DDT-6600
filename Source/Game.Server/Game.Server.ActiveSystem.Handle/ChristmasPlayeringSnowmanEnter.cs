using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Rooms;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(17)]
	public class ChristmasPlayeringSnowmanEnter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			byte b = packet.ReadByte();
			BaseChristmasRoom christmasRoom = RoomMgr.ChristmasRoom;
			UserChristmasInfo christmas = Player.Actives.Christmas;
			switch (b)
			{
			case 2:
			{
				int x = packet.ReadInt();
				int y = packet.ReadInt();
				Player.X = x;
				Player.Y = y;
				if (Player.CurrentRoom != null)
				{
					Player.CurrentRoom.RemovePlayerUnsafe(Player);
				}
				christmasRoom.AddMoreMonters();
				christmasRoom.SetMonterDie(Player.PlayerCharacter.ID);
				if (!Player.Actives.AvailTime())
				{
					Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg1"));
					return false;
				}
				gSPacketIn.WriteByte(22);
				gSPacketIn.WriteByte(0);
				gSPacketIn.WriteInt(christmasRoom.Monters.Count);
				foreach (MonterInfo value in christmasRoom.Monters.Values)
				{
					gSPacketIn.WriteInt(value.ID);
					gSPacketIn.WriteInt(value.type);
					gSPacketIn.WriteInt(value.state);
					gSPacketIn.WriteInt(value.MonsterPos.X);
					gSPacketIn.WriteInt(value.MonsterPos.Y);
				}
				Player.Out.SendTCP(gSPacketIn);
				christmasRoom.ViewOtherPlayerRoom(Player);
				break;
			}
			case 0:
			{
				Player.X = christmasRoom.DefaultPosX;
				Player.Y = christmasRoom.DefaultPosY;
				christmasRoom.AddPlayer(Player);
				int christmasMinute = GameProperties.ChristmasMinute;
				if (!christmas.isEnter)
				{
					christmas.gameBeginTime = DateTime.Now;
					christmas.gameEndTime = DateTime.Now.AddMinutes(christmasMinute);
					christmas.isEnter = true;
					christmas.AvailTime = christmasMinute;
				}
				else
				{
					christmasMinute = christmas.AvailTime;
					christmas.gameBeginTime = DateTime.Now;
					christmas.gameEndTime = DateTime.Now.AddMinutes(christmasMinute);
				}
				bool val = Player.Actives.AvailTime();
				gSPacketIn.WriteByte(17);
				gSPacketIn.WriteBoolean(val);
				gSPacketIn.WriteDateTime(christmas.gameBeginTime);
				gSPacketIn.WriteDateTime(christmas.gameEndTime);
				gSPacketIn.WriteInt(christmas.count);
				Player.Out.SendTCP(gSPacketIn);
				break;
			}
			case 1:
				christmasRoom.RemovePlayer(Player);
				break;
			}
			return true;
		}
	}
}
