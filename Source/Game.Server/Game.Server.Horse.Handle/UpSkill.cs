using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Horse.Handle
{
	[Attribute9(5)]
	public class UpSkill : IHorseCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			MountSkillDataInfo mountSkillDataInfo = Player.Horse.curHasSkill[num];
			if (mountSkillDataInfo != null)
			{
				int templateId = 11165;
				ItemInfo ıtemByTemplateID = Player.PropBag.GetItemByTemplateID(0, 11165);
				bool flag = Player.Extra.UseDeed(13);
				int num3 = 0;
				if (flag)
				{
					num3 = 10;
				}
				if (!flag && ıtemByTemplateID != null && num2 > 0)
				{
					if (ıtemByTemplateID.Count < num2)
					{
						num2 = ıtemByTemplateID.Count;
					}
					Player.PropBag.RemoveTemplate(templateId, num2);
					num3 = ıtemByTemplateID.Template.Property2 * num2;
				}
				if (num3 > 0)
				{
					int num4 = (mountSkillDataInfo.Exp += num3);
					MountSkillGetTemplateInfo[] skillGetTemplates = MountMgr.GetSkillGetTemplates(num);
					if (skillGetTemplates != null)
					{
						int num5 = -1;
						MountSkillGetTemplateInfo[] array = skillGetTemplates;
						foreach (MountSkillGetTemplateInfo mountSkillGetTemplateInfo in array)
						{
							if (num4 >= mountSkillGetTemplateInfo.Exp)
							{
								num5 = mountSkillGetTemplateInfo.SkillID;
							}
						}
						if (num5 != -1 && num5 > mountSkillDataInfo.SKillID)
						{
							mountSkillDataInfo.SKillID = num5;
							Player.Horse.UpSkill(num, mountSkillDataInfo);
						}
						GSPacketIn gSPacketIn = new GSPacketIn(260);
						gSPacketIn.WriteByte(5);
						gSPacketIn.WriteInt(num);
						gSPacketIn.WriteInt(mountSkillDataInfo.SKillID);
						gSPacketIn.WriteInt(mountSkillDataInfo.Exp);
						Player.SendTCP(gSPacketIn);
						Player.SendMessage(LanguageMgr.GetTranslation("UpSkill.Msg1", num3));
					}
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("UpSkill.Msg2", num));
			}
			return true;
		}
	}
}
