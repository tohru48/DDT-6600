using System;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(209, "场景用户离开")]
	public class FigSpiritUpGradeHandler : IPacketHandler
	{
		private static readonly string[] string_0;

		private static readonly int[] int_0;

		private int method_0(int int_1, int int_2)
		{
			int num = int_0[int_2 + 1];
			return num - int_1;
		}

		private bool method_1(string[] string_1)
		{
			int num = 0;
			if (string_1[0].Split(',')[0] == "5")
			{
				num = 1;
			}
			if (string_1[1].Split(',')[0] == "5")
			{
				num = 2;
			}
			if (string_1[2].Split(',')[0] == "5")
			{
				num = 3;
			}
			return num == 3;
		}

		private int[] method_2(string[] string_1)
		{
			int[] array = new int[string_1.Length];
			for (int i = 0; i < string_1.Length; i++)
			{
				array[i] = Convert.ToInt32(string_1[i].Split(',')[0]);
			}
			return array;
		}

		private int[] method_3(string[] string_1)
		{
			int[] array = new int[string_1.Length];
			for (int i = 0; i < string_1.Length; i++)
			{
				array[i] = Convert.ToInt32(string_1[i].Split(',')[1]);
			}
			return array;
		}

		private bool method_4(int int_1, int int_2)
		{
			return (int_1 >= int_0[1] && int_2 == 0) || (int_1 >= int_0[2] && int_2 == 1) || (int_1 >= int_0[3] && int_2 == 2) || (int_1 >= int_0[4] && int_2 == 3) || (int_1 >= int_0[5] && int_2 == 4);
		}

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.PlayerCharacter.Grade < 30)
			{
				return 0;
			}
			packet.ReadByte();
			int num = packet.ReadInt();
			packet.ReadInt();
			packet.ReadInt();
			int templateId = packet.ReadInt();
			int figSpiritId = packet.ReadInt();
			int place = packet.ReadInt();
			packet.ReadInt();
			packet.ReadInt();
			ItemInfo ıtemByTemplateID = client.Player.PropBag.GetItemByTemplateID(0, templateId);
			int ıtemCount = client.Player.PropBag.GetItemCount(templateId);
			UserGemStone gemStone = client.Player.GetGemStone(place);
			string[] string_ = gemStone.FigSpiritIdValue.Split('|');
			int ıD = client.Player.PlayerCharacter.ID;
			bool flag = false;
			bool flag2 = method_1(string_);
			bool isFall = true;
			int num2 = 1;
			int dir = 0;
			int[] array = method_3(string_);
			int[] array2 = method_2(string_);
			if (ıtemCount <= 0 || ıtemByTemplateID == null)
			{
				client.Player.Out.SendPlayerFigSpiritUp(ıD, gemStone, flag, flag2, isFall, 0, dir);
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("FigSpiritUpGradeHandler.Msg"));
				return 0;
			}
			if (!ıtemByTemplateID.isGemStone())
			{
				client.Player.Out.SendPlayerFigSpiritUp(ıD, gemStone, flag, flag2, isFall, 0, dir);
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("FigSpiritUpGradeHandler.Msg"));
				return 0;
			}
			if (!flag2 && ıtemByTemplateID != null)
			{
				if (num == 0)
				{
					int property = ıtemByTemplateID.Template.Property2;
					for (int i = 0; i < string_0.Length; i++)
					{
						if (array2[i] < 5)
						{
							array[i] += property;
							if (flag = method_4(array[i], array2[i]))
							{
								array2[i]++;
								array[i] = 0;
							}
						}
					}
					client.Player.PropBag.RemoveCountFromStack(ıtemByTemplateID, 1);
				}
				if (num == 1)
				{
					int num3 = 1;
					for (int j = 0; j < string_0.Length; j++)
					{
						num3 = method_0(array[j], array2[j]) / ıtemByTemplateID.Template.Property2;
						if (ıtemCount < num3)
						{
							num3 = ıtemCount;
						}
						int num4 = ıtemByTemplateID.Template.Property2 * num3;
						if (array2[j] < 5)
						{
							array[j] += num4;
							if (flag = method_4(array[j], array2[j]))
							{
								array2[j]++;
								array[j] = 0;
							}
						}
					}
					client.Player.PropBag.RemoveTemplate(templateId, num3);
				}
			}
			if (flag)
			{
				isFall = false;
				dir = 1;
				client.Player.EquipBag.UpdatePlayerProperties();
			}
			string text = array2[0] + "," + array[0] + "," + string_0[0];
			for (int k = 1; k < string_0.Length; k++)
			{
				object obj = text;
				text = string.Concat(obj, "|", array2[k], ",", array[k], ",", string_0[k]);
			}
			gemStone.FigSpiritId = figSpiritId;
			gemStone.FigSpiritIdValue = text;
			client.Player.UpdateGemStone(place, gemStone);
			client.Player.OnUserToemGemstoneEvent(2);
			client.Player.Out.SendPlayerFigSpiritUp(ıD, gemStone, flag, flag2, isFall, num2, dir);
			return 0;
		}

		static FigSpiritUpGradeHandler()
		{
			string_0 = new string[3] { "0", "1", "2" };
			int_0 = new int[6] { 0, 600, 5220, 15840, 39020, 89580 };
		}
	}
}
