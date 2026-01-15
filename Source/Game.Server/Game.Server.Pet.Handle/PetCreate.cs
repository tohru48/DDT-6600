using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Pet.Handle
{
	[Attribute14(2)]
	public class PetCreate : IPetCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			return false;
		}
	}
}
