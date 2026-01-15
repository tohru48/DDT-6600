using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.MagpieBridge.Handle
{
	[Attribute12(2)]
	public class MagpieBridgeRollDice : IMagpieBridgeCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			bool isRemindRollBind = packet.ReadBoolean();
			if (Player.Extra.Info.LastNum > 0)
			{
				Player.Extra.Info.LastNum--;
				Player.Extra.MagpieBridgeRollDiceCallBack(isRemindRollBind);
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("MagpieBridgeRollDice.Fail"));
			}
			return false;
		}
	}
}
