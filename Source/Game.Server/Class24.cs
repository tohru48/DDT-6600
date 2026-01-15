using Bussiness;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;

internal class Class24 : IAction
{
	private GamePlayer gamePlayer_0;

	private int int_0;

	private string string_0;

	private int int_1;

	public Class24(GamePlayer gamePlayer_1, int int_2, string string_1, int int_3)
	{
		gamePlayer_0 = gamePlayer_1;
		int_0 = int_2;
		string_0 = string_1;
		int_1 = int_3;
	}

	public void Execute()
	{
		if (!gamePlayer_0.IsActive)
		{
			return;
		}
		if (gamePlayer_0.CurrentRoom != null)
		{
			gamePlayer_0.CurrentRoom.RemovePlayerUnsafe(gamePlayer_0);
		}
		BaseRoom[] rooms = RoomMgr.Rooms;
		BaseRoom baseRoom;
		if (int_0 == -1)
		{
			baseRoom = method_0(rooms);
			if (baseRoom == null)
			{
				gamePlayer_0.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("EnterRoomAction.Msg1"));
				gamePlayer_0.Out.SendRoomLoginResult(result: false);
				return;
			}
		}
		else
		{
			baseRoom = rooms[int_0 - 1];
		}
		if (!baseRoom.IsUsing)
		{
			gamePlayer_0.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("EnterRoomAction.Msg2"));
			return;
		}
		if (baseRoom != null)
		{
			if (baseRoom.RoomType == eRoomType.ActivityDungeon && gamePlayer_0.Actives.Info.activityTanabataNum > 0)
			{
				gamePlayer_0.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("EnterRoomAction.Msg3"));
				return;
			}
			if (baseRoom.RoomType == eRoomType.FarmBoss && baseRoom.Host != null && gamePlayer_0 != baseRoom.Host && gamePlayer_0.PlayerCharacter.ID != baseRoom.Host.PlayerCharacter.SpouseID)
			{
				gamePlayer_0.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("EnterRoomAction.Msg7"));
				return;
			}
		}
		if (baseRoom.PlayerCount == baseRoom.PlacesCount)
		{
			gamePlayer_0.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("EnterRoomAction.Msg4"));
		}
		else if (baseRoom.NeedPassword && !(baseRoom.Password == string_0))
		{
			gamePlayer_0.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("EnterRoomAction.Msg6"));
			gamePlayer_0.Out.SendRoomLoginResult(result: false);
		}
		else
		{
			if (baseRoom.Game != null && !baseRoom.Game.CanAddPlayer())
			{
				return;
			}
			if (baseRoom.LevelLimits > (int)baseRoom.GetLevelLimit(gamePlayer_0))
			{
				gamePlayer_0.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("EnterRoomAction.Msg5"));
				return;
			}
			RoomMgr.WaitingRoom.RemovePlayer(gamePlayer_0);
			gamePlayer_0.Out.SendRoomLoginResult(result: true);
			gamePlayer_0.Out.SendRoomCreate(baseRoom);
			if (baseRoom.AddPlayerUnsafe(gamePlayer_0) && baseRoom.Game != null)
			{
				baseRoom.Game.AddPlayer(gamePlayer_0);
			}
			RoomMgr.WaitingRoom.SendUpdateCurrentRoom(baseRoom);
			gamePlayer_0.Out.SendGameRoomSetupChange(baseRoom);
		}
	}

	private BaseRoom method_0(BaseRoom[] baseRoom_0)
	{
		for (int i = 0; i < baseRoom_0.Length; i++)
		{
			if (baseRoom_0[i].PlayerCount <= 0 || !baseRoom_0[i].CanAddPlayer() || baseRoom_0[i].NeedPassword || baseRoom_0[i].IsPlaying)
			{
				continue;
			}
			if (10 != int_1)
			{
				if (baseRoom_0[i].RoomType == (eRoomType)int_1)
				{
					return baseRoom_0[i];
				}
			}
			else if (baseRoom_0[i].RoomType == (eRoomType)int_1 && baseRoom_0[i].LevelLimits < (int)baseRoom_0[i].GetLevelLimit(gamePlayer_0))
			{
				return baseRoom_0[i];
			}
		}
		return null;
	}
}
