using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(63, "打开物品")]
	public class OpenUpArkHandler : IPacketHandler
	{
		public static readonly ILog log;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int bageType = packet.ReadByte();
			int slot = packet.ReadInt();
			int num = packet.ReadInt();
			PlayerInventory ınventory = client.Player.GetInventory((eBageType)bageType);
			ItemInfo ıtemAt = ınventory.GetItemAt(slot);
			GSPacketIn gSPacketIn = packet.Clone();
			gSPacketIn.ClearContext();
			if (ıtemAt != null && ıtemAt.IsValidItem() && ıtemAt.Template.CategoryID == 11 && ıtemAt.Template.Property1 == 6 && client.Player.PlayerCharacter.Grade >= ıtemAt.Template.NeedLevel)
			{
				if (num < 1 || num > ıtemAt.Count)
				{
					num = ıtemAt.Count;
				}
				StringBuilder stringBuilder = new StringBuilder();
				StringBuilder stringBuilder2 = new StringBuilder();
				if (!ınventory.RemoveCountFromStack(ıtemAt, num))
				{
					return 0;
				}
				Dictionary<int, ItemInfo> dictionary = new Dictionary<int, ItemInfo>();
				stringBuilder2.Append(LanguageMgr.GetTranslation("OpenUpArkHandler.Start"));
				for (int i = 0; i < num; i++)
				{
					SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
					List<ItemInfo> list = new List<ItemInfo>();
					ItemBoxMgr.CreateItemBox(ıtemAt.TemplateID, list, ref specialValue);
					client.Player.DirectAddValue(specialValue);
					foreach (ItemInfo item in list)
					{
						if (!dictionary.Keys.Contains(item.TemplateID))
						{
							dictionary.Add(item.TemplateID, item);
						}
						else
						{
							dictionary[item.TemplateID].Count += item.Count;
						}
					}
				}
				if (stringBuilder.Length > 0)
				{
					stringBuilder.Remove(stringBuilder.Length - 1, 1);
					string[] array = stringBuilder.ToString().Split(',');
					for (int j = 0; j < array.Length; j++)
					{
						int num2 = 1;
						for (int k = j + 1; k < array.Length; k++)
						{
							if (array[j].Contains(array[k]) && array[k].Length == array[j].Length)
							{
								num2++;
								array[k] = k.ToString();
							}
						}
						if (num2 > 1)
						{
							array[j] = array[j].Remove(array[j].Length - 1, 1);
							string[] array3;
							string[] array2 = (array3 = array);
							int num3 = j;
							nint num4 = num3;
							array2[num3] = array3[num4] + num2;
						}
						if (array[j] != j.ToString())
						{
							string[] array3;
							string[] array4 = (array3 = array);
							int num5 = j;
							nint num4 = num5;
							array4[num5] = array3[num4] + ",";
							stringBuilder2.Append(array[j]);
						}
					}
				}
				stringBuilder2.Remove(stringBuilder2.Length - 1, 1);
				stringBuilder2.Append(".");
				gSPacketIn.WriteString(ıtemAt.Template.Name);
				gSPacketIn.WriteByte((byte)dictionary.Count);
				foreach (ItemInfo value in dictionary.Values)
				{
					gSPacketIn.WriteInt(value.TemplateID);
					gSPacketIn.WriteInt(value.Count);
					gSPacketIn.WriteBoolean(value.IsBinds);
					gSPacketIn.WriteInt(value.ValidDate);
					gSPacketIn.WriteInt(value.StrengthenLevel);
					gSPacketIn.WriteInt(value.AttackCompose);
					gSPacketIn.WriteInt(value.DefendCompose);
					gSPacketIn.WriteInt(value.AgilityCompose);
					gSPacketIn.WriteInt(value.LuckCompose);
					gSPacketIn.WriteInt(value.MagicAttack);
					gSPacketIn.WriteInt(value.MagicDefence);
					if (value.Template.MaxCount == 1)
					{
						for (int l = 0; l < value.Count; l++)
						{
							ItemInfo ıtemInfo = value.Clone();
							ıtemInfo.Count = 1;
							client.Player.AddTemplate(ıtemInfo, value.Template.BagType, ıtemInfo.Count, eGameView.OtherTypeGet, ıtemAt.Template.Name);
						}
					}
					else
					{
						client.Player.AddTemplate(value, value.Template.BagType, value.Count, eGameView.OtherTypeGet, ıtemAt.Template.Name);
					}
				}
				if (dictionary.Count > 0)
				{
					client.Player.SendTCP(gSPacketIn);
				}
			}
			return 1;
		}

		static OpenUpArkHandler()
		{
			log = LogManager.GetLogger("FlashErrorLogger");
		}
	}
}
