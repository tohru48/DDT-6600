using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Buffer;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(7)]
	public class GameStart : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			BaseRoom currentRoom = Player.CurrentRoom;
			if (currentRoom != null && currentRoom.Host == Player)
			{
				if (currentRoom.RoomType == eRoomType.EntertainmentPK && !Player.MoneyDirect(100))
				{
					return false;
				}
				List<GamePlayer> players = currentRoom.GetPlayers();
				bool flag = false;
				if (Player.MainWeapon == null)
				{
					Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip"));
					flag = true;
				}
				else if (currentRoom.RoomType == eRoomType.Dungeon && !Player.IsPvePermission(currentRoom.MapId, currentRoom.HardLevel))
				{
					Player.SendMessage(LanguageMgr.GetTranslation("GameStart.Msg1"));
					flag = true;
				}
				else if (currentRoom.RoomType == eRoomType.FarmBoss && (players.Count == 1 || players.Count > 2))
				{
					Player.SendMessage(LanguageMgr.GetTranslation("GameStart.Msg2"));
					flag = true;
				}
				else
				{
					foreach (GamePlayer item in players)
					{
						if (item != null)
						{
							if (currentRoom.RoomType == eRoomType.ActivityDungeon && item.Actives.Info.activityTanabataNum == 0)
							{
								item.Actives.Info.activityTanabataNum++;
							}
							if (currentRoom.RoomType != eRoomType.Lanbyrinth && currentRoom.RoomType != eRoomType.Dungeon)
							{
								item.Extra.KingBlessStrengthEnchance(isUp: false);
							}
							else
							{
								item.Extra.KingBlessStrengthEnchance(isUp: true);
							}
							item.PetBag.ReduceHunger();
							if (currentRoom.RoomType == eRoomType.Entertainment || currentRoom.RoomType == eRoomType.EntertainmentPK)
							{
								item.ClearFightBag();
								BufferList.CreatePayBuffer(400, 20000, 1)?.Start(item);
							}
						}
					}
					RoomMgr.StartGame(Player.CurrentRoom);
				}
				if (flag)
				{
					Player.CurrentRoom.IsPlaying = false;
					Player.CurrentRoom.SendCancelPickUp();
				}
			}
			return true;
		}
	}
}
