using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(11)]
	public class GamePickupCencel : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.CurrentRoom != null && Player.CurrentRoom.BattleServer != null)
			{
				Player.CurrentRoom.BattleServer.RemoveRoom(Player.CurrentRoom);
				if (Player != Player.CurrentRoom.Host)
				{
					Player.CurrentRoom.Host.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("Game.Server.SceneGames.PairUp.Failed"));
					RoomMgr.UpdatePlayerState(Player, 0);
				}
				else if (Player.CurrentRoom.RoomType == eRoomType.BattleRoom)
				{
					Player.CurrentRoom.RemovePlayerUnsafe(Player);
				}
				else
				{
					RoomMgr.UpdatePlayerState(Player, 2);
				}
			}
			if (Player.CurrentHorseRaceRoom != null)
			{
				Player.CurrentHorseRaceRoom.RemovePlayerUnsafe(Player);
			}
			return true;
		}
	}
}
