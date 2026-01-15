using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Farm.Handle
{
	[Attribute5(7)]
	public class KillCropField : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int fieldId = packet.ReadInt();
			Player.Farm.killCropField(fieldId);
			return true;
		}
	}
}
