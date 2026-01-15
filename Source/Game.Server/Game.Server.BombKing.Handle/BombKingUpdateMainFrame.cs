using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.BombKing.Handle
{
	[Attribute2(3)]
	public class BombKingUpdateMainFrame : IBombKingCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			PlayerInfo[] allLocalTop = RankMgr.GetAllLocalTop();
			GSPacketIn gSPacketIn = new GSPacketIn(263);
			gSPacketIn.WriteByte(3);
			if (allLocalTop.Length > 0)
			{
				PlayerInfo[] array = allLocalTop;
				foreach (PlayerInfo playerInfo in array)
				{
					gSPacketIn.WriteBoolean(val: true);
					gSPacketIn.WriteInt(playerInfo.ID);
					gSPacketIn.WriteInt(Player.ZoneId);
					gSPacketIn.WriteString(playerInfo.NickName);
					gSPacketIn.WriteInt(0);
				}
			}
			else
			{
				gSPacketIn.WriteBoolean(val: false);
			}
			allLocalTop = RankMgr.GetLocalTopThree();
			if (allLocalTop.Length > 0)
			{
				PlayerInfo[] array2 = allLocalTop;
				foreach (PlayerInfo playerInfo2 in array2)
				{
					gSPacketIn.WriteBoolean(val: true);
					gSPacketIn.WriteInt(playerInfo2.ID);
					gSPacketIn.WriteInt(Player.ZoneId);
					gSPacketIn.WriteString(playerInfo2.NickName);
					gSPacketIn.WriteString(playerInfo2.Style);
					gSPacketIn.WriteString(playerInfo2.Colors);
					gSPacketIn.WriteBoolean(playerInfo2.Sex);
				}
			}
			else
			{
				gSPacketIn.WriteBoolean(val: false);
			}
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteDateTime(DateTime.Now.AddDays(1.0));
			Player.SendTCP(gSPacketIn);
			return false;
		}
	}
}
