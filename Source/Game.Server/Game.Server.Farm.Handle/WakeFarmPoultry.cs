using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Farm.Handle
{
	[Attribute5(24)]
	public class WakeFarmPoultry : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			if (Player.PlayerCharacter.SpouseID == num)
			{
				Player.Farm.WakeFarmPoultry(num);
				Player.SendMessage(LanguageMgr.GetTranslation("WakeFarmPoultry.Msg1"));
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("WakeFarmPoultry.Msg2"));
			}
			return true;
		}
	}
}
