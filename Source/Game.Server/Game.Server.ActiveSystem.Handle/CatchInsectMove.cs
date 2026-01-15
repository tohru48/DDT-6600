using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(141)]
	public class CatchInsectMove : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			BaseCatchInsectRoom catchInsectRoom = RoomMgr.CatchInsectRoom;
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			string str = packet.ReadString();
			Player.X = num;
			Player.Y = num2;
			gSPacketIn.WriteByte(141);
			gSPacketIn.WriteInt(Player.PlayerId);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteInt(num2);
			gSPacketIn.WriteString(str);
			catchInsectRoom.method_1(gSPacketIn);
			return true;
		}
	}
}
