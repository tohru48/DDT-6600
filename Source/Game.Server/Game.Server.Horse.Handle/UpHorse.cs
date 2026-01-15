using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Horse.Handle
{
	[Attribute9(3)]
	public class UpHorse : IHorseCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int templateId = 11164;
			bool isHasLevelUp = false;
			bool flag = Player.Extra.UseDeed(12);
			int num2 = 0;
			ItemInfo ıtemByTemplateID = Player.PropBag.GetItemByTemplateID(0, 11164);
			if (flag)
			{
				num2 = 100;
				Player.SendMessage(LanguageMgr.GetTranslation("UpHorse.Msg"));
			}
			if (!flag && ıtemByTemplateID != null && num > 0)
			{
				if (ıtemByTemplateID.Count < num)
				{
					num = ıtemByTemplateID.Count;
				}
				num2 = ıtemByTemplateID.Template.Property2 * num;
				Player.PropBag.RemoveTemplate(templateId, num);
			}
			if (num2 > 0)
			{
				int curLevel = Player.Horse.Info.curLevel;
				int num3 = Player.Horse.Info.curExp + num2;
				Player.Horse.Info.curExp = num3;
				MountTemplateInfo mountTemplate = MountMgr.GetMountTemplate(curLevel + 1);
				if (mountTemplate != null && num3 >= mountTemplate.Experience)
				{
					isHasLevelUp = true;
					Player.Horse.Info.curLevel = mountTemplate.Grade;
					Player.PlayerCharacter.MountLv = mountTemplate.Grade;
					MountSkillDataInfo mountSkillDataInfo = Player.Horse.AddHorseSkill();
					if (mountSkillDataInfo != null)
					{
						GSPacketIn gSPacketIn = new GSPacketIn(260);
						gSPacketIn.WriteByte(4);
						gSPacketIn.WriteInt(mountSkillDataInfo.SKillID);
						gSPacketIn.WriteInt(mountSkillDataInfo.Exp);
						Player.SendTCP(gSPacketIn);
					}
					Player.EquipBag.UpdatePlayerProperties();
				}
				Player.Out.SendUpHorse(isHasLevelUp, Player.Horse.Info.curLevel, Player.Horse.Info.curExp);
			}
			return true;
		}
	}
}
