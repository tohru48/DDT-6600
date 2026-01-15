using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(133, "场景用户离开")]
	public class LatentEnergyHandler : IPacketHandler
	{
		public static ThreadSafeRandom random;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadByte();
			int num2 = packet.ReadInt();
			int place = packet.ReadInt();
			ItemInfo ıtemAt = client.Player.GetItemAt((eBageType)num2, place);
			if (!ıtemAt.CanLatentEnergy())
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("LatentEnergyHandler.Msg1"));
				return 0;
			}
			PlayerInventory ınventory = client.Player.GetInventory((eBageType)num2);
			string translation = LanguageMgr.GetTranslation("LatentEnergyHandler.Msg2");
			GSPacketIn gSPacketIn = new GSPacketIn(133, client.Player.PlayerCharacter.ID);
			if (num == 1)
			{
				int num3 = packet.ReadInt();
				int place2 = packet.ReadInt();
				ItemInfo ıtemAt2 = client.Player.GetItemAt((eBageType)num3, place2);
				if (ıtemAt2 == null || ıtemAt2.Count < 1)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("LatentEnergyHandler.Msg3"));
					return 0;
				}
				int num4 = int.Parse(ıtemAt.latentEnergyCurStr.Split(',')[0]);
				ItemTemplateInfo template = ıtemAt2.Template;
				if (ıtemAt.IsValidLatentEnergy() || num4 >= template.Property3 - 5 || num4 <= template.Property2 - 5)
				{
					ıtemAt.ResetLatentEnergy();
				}
				string text = random.Next(template.Property2, template.Property3).ToString();
				for (int i = 1; i < 4; i++)
				{
					text = text + "," + random.Next(template.Property2, template.Property3);
				}
				if (ıtemAt.latentEnergyCurStr.Split(',')[0] == "0")
				{
					ıtemAt.latentEnergyCurStr = text;
				}
				ıtemAt.latentEnergyNewStr = text;
				ıtemAt.latentEnergyEndTime = DateTime.Now.AddDays(7.0);
				PlayerInventory ınventory2 = client.Player.GetInventory((eBageType)num3);
				ınventory2.RemoveCountFromStack(ıtemAt2, 1);
			}
			else
			{
				ıtemAt.latentEnergyCurStr = ıtemAt.latentEnergyNewStr;
				translation = LanguageMgr.GetTranslation("LatentEnergyHandler.Msg4");
			}
			gSPacketIn.WriteInt(ıtemAt.Place);
			gSPacketIn.WriteString(ıtemAt.latentEnergyCurStr);
			gSPacketIn.WriteString(ıtemAt.latentEnergyNewStr);
			gSPacketIn.WriteDateTime(ıtemAt.latentEnergyEndTime);
			ıtemAt.IsBinds = true;
			ınventory.UpdateItem(ıtemAt);
			client.Player.EquipBag.UpdatePlayerProperties();
			client.Out.SendTCP(gSPacketIn);
			client.Player.SendMessage(translation);
			return 0;
		}

		static LatentEnergyHandler()
		{
			random = new ThreadSafeRandom();
		}
	}
}
