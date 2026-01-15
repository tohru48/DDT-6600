using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Battle;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.RingStation;

namespace Game.Server.Rooms
{
	public class CreateGroupBattleRoomAction : IAction
	{
		private GamePlayer gamePlayer_0;

		private string IdfpzjeLbq;

		private string string_0;

		private eRoomType eRoomType_0;

		private byte byte_0;

		private int int_0;

		public CreateGroupBattleRoomAction(GamePlayer player, int groupType)
		{
			gamePlayer_0 = player;
			IdfpzjeLbq = "GroupBattle PvP";
			string_0 = "12dasSda44";
			eRoomType_0 = eRoomType.SingleBattle;
			byte_0 = 2;
			int_0 = groupType;
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
			int num = method_0(int_0);
			if (num == 1)
			{
				BaseRoom baseRoom = null;
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
					baseRoom.UpdateRoom(IdfpzjeLbq, string_0, eRoomType_0, byte_0, 0);
					baseRoom.PickUpNpcId = RingStationConfiguration.NextPlayerID();
					baseRoom.ZoneId = gamePlayer_0.ZoneId;
					gamePlayer_0.Out.SendSingleRoomCreate(baseRoom);
					baseRoom.AddPlayerUnsafe(gamePlayer_0);
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
				return;
			}
			BaseRoom baseRoom2 = method_1(rooms, num);
			if (baseRoom2 == null)
			{
				for (int j = 0; j < rooms.Length; j++)
				{
					if (!rooms[j].IsUsing)
					{
						baseRoom2 = rooms[j];
						break;
					}
				}
				if (baseRoom2 != null)
				{
					RoomMgr.WaitingRoom.RemovePlayer(gamePlayer_0);
					baseRoom2.Start();
					baseRoom2.UpdateRoom(IdfpzjeLbq, string_0, eRoomType_0, byte_0, 0);
					baseRoom2.ZoneId = gamePlayer_0.ZoneId;
					gamePlayer_0.Out.SendSingleRoomCreate(baseRoom2);
					baseRoom2.AddPlayerUnsafe(gamePlayer_0);
				}
			}
			else
			{
				RoomMgr.WaitingRoom.RemovePlayer(gamePlayer_0);
				gamePlayer_0.Out.SendRoomLoginResult(result: true);
				gamePlayer_0.Out.SendSingleRoomCreate(baseRoom2);
				baseRoom2.AddPlayerUnsafe(gamePlayer_0);
			}
			if (baseRoom2.PlayerCount == num)
			{
				BattleServer battleServer2 = BattleMgr.AddRoom(baseRoom2);
				if (battleServer2 != null)
				{
					baseRoom2.BattleServer = battleServer2;
					baseRoom2.IsPlaying = true;
					baseRoom2.SendStartPickUp();
				}
				else
				{
					GSPacketIn pkg2 = baseRoom2.Host.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("StartGameAction.noBattleServe"));
					baseRoom2.SendToAll(pkg2, baseRoom2.Host);
					baseRoom2.SendCancelPickUp();
				}
			}
		}

		private int method_0(int int_1)
		{
			return int_1 switch
			{
				7 => 1, 
				8 => 2, 
				9 => 3, 
				10 => 4, 
				_ => 1, 
			};
		}

		private BaseRoom method_1(BaseRoom[] baseRoom_0, int int_1)
		{
			for (int i = 0; i < baseRoom_0.Length; i++)
			{
				if (baseRoom_0[i] != null && baseRoom_0[i].RoomType == eRoomType_0 && !baseRoom_0[i].IsPlaying && baseRoom_0[i].PlayerCount < int_1 && baseRoom_0[i].RoomType == eRoomType.SingleBattle)
				{
					return baseRoom_0[i];
				}
			}
			return null;
		}
	}
}
