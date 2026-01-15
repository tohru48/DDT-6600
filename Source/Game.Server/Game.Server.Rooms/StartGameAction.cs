using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Battle;
using Game.Server.GameObjects;
using Game.Server.Games;
using Game.Server.Packets;
using Game.Server.RingStation;

namespace Game.Server.Rooms
{
	public class StartGameAction : IAction
	{
		private BaseRoom baseRoom_0;

		public StartGameAction(BaseRoom room)
		{
			baseRoom_0 = room;
		}

		public void Execute()
		{
			if (!baseRoom_0.CanStart())
			{
				return;
			}
			baseRoom_0.StartWithNpc = false;
			baseRoom_0.PickUpNpcId = -1;
			List<GamePlayer> players = baseRoom_0.GetPlayers();
			if (baseRoom_0.RoomType == eRoomType.Freedom)
			{
				List<IGamePlayer> list = new List<IGamePlayer>();
				List<IGamePlayer> list2 = new List<IGamePlayer>();
				foreach (GamePlayer item in players)
				{
					if (item != null)
					{
						if (item.CurrentRoomTeam == 1)
						{
							list.Add(item);
						}
						else
						{
							list2.Add(item);
						}
					}
				}
				BaseGame baseGame_ = GameMgr.StartPVPGame(baseRoom_0.RoomId, list, list2, baseRoom_0.MapId, baseRoom_0.RoomType, baseRoom_0.GameType, baseRoom_0.TimeMode);
				method_0(baseGame_);
			}
			else if (method_2(baseRoom_0.RoomType))
			{
				List<IGamePlayer> list3 = new List<IGamePlayer>();
				foreach (GamePlayer item2 in players)
				{
					if (item2 != null)
					{
						list3.Add(item2);
					}
				}
				method_3();
				BaseGame baseGame_2 = GameMgr.StartPVEGame(baseRoom_0.RoomId, list3, baseRoom_0.MapId, baseRoom_0.RoomType, baseRoom_0.GameType, baseRoom_0.TimeMode, baseRoom_0.HardLevel, baseRoom_0.LevelLimits, baseRoom_0.currentFloor);
				method_0(baseGame_2);
			}
			else if (method_1(baseRoom_0.RoomType))
			{
				baseRoom_0.UpdateAvgLevel();
				if (baseRoom_0.RoomType == eRoomType.Match && baseRoom_0.GetPlayers().Count == 1 && baseRoom_0.Host != null)
				{
					if (baseRoom_0.Host.PlayerCharacter.Grade <= 10)
					{
						baseRoom_0.StartWithNpc = true;
						baseRoom_0.PickUpNpcId = RingStationMgr.GetAutoBot(baseRoom_0.Host, (int)baseRoom_0.RoomType, (int)baseRoom_0.GameType);
					}
					else
					{
						baseRoom_0.PickUpNpcId = RingStationConfiguration.NextPlayerID();
					}
				}
				BattleServer battleServer = BattleMgr.AddRoom(baseRoom_0);
				if (battleServer != null)
				{
					baseRoom_0.BattleServer = battleServer;
					baseRoom_0.IsPlaying = true;
					baseRoom_0.SendStartPickUp();
				}
				else
				{
					GSPacketIn pkg = baseRoom_0.Host.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("StartGameAction.noBattleServe"));
					baseRoom_0.SendToAll(pkg, baseRoom_0.Host);
					baseRoom_0.SendCancelPickUp();
				}
			}
			RoomMgr.WaitingRoom.SendUpdateCurrentRoom(baseRoom_0);
		}

		private void method_0(BaseGame baseGame_0)
		{
			if (baseGame_0 != null)
			{
				baseRoom_0.IsPlaying = true;
				baseRoom_0.StartGame(baseGame_0);
			}
			else
			{
				baseRoom_0.IsPlaying = false;
				baseRoom_0.SendPlayerState();
			}
		}

		private bool method_1(eRoomType eRoomType_0)
		{
			switch (eRoomType_0)
			{
			default:
				return false;
			case eRoomType.Match:
			case eRoomType.Entertainment:
			case eRoomType.EntertainmentPK:
				return true;
			}
		}

		private bool method_2(eRoomType eRoomType_0)
		{
			if (eRoomType_0 <= eRoomType.SpecialActivityDungeon)
			{
				switch (eRoomType_0)
				{
				case eRoomType.Dungeon:
				case eRoomType.FightLib:
					return true;
				case eRoomType.Freshman:
				case eRoomType.AcademyDungeon:
				case eRoomType.WordBossFight:
				case eRoomType.Lanbyrinth:
				case eRoomType.ConsortiaBoss:
					return true;
				case eRoomType.ActivityDungeon:
				case eRoomType.SpecialActivityDungeon:
					return true;
				}
			}
			else
			{
				if (eRoomType_0 == eRoomType.FarmBoss || eRoomType_0 == eRoomType.Christmas)
				{
					return true;
				}
				if (eRoomType_0 == eRoomType.CatchInsect)
				{
					return true;
				}
			}
			return false;
		}

		private void method_3()
		{
			if (method_2(baseRoom_0.RoomType))
			{
				switch (baseRoom_0.HardLevel)
				{
				case eHardLevel.Easy:
					baseRoom_0.TimeMode = 3;
					break;
				case eHardLevel.Normal:
					baseRoom_0.TimeMode = 2;
					break;
				case eHardLevel.Hard:
					baseRoom_0.TimeMode = 1;
					break;
				case eHardLevel.Terror:
					baseRoom_0.TimeMode = 1;
					break;
				case eHardLevel.Epic:
					baseRoom_0.TimeMode = 1;
					break;
				case eHardLevel.Nightmare:
					baseRoom_0.TimeMode = 1;
					break;
				}
			}
		}
	}
}
