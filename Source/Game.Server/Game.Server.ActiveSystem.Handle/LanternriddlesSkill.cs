using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(41)]
	public class LanternriddlesSkill : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			packet.ReadInt();
			packet.ReadInt();
			int num = packet.ReadInt();
			packet.ReadBoolean();
			LanternriddlesInfo lanternriddles = ActiveSystemMgr.GetLanternriddles(Player.PlayerCharacter.ID);
			if (lanternriddles == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg9"));
				return false;
			}
			bool flag = false;
			if (num == 0)
			{
				if (lanternriddles.HitFreeCount > 0)
				{
					lanternriddles.HitFreeCount--;
					lanternriddles.IsHint = true;
					flag = true;
				}
				else
				{
					int hitPrice = lanternriddles.HitPrice;
					if (Player.ActiveMoneyEnable(hitPrice))
					{
						lanternriddles.IsHint = true;
						flag = true;
					}
				}
			}
			else if (lanternriddles.DoubleFreeCount > 0)
			{
				lanternriddles.DoubleFreeCount--;
				lanternriddles.IsDouble = true;
				flag = true;
			}
			else
			{
				int hitPrice = lanternriddles.DoublePrice;
				if (Player.ActiveMoneyEnable(hitPrice))
				{
					lanternriddles.IsDouble = true;
					flag = true;
				}
			}
			if (flag)
			{
				gSPacketIn.WriteByte(41);
				gSPacketIn.WriteBoolean(flag);
				Player.Out.SendTCP(gSPacketIn);
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg2"));
			}
			return true;
		}
	}
}
