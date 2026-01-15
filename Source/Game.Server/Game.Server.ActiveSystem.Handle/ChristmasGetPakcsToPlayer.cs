using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(27)]
	public class ChristmasGetPakcsToPlayer : IActiveSystemCommandHadler
	{
		public static ThreadSafeRandom random;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			UserChristmasInfo christmas = Player.Actives.Christmas;
			string title = "Event Noel";
			byte b = packet.ReadByte();
			int[] array = new int[2] { 201146, 201147 };
			int num = random.Next(array.Length);
			if (DateTime.Compare(Player.LastOpenChristmasPackage.AddSeconds(1.0), DateTime.Now) > 0)
			{
				return false;
			}
			if (b == 1 && christmas.dayPacks < 2)
			{
				christmas.dayPacks++;
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg4"));
				Player.SendItemToMail(array[num], "", title);
			}
			else if (christmas.count < 3)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg5"));
			}
			else
			{
				gSPacketIn.WriteByte(27);
				gSPacketIn.WriteBoolean(val: true);
				gSPacketIn.WriteInt(christmas.dayPacks);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				Player.Out.SendTCP(gSPacketIn);
			}
			Player.LastOpenChristmasPackage = DateTime.Now;
			return true;
		}

		static ChristmasGetPakcsToPlayer()
		{
			random = new ThreadSafeRandom();
		}
	}
}
