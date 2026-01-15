using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Battle;
using Game.Server.GameObjects;
using Game.Server.Packets;

namespace Game.Server.Rooms
{
	public class CreateEncounterRoomAction : IAction
	{
		private GamePlayer gamePlayer_0;

		private string string_0;

		private string string_1;

		private eRoomType eRoomType_0;

		private byte byte_0;

		public CreateEncounterRoomAction(GamePlayer player, eRoomType roomType)
		{
			gamePlayer_0 = player;
			string_0 = "Couple PvP";
			string_1 = "12dasSda44";
			eRoomType_0 = roomType;
			byte_0 = 2;
		}

		public void Execute()
		{
			if (gamePlayer_0.CurrentRoom != null)
			{
				gamePlayer_0.CurrentRoom.RemovePlayerUnsafe(gamePlayer_0);
			}
			if (!gamePlayer_0.IsActive)
			{
				return;
			}
			BaseRoom[] rooms = RoomMgr.Rooms;
			BaseRoom baseRoom = method_0(rooms);
			if (baseRoom == null)
			{
				for (int i = 0; i < rooms.Length; i++)
				{
					if (!rooms[i].IsUsing)
					{
						baseRoom = rooms[i];
						break;
					}
				}
				if (baseRoom != null)
				{
					RoomMgr.WaitingRoom.RemovePlayer(gamePlayer_0);
					baseRoom.Start();
					baseRoom.UpdateRoom(string_0, string_1, eRoomType_0, byte_0, 0);
					baseRoom.ZoneId = gamePlayer_0.ZoneId;
					gamePlayer_0.Out.SendSingleRoomCreate(baseRoom);
					baseRoom.AddPlayerUnsafe(gamePlayer_0);
				}
			}
			else
			{
				RoomMgr.WaitingRoom.RemovePlayer(gamePlayer_0);
				gamePlayer_0.Out.SendRoomLoginResult(result: true);
				gamePlayer_0.Out.SendSingleRoomCreate(baseRoom);
				baseRoom.AddPlayerUnsafe(gamePlayer_0);
			}
			if (baseRoom.PlayerCount == 2)
			{
				BattleServer battleServer = BattleMgr.AddRoom(baseRoom);
				if (battleServer != null)
				{
					baseRoom.BattleServer = battleServer;
					baseRoom.IsPlaying = true;
					baseRoom.SendStartPickUp();
				}
				else
				{
					GSPacketIn pkg = baseRoom.Host.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("StartGameAction.noBattleServe"));
					baseRoom.SendToAll(pkg, baseRoom.Host);
					baseRoom.SendCancelPickUp();
				}
			}
		}

		private BaseRoom method_0(BaseRoom[] baseRoom_0)
		{
			for (int i = 0; i < baseRoom_0.Length; i++)
			{
				if (baseRoom_0[i] != null && baseRoom_0[i].RoomType == eRoomType_0 && !baseRoom_0[i].IsPlaying && baseRoom_0[i].PlayerCount < 2 && baseRoom_0[i].RoomType == eRoomType.Encounter && baseRoom_0[i].Host != null && baseRoom_0[i].Host.PlayerCharacter.Sex != gamePlayer_0.PlayerCharacter.Sex)
				{
					return baseRoom_0[i];
				}
			}
			return null;
		}
	}
}
