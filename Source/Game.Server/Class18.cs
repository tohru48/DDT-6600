using Bussiness;
using Game.Base.Packets;
using Game.Server;
using Game.Server.Packets.Client;
using SqlDataProvider.Data;

[PacketHandler(235, "获取征婚信息")]
internal class Class18 : IPacketHandler
{
	public int HandlePacket(GameClient client, GSPacketIn packet)
	{
		if (client.Player.PlayerCharacter.MarryInfoID == 0)
		{
			return 1;
		}
		int ıD = packet.ReadInt();
		using (PlayerBussiness playerBussiness = new PlayerBussiness())
		{
			MarryInfo marryInfoSingle = playerBussiness.GetMarryInfoSingle(ıD);
			if (marryInfoSingle != null)
			{
				client.Player.Out.SendMarryInfo(client.Player, marryInfoSingle);
				return 0;
			}
		}
		return 1;
	}
}
