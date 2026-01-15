using Game.Base.Packets;
using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
	[PacketHandler(16, "Player enter scene.")]
	public class UserEnterSceneHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			switch (packet.ReadInt())
			{
			case 1:
				client.Player.PlayerState = ePlayerState.Online;
				break;
			case 2:
				client.Player.PlayerState = ePlayerState.Away;
				break;
			default:
				client.Player.PlayerState = ePlayerState.Online;
				break;
			}
			RoomMgr.WaitingRoom.SendSceneUpdate(client.Player);
			return 1;
		}
	}
}
