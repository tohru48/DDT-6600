using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Rooms;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(140)]
	public class CatchInsectFightMonter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			BaseCatchInsectRoom catchInsectRoom = RoomMgr.CatchInsectRoom;
			int num = packet.ReadInt();
			if (Player.MainWeapon == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip"));
				return false;
			}
			if (catchInsectRoom.SetFightMonter(num, Player.PlayerCharacter.ID))
			{
				MonterInfo monterInfo = catchInsectRoom.Monters[num];
				gSPacketIn.WriteByte(133);
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(monterInfo.state);
				catchInsectRoom.method_1(gSPacketIn);
				RoomMgr.CreateRoom(Player, "CatchInsect", "sff343sfgh", eRoomType.CatchInsect, 3);
				if (Player.RemoveTemplate(11958, 1))
				{
					Player.UpdateBatleConfig("CatchInsect", 1);
				}
				else
				{
					Player.UpdateBatleConfig("CatchInsect", 0);
				}
			}
			return true;
		}
	}
}
