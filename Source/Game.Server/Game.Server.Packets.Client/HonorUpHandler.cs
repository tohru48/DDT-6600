using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(96, "场景用户离开")]
	public class HonorUpHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadByte();
			packet.ReadBoolean();
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			int num2 = num;
			if (num2 == 2)
			{
				int ıD = client.Player.PlayerCharacter.MaxBuyHonor + 1;
				TotemHonorTemplateInfo totemHonorTemplateInfo = TotemHonorMgr.FindTotemHonorTemplateInfo(ıD);
				if (totemHonorTemplateInfo == null)
				{
					return 0;
				}
				int needMoney = totemHonorTemplateInfo.NeedMoney;
				int addHonor = totemHonorTemplateInfo.AddHonor;
				if (client.Player.MoneyDirect(needMoney))
				{
					client.Player.AddHonor(addHonor);
					client.Player.AddMaxHonor(1);
					client.Player.AddExpVip(needMoney);
				}
			}
			client.Player.Out.SendUpdateUpCount(client.Player.PlayerCharacter);
			return 0;
		}
	}
}
