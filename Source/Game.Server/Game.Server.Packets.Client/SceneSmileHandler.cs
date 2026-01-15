using Game.Base.Packets;
using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
	[PacketHandler(20, "用户场景表情")]
	public class SceneSmileHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			packet.ClientID = client.Player.PlayerCharacter.ID;
			if (client.Player.CurrentRoom != null)
			{
				client.Player.CurrentRoom.SendToAll(packet);
			}
			else if (client.Player.CurrentMarryRoom != null)
			{
				client.Player.CurrentMarryRoom.SendToAllForScene(packet, client.Player.MarryMap);
			}
			else
			{
				RoomMgr.WaitingRoom.method_0(packet);
			}
			return 1;
		}
	}
}
