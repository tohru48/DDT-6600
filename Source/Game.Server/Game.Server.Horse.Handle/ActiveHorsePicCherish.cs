using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Horse.Handle
{
	[Attribute9(7)]
	public class ActiveHorsePicCherish : IHorseCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int place = packet.ReadInt();
			ItemInfo ıtemAt = Player.GetItemAt(eBageType.PropBag, place);
			if (ıtemAt != null)
			{
				MountDrawTemplateInfo mountDrawTemplateInfo = MountMgr.FindMountDrawByTemplate(ıtemAt.TemplateID);
				if (mountDrawTemplateInfo == null)
				{
					Player.SendMessage(LanguageMgr.GetTranslation("PicCherishInfo.Msg1"));
				}
				else
				{
					Player.PlayerCharacter.MountsType = mountDrawTemplateInfo.ID;
					Player.Horse.Info.curUseHorse = mountDrawTemplateInfo.ID;
					Player.Horse.ActiveHorsePicCherish(mountDrawTemplateInfo.ID);
					GSPacketIn gSPacketIn = new GSPacketIn(260);
					gSPacketIn.WriteByte(7);
					gSPacketIn.WriteInt(mountDrawTemplateInfo.ID);
					gSPacketIn.WriteInt(1);
					Player.SendTCP(gSPacketIn);
					Player.Out.SendchangeHorse(mountDrawTemplateInfo.ID);
					Player.SendMessage(LanguageMgr.GetTranslation("PicCherishInfo.Msg2", mountDrawTemplateInfo.Name));
					Player.RemoveTemplate(ıtemAt.TemplateID, 1);
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("PicCherishInfo.Msg1"));
			}
			return true;
		}
	}
}
