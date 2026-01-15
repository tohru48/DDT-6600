using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagpieBridge.Handle
{
	[Attribute12(3)]
	public class MagpieBridgeBuyCount : IMagpieBridgeCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			if (num <= 0)
			{
				num = 1;
			}
			if (Player.MoneyDirect(GameProperties.TanabataActivePrice * num))
			{
				Player.Extra.Info.LastNum += num;
				GSPacketIn gSPacketIn = new GSPacketIn(276, Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(Player.Extra.Info.LastNum);
				Player.SendTCP(gSPacketIn);
				Player.SendMessage(LanguageMgr.GetTranslation("MagpieBridgeBuyCount.Success"));
			}
			return false;
		}
	}
}
