using System;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(99, "场景用户离开")]
	public class TexpHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int templateId = packet.ReadInt();
			int num2 = packet.ReadInt();
			int slot = packet.ReadInt();
			ItemInfo ıtemAt = client.Player.StoreBag.GetItemAt(slot);
			TexpInfo texp = client.Player.PlayerCharacter.Texp;
			if (ıtemAt == null || texp == null)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("texpSystem.Error"));
				return 0;
			}
			if (!ıtemAt.isTexp())
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("texpSystem.Error"));
				return 0;
			}
			if (texp.texpCount <= client.Player.PlayerCharacter.Grade)
			{
				if (num2 + texp.texpCount >= client.Player.PlayerCharacter.Grade)
				{
					num2 = client.Player.PlayerCharacter.Grade - texp.texpCount;
				}
				switch (num)
				{
				case 0:
					texp.hpTexpExp += ıtemAt.Template.Property2 * num2;
					break;
				case 1:
					texp.attTexpExp += ıtemAt.Template.Property2 * num2;
					break;
				case 2:
					texp.defTexpExp += ıtemAt.Template.Property2 * num2;
					break;
				case 3:
					texp.spdTexpExp += ıtemAt.Template.Property2 * num2;
					break;
				case 4:
					texp.lukTexpExp += ıtemAt.Template.Property2 * num2;
					break;
				}
				texp.texpCount += num2;
				texp.texpTaskCount++;
				texp.texpTaskDate = DateTime.Now;
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					playerBussiness.UpdateUserTexpInfo(texp);
				}
				client.Player.PlayerCharacter.Texp = texp;
				client.Player.StoreBag.RemoveTemplate(templateId, num2);
				client.Player.EquipBag.UpdatePlayerProperties();
			}
			else
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("texpSystem.texpCountToplimit"));
			}
			return 0;
		}
	}
}
