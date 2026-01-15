using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(77)]
	public class DDPLayExchange : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = GameProperties.ExchangeFold * num;
			if (num2 > Player.Actives.Info.Int32_0)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("DDPLayExchange.NotEnoughtPoint"));
			}
			else
			{
				Player.Actives.Info.Int32_0 -= num2;
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(201310);
				if (ıtemTemplateInfo != null)
				{
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
					ıtemInfo.IsBinds = true;
					ıtemInfo.Count = num;
					Player.AddTemplate(ıtemInfo);
					Player.SendMessage(LanguageMgr.GetTranslation("DDPLayExchange.Success"));
				}
				GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(75);
				gSPacketIn.WriteInt(Player.Actives.Info.Int32_0);
				Player.Out.SendTCP(gSPacketIn);
			}
			return true;
		}
	}
}
