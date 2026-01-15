using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Farm.Handle
{
	[Attribute5(4)]
	public class GainFields : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int fieldId = packet.ReadInt();
			string msg = LanguageMgr.GetTranslation("EnterFarmHandler.Msg2");
			if (num == Player.PlayerCharacter.ID && Player.Farm.GainField(fieldId))
			{
				msg = LanguageMgr.GetTranslation("EnterFarmHandler.Msg3");
			}
			else if (num != Player.PlayerCharacter.ID)
			{
				msg = ((!Player.Farm.GainFriendFields(num, fieldId)) ? LanguageMgr.GetTranslation("EnterFarmHandler.Msg5") : LanguageMgr.GetTranslation("EnterFarmHandler.Msg4"));
			}
			Player.SendMessage(msg);
			return true;
		}
	}
}
