using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Farm.Handle
{
	[Attribute5(18)]
	public class FarmGropFastforward : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			packet.ReadBoolean();
			bool isAllField = packet.ReadBoolean();
			int fieldId = packet.ReadInt();
			int num = Player.Farm.ripeNum();
			int num2 = GameProperties.FastGrowNeedMoney * num;
			if (num2 <= 0)
			{
				return false;
			}
			if (Player.MoneyDirect(num2))
			{
				Player.Farm.GropFastforward(isAllField, fieldId);
			}
			return true;
		}
	}
}
