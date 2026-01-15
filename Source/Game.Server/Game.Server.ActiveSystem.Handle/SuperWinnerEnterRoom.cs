using System;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(49)]
	public class SuperWinnerEnterRoom : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(49);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteString(Player.PlayerCharacter.NickName);
			gSPacketIn.WriteBoolean(Player.PlayerCharacter.typeVIP == 1);
			gSPacketIn.WriteBoolean(Player.PlayerCharacter.Sex);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteByte((byte)Player.PlayerCharacter.Grade);
			gSPacketIn.WriteByte(32);
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteByte(8);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteDateTime(DateTime.Now.AddDays(7.0));
			gSPacketIn.WriteInt(1);
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}
	}
}
