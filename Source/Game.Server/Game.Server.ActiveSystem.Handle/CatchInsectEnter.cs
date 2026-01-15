using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(143)]
	public class CatchInsectEnter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			BaseCatchInsectRoom catchInsectRoom = RoomMgr.CatchInsectRoom;
			byte b = packet.ReadByte();
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			switch (b)
			{
			case 0:
				gSPacketIn.WriteByte(143);
				gSPacketIn.WriteBoolean(val: true);
				Player.Out.SendTCP(gSPacketIn);
				break;
			case 1:
				catchInsectRoom.RemovePlayer(Player);
				break;
			case 2:
			{
				int x = packet.ReadInt();
				int y = packet.ReadInt();
				Player.X = x;
				Player.Y = y;
				catchInsectRoom.AddPlayer(Player);
				if (Player.CurrentRoom != null)
				{
					Player.CurrentRoom.RemovePlayerUnsafe(Player);
				}
				catchInsectRoom.AddMoreMonters();
				catchInsectRoom.SetMonterDie(Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(133);
				gSPacketIn.WriteByte(0);
				gSPacketIn.WriteInt(catchInsectRoom.Monters.Count);
				foreach (MonterInfo value in catchInsectRoom.Monters.Values)
				{
					gSPacketIn.WriteInt(value.ID);
					gSPacketIn.WriteInt(value.type);
					gSPacketIn.WriteInt(value.state);
					gSPacketIn.WriteInt(value.MonsterPos.X);
					gSPacketIn.WriteInt(value.MonsterPos.Y);
				}
				Player.Out.SendTCP(gSPacketIn);
				catchInsectRoom.ViewOtherPlayerRoom(Player);
				break;
			}
			}
			return true;
		}
	}
}
