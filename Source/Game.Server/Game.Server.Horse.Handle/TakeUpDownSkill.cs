using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Horse.Handle
{
	[Attribute9(6)]
	public class TakeUpDownSkill : IHorseCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			Player.Horse.TakeUpDownSkill(num2, num);
			GSPacketIn gSPacketIn = new GSPacketIn(260);
			gSPacketIn.WriteByte(6);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteInt(num2);
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
