using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.DragonBoat;

namespace Game.Server.Packets.Client
{
	[PacketHandler(136, "场景用户离开")]
	public class OpenOneTotemHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.PlayerCharacter.Grade < 20)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("OpenOneTotemHandler.Msg1"));
				return 0;
			}
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 1;
			}
			int totemId = client.Player.PlayerCharacter.totemId;
			int num = TotemMgr.FindTotemInfo(totemId).ConsumeExp;
			int consumeHonor = TotemMgr.FindTotemInfo(totemId).ConsumeHonor;
			int num2 = DragonBoatMgr.ReduceToemUpGrace();
			if (num2 > 0)
			{
				num -= num * num2 / 100;
			}
			if (client.Player.PlayerCharacter.myHonor >= consumeHonor)
			{
				if (client.Player.MoneyDirect(num))
				{
					if (totemId == 0)
					{
						client.Player.AddTotem(10001);
					}
					else
					{
						client.Player.AddTotem(1);
					}
					client.Player.AddExpVip(num);
					client.Player.RemovemyHonor(consumeHonor);
					client.Player.Out.SendPlayerRefreshTotem(client.Player.PlayerCharacter);
					client.Player.EquipBag.UpdatePlayerProperties();
					client.Player.OnUserToemGemstoneEvent(1);
				}
			}
			else
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("OpenOneTotemHandler.Msg2"));
			}
			return 0;
		}
	}
}
