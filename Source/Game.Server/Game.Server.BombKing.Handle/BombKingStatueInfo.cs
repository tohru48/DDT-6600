using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.BombKing.Handle
{
	[Attribute2(2)]
	public class BombKingStatueInfo : IBombKingCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			PlayerInfo[] localTopThree = RankMgr.GetLocalTopThree();
			GSPacketIn gSPacketIn = new GSPacketIn(263);
			gSPacketIn.WriteByte(2);
			if (localTopThree.Length > 0)
			{
				int num = 1;
				PlayerInfo[] array = localTopThree;
				foreach (PlayerInfo playerInfo in array)
				{
					gSPacketIn.WriteBoolean(val: true);
					gSPacketIn.WriteString(playerInfo.NickName);
					gSPacketIn.WriteInt(playerInfo.typeVIP);
					gSPacketIn.WriteInt(playerInfo.VIPLevel);
					gSPacketIn.WriteString(playerInfo.Style);
					gSPacketIn.WriteString(playerInfo.Colors);
					gSPacketIn.WriteBoolean(playerInfo.Sex);
					gSPacketIn.WriteString(Player.ZoneName);
					if (playerInfo.ID == Player.PlayerId)
					{
						switch (num)
						{
						case 1:
							Player.Rank.AddNewRank(611);
							break;
						case 2:
							Player.Rank.AddNewRank(612);
							break;
						case 3:
							Player.Rank.AddNewRank(613);
							break;
						}
						Player.Rank.UpdateRank();
					}
					num++;
				}
			}
			else
			{
				gSPacketIn.WriteBoolean(val: false);
			}
			Player.SendTCP(gSPacketIn);
			return false;
		}
	}
}
