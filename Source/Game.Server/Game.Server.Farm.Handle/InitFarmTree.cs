using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Farm.Handle
{
	[Attribute5(22)]
	public class InitFarmTree : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (packet.ReadInt() == 0)
			{
				UserFarmInfo currentFarm = Player.Farm.CurrentFarm;
				if (currentFarm != null)
				{
					GSPacketIn gSPacketIn = new GSPacketIn(81, Player.PlayerId);
					gSPacketIn.WriteByte(22);
					gSPacketIn.WriteInt(currentFarm.TreeLevel);
					gSPacketIn.WriteInt(currentFarm.LoveScore);
					gSPacketIn.WriteInt(currentFarm.TreeExp);
					gSPacketIn.WriteInt(currentFarm.TreeCostExp);
					Player.SendTCP(gSPacketIn);
				}
			}
			return true;
		}
	}
}
