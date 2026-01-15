using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(75)]
	public class DDPLayEnter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.Actives.LoadDDPlayFromDatabase())
			{
				GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(75);
				gSPacketIn.WriteInt(Player.Actives.Info.Int32_0);
				Player.Out.SendTCP(gSPacketIn);
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("DDPLayEnter.LoadDataFail"));
			}
			return true;
		}
	}
}
