using System.Collections.Generic;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.DragonBoat.Handle
{
	[Attribute4(16)]
	public class DragonBoatRefreshRank : IDragonBoatCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int val = DragonBoatMgr.MinScore();
			int val2 = DragonBoatMgr.FindMyRank(Player.PlayerCharacter.ID);
			List<ActiveSystemInfo> list = DragonBoatMgr.SelectTopTenCurrenServer();
			GSPacketIn gSPacketIn = new GSPacketIn(100);
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteInt(list.Count);
			foreach (ActiveSystemInfo item in list)
			{
				gSPacketIn.WriteInt(item.myRank);
				gSPacketIn.WriteInt(item.totalScore);
				gSPacketIn.WriteString(item.NickName);
			}
			gSPacketIn.WriteInt(val2);
			gSPacketIn.WriteInt(val);
			Player.SendTCP(gSPacketIn);
			list = DragonBoatMgr.SelectTopTenAllServer();
			val2 = DragonBoatMgr.FindAreaMyRank(Player.PlayerCharacter.ID, Player.ZoneId);
			GSPacketIn gSPacketIn2 = new GSPacketIn(100);
			gSPacketIn2.WriteByte(17);
			gSPacketIn2.WriteInt(list.Count);
			foreach (ActiveSystemInfo item2 in list)
			{
				gSPacketIn2.WriteInt(item2.myRank);
				gSPacketIn2.WriteInt(item2.totalScore);
				gSPacketIn2.WriteString(item2.NickName);
				gSPacketIn2.WriteString(item2.ZoneName);
			}
			gSPacketIn2.WriteInt(val2);
			gSPacketIn2.WriteInt(val);
			Player.SendTCP(gSPacketIn2);
			return true;
		}
	}
}
