using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.MagicHouse.Handle
{
	[Attribute10(3)]
	public class MagicHouseOpenFreeBox : IMagicHouseCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			if (num > 0 && Player.MagicHouse.Info.freeGetCount < Player.MagicHouse.FREEBOX_MAXCOUNT)
			{
				Player.MagicHouse.Info.freeGetTime = DateTime.Now;
				ItemInfo[] award = Player.MagicHouse.GetAward(num, eEventType.MAGIC_HOUSE_FREE);
				Player.MagicHouse.Info.freeGetCount = num;
				GSPacketIn gSPacketIn = new GSPacketIn(84, Player.PlayerId);
				gSPacketIn.WriteInt(4);
				gSPacketIn.WriteInt(4);
				gSPacketIn.WriteInt(Player.MagicHouse.Info.freeGetCount);
				gSPacketIn.WriteDateTime(Player.MagicHouse.Info.freeGetTime);
				gSPacketIn.WriteInt(award.Length);
				ItemInfo[] array = award;
				foreach (ItemInfo ıtemInfo in array)
				{
					gSPacketIn.WriteInt(ıtemInfo.TemplateID);
					gSPacketIn.WriteInt(ıtemInfo.Count);
					gSPacketIn.WriteInt(ıtemInfo.ValidDate);
					gSPacketIn.WriteBoolean(ıtemInfo.IsBinds);
					gSPacketIn.WriteInt(ıtemInfo.StrengthenLevel);
					gSPacketIn.WriteInt(ıtemInfo.AttackCompose);
					gSPacketIn.WriteInt(ıtemInfo.DefendCompose);
					gSPacketIn.WriteInt(ıtemInfo.AgilityCompose);
					gSPacketIn.WriteInt(ıtemInfo.LuckCompose);
					Player.AddTemplate(ıtemInfo);
				}
				Player.SendTCP(gSPacketIn);
				Player.MagicHouse.UpdateMessage();
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("MagicHouseOpenFreeBox.Empty"));
			}
			return false;
		}
	}
}
