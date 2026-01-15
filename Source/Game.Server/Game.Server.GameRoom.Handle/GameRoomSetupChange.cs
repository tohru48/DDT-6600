using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Rooms;
using SqlDataProvider.Data;

namespace Game.Server.GameRoom.Handle
{
	[Attribute7(2)]
	public class GameRoomSetupChange : IGameRoomCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.CurrentRoom != null && Player == Player.CurrentRoom.Host && !Player.CurrentRoom.IsPlaying)
			{
				int num = packet.ReadInt();
				eRoomType eRoomType = (eRoomType)packet.ReadByte();
				bool flag = packet.ReadBoolean();
				string pic = "";
				string password = packet.ReadString();
				string roomname = packet.ReadString();
				byte timeMode = packet.ReadByte();
				byte b = packet.ReadByte();
				int levelLimits = packet.ReadInt();
				bool isCrosszone = packet.ReadBoolean();
				packet.ReadInt();
				int bossId = 1;
				if (num == 0 && eRoomType == eRoomType.Lanbyrinth)
				{
					num = 401;
					bossId = Player.Labyrinth.currentFloor;
				}
				if (eRoomType == eRoomType.Dungeon && num != 10000)
				{
					PveInfo pveInfoById = PveInfoMgr.GetPveInfoById(num);
					if (pveInfoById != null && flag)
					{
						int price = pveInfoById.GetPrice(b);
						if (Player.Extra.UseKingBless(5))
						{
							Player.SendMessage(LanguageMgr.GetTranslation("GameRoomRoomSetupChange.UseKingBless", price));
						}
						else if (!Player.RemoveTemplate(201531, price))
						{
							Player.SendMessage(LanguageMgr.GetTranslation("GameRoomRoomSetupChange.ConditionFail", price));
							return false;
						}
					}
				}
				if (eRoomType == eRoomType.ActivityDungeon)
				{
					string format = "{0}" + LanguageMgr.GetTranslation("GameRoomRoomSetupChange.Msg3");
					BaseRoom currentRoom = Player.CurrentRoom;
					List<GamePlayer> players = currentRoom.GetPlayers();
					int num2 = 0;
					string text = "";
					foreach (GamePlayer item in players)
					{
						if (item.Actives.Info.activityTanabataNum > 0)
						{
							text = ((item.PlayerCharacter.ID != Player.PlayerCharacter.ID) ? (text + item.PlayerCharacter.NickName) : (text + LanguageMgr.GetTranslation("GameRoomRoomSetupChange.Msg4")));
							text += ",";
							num2++;
						}
					}
					if (num2 > 0)
					{
						text = text.Substring(0, text.Length - 1);
						Player.SendMessage(string.Format(format, text));
						return false;
					}
				}
				if (eRoomType == eRoomType.FarmBoss)
				{
					if (!Player.Farm.CanFight())
					{
						Player.CurrentRoom.RemovePlayerUnsafe(Player);
						return false;
					}
					Player.Farm.FarmPoultryFight(ref bossId);
				}
				RoomMgr.UpdateRoomGameType(Player.CurrentRoom, eRoomType, timeMode, (eHardLevel)b, levelLimits, num, password, roomname, isCrosszone, flag, pic, bossId);
			}
			return true;
		}
	}
}
