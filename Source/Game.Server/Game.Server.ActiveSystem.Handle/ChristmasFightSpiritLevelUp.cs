using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(25)]
	public class ChristmasFightSpiritLevelUp : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			UserChristmasInfo christmas = Player.Actives.Christmas;
			int templateId = 201144;
			int num = packet.ReadInt();
			bool flag = packet.ReadBoolean();
			int ıtemCount = Player.GetItemCount(201144);
			if (num > ıtemCount)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg3"));
				return false;
			}
			if (num > 5)
			{
				num = 5;
			}
			bool val = false;
			int num2 = num;
			int val2 = 0;
			int num3 = 10;
			if (flag && Player.MoneyDirect(GameProperties.ChristmasBuildSnowmanDoubleMoney))
			{
				num2 = num * 2;
			}
			christmas.exp += num2;
			if (christmas.exp >= num3)
			{
				christmas.exp -= num3;
				val = true;
				christmas.count++;
				val2 = 1;
			}
			Player.RemoveTemplate(templateId, num);
			gSPacketIn.WriteByte(25);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteInt(christmas.count);
			gSPacketIn.WriteInt(christmas.exp);
			gSPacketIn.WriteInt(num2);
			gSPacketIn.WriteInt(val2);
			Player.Out.SendTCP(gSPacketIn);
			return true;
		}
	}
}
