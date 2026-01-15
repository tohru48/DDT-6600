using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
	[Attribute15(4)]
	public class RingStationBattleField : IRingStationCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			RingstationBattleFieldInfo[] ringBattleFields = RingStationMgr.GetRingBattleFields(Player.PlayerId);
			GSPacketIn gSPacketIn = new GSPacketIn(404, Player.PlayerId);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(ringBattleFields.Length);
			RingstationBattleFieldInfo[] array = ringBattleFields;
			foreach (RingstationBattleFieldInfo ringstationBattleFieldInfo in array)
			{
				gSPacketIn.WriteBoolean(ringstationBattleFieldInfo.DareFlag);
				gSPacketIn.WriteString(ringstationBattleFieldInfo.UserName);
				gSPacketIn.WriteBoolean(ringstationBattleFieldInfo.SuccessFlag);
				gSPacketIn.WriteInt(ringstationBattleFieldInfo.Level);
			}
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
