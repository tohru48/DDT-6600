using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(22)]
	public class ChristmasFightMonster : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			BaseChristmasRoom christmasRoom = RoomMgr.ChristmasRoom;
			int num = packet.ReadInt();
			if (Player.MainWeapon == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip"));
				return false;
			}
			if (!Player.Actives.AvailTime())
			{
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg1"));
				return false;
			}
			if (christmasRoom.SetFightMonter(num, Player.PlayerCharacter.ID))
			{
				MonterInfo monterInfo = christmasRoom.Monters[num];
				gSPacketIn.WriteByte(22);
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(monterInfo.state);
				christmasRoom.method_1(gSPacketIn);
				RoomMgr.CreateRoom(Player, "Christmas", "Cfcs151df166s", eRoomType.Christmas, 3);
			}
			return true;
		}
	}
}
