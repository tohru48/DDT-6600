using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(12)]
	public class GamePickupStyle : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			packet.ReadInt();
			if (Player.CurrentRoom != null)
			{
				if (packet.ReadInt() == 0)
				{
					Player.CurrentRoom.GameType = eGameType.Free;
				}
				else
				{
					Player.CurrentRoom.GameType = eGameType.Guild;
				}
				GSPacketIn pkg = Player.Out.SendRoomType(Player, Player.CurrentRoom);
				Player.CurrentRoom.SendToAll(pkg, Player);
			}
			return true;
		}
	}
}
