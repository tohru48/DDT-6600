using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Farm.Handle
{
	[Attribute5(2)]
	public class GrowFields : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			packet.ReadByte();
			int num = packet.ReadInt();
			int fieldId = packet.ReadInt();
			if (Player.Farm.GrowField(fieldId, num))
			{
				Player.FarmBag.RemoveTemplate(num, 1);
				Player.OnSeedFoodPetEvent();
			}
			return true;
		}
	}
}
