using Game.Server.GameObjects;

namespace Game.Server.Rooms
{
	public class CreateHorseRaceRoomAction : IAction
	{
		private GamePlayer NjFpdTawyq;

		public CreateHorseRaceRoomAction(GamePlayer player)
		{
			NjFpdTawyq = player;
		}

		public void Execute()
		{
			if (NjFpdTawyq.CurrentRoom != null)
			{
				NjFpdTawyq.CurrentRoom.RemovePlayerUnsafe(NjFpdTawyq);
			}
			if (NjFpdTawyq.CurrentHorseRaceRoom != null)
			{
				NjFpdTawyq.CurrentHorseRaceRoom.RemovePlayerUnsafe(NjFpdTawyq);
			}
			if (NjFpdTawyq.PlayerCharacter.horseRaceCanRaceTime <= 0)
			{
				return;
			}
			BaseHorseRaceRoom[] horseRaceRoom = RoomMgr.HorseRaceRoom;
			BaseHorseRaceRoom baseHorseRaceRoom = method_0(horseRaceRoom);
			if (baseHorseRaceRoom == null)
			{
				for (int i = 0; i < horseRaceRoom.Length; i++)
				{
					if (!horseRaceRoom[i].IsPlaying)
					{
						baseHorseRaceRoom = horseRaceRoom[i];
						break;
					}
				}
				RoomMgr.WaitingRoom.RemovePlayer(NjFpdTawyq);
				baseHorseRaceRoom.AddPlayerUnsafe(NjFpdTawyq);
				baseHorseRaceRoom.IsWaiting = true;
			}
			else
			{
				RoomMgr.WaitingRoom.RemovePlayer(NjFpdTawyq);
				baseHorseRaceRoom.AddPlayerUnsafe(NjFpdTawyq);
			}
			if (baseHorseRaceRoom.CanStartGame())
			{
				baseHorseRaceRoom.StartGameTimer();
			}
		}

		private BaseHorseRaceRoom method_0(BaseHorseRaceRoom[] baseHorseRaceRoom_0)
		{
			for (int i = 0; i < baseHorseRaceRoom_0.Length; i++)
			{
				if (baseHorseRaceRoom_0[i] != null && baseHorseRaceRoom_0[i].IsWaiting && !baseHorseRaceRoom_0[i].IsPlaying && baseHorseRaceRoom_0[i].CanAddPlayer())
				{
					return baseHorseRaceRoom_0[i];
				}
			}
			return null;
		}
	}
}
