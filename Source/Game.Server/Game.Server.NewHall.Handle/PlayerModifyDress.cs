using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.NewHall.Handle
{
	[Attribute13(5)]
	public class PlayerModifyDress : INewHallCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(262);
			gSPacketIn.WriteByte(5);
			gSPacketIn.WriteInt(Player.PlayerCharacter.ID);
			gSPacketIn.WriteString(Player.PlayerCharacter.NickName);
			gSPacketIn.WriteInt(Player.PlayerCharacter.VIPLevel);
			gSPacketIn.WriteInt(Player.PlayerCharacter.typeVIP);
			gSPacketIn.WriteBoolean(Player.PlayerCharacter.Sex);
			gSPacketIn.WriteString(Player.PlayerCharacter.Style);
			gSPacketIn.WriteString(Player.PlayerCharacter.Colors);
			gSPacketIn.WriteInt(Player.PlayerCharacter.MountsType);
			gSPacketIn.WriteInt(Player.PlayerCharacter.PetsID);
			gSPacketIn.WriteInt(Player.PosX);
			gSPacketIn.WriteInt(Player.PosY);
			gSPacketIn.WriteInt(Player.PlayerCharacter.ConsortiaID);
			gSPacketIn.WriteInt(Player.PlayerCharacter.badgeID);
			gSPacketIn.WriteString(Player.PlayerCharacter.ConsortiaName);
			gSPacketIn.WriteString(Player.PlayerCharacter.Honor);
			gSPacketIn.WriteInt(Player.PlayerCharacter.honorId);
			WorldMgr.NewHallRooms.method_1(gSPacketIn, Player);
			return true;
		}
	}
}
