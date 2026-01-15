using Bussiness;
using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(35)]
	public class CatchbeastBuybuff : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			packet.ReadBoolean();
			if (Player.MoneyDirect(GameProperties.YearMonsterBuffMoney))
			{
				if (Player.Actives.Info.BuyBuffNum > 0)
				{
					Player.Actives.Info.BuyBuffNum--;
				}
				gSPacketIn.WriteByte(35);
				gSPacketIn.WriteInt(Player.Actives.Info.BuyBuffNum);
				Player.Out.SendTCP(gSPacketIn);
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg2"));
				BufferList.CreatePayBuffer(400, 30000, 1)?.Start(Player);
				BufferList.CreatePayBuffer(406, 30000, 1)?.Start(Player);
			}
			return true;
		}
	}
}
