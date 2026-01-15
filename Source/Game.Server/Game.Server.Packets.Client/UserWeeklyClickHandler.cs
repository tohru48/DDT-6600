using System;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(219, "场景用户离开")]
	public class UserWeeklyClickHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int ıD = client.Player.PlayerCharacter.ID;
			GSPacketIn gSPacketIn = new GSPacketIn(219, ıD);
			if (DateTime.Now.Date != client.Player.PlayerCharacter.LastGetEgg.Date)
			{
				gSPacketIn.WriteBoolean(val: true);
			}
			else
			{
				gSPacketIn.WriteBoolean(val: false);
			}
			client.SendTCP(gSPacketIn);
			return 0;
		}
	}
}
