using System;
using System.Text.RegularExpressions;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server;
using Game.Server.GameUtils;
using Game.Server.Packets;
using Game.Server.Packets.Client;
using SqlDataProvider.Data;

internal class Class13 : IPacketHandler
{
	private static Regex regex_0;

	private static Regex regex_1;

	private static Regex regex_2;

	private static string[] string_0;

	private static int[] int_0;

	private static char[] char_0;

	public int HandlePacket(GameClient client, GSPacketIn packet)
	{
		AASInfo aASInfo = new AASInfo();
		aASInfo.UserID = client.Player.PlayerCharacter.ID;
		bool flag = false;
		bool flag2;
		if (packet.ReadBoolean())
		{
			aASInfo.Name = "";
			aASInfo.IDNumber = "";
			aASInfo.State = 0;
			flag2 = true;
		}
		else
		{
			aASInfo.Name = packet.ReadString();
			aASInfo.IDNumber = packet.ReadString();
			flag2 = method_0(aASInfo.IDNumber);
			if (aASInfo.IDNumber != "")
			{
				client.Player.Boolean_0 = true;
				int num = Convert.ToInt32(aASInfo.IDNumber.Substring(6, 4));
				int value = Convert.ToInt32(aASInfo.IDNumber.Substring(10, 2));
				if (DateTime.Now.Year.CompareTo(num + 18) > 0 || (DateTime.Now.Year.CompareTo(num + 18) == 0 && DateTime.Now.Month.CompareTo(value) >= 0))
				{
					client.Player.IsMinor = false;
				}
			}
			if (aASInfo.Name != "" && flag2)
			{
				aASInfo.State = 1;
			}
			else
			{
				aASInfo.State = 0;
			}
		}
		if (flag2)
		{
			client.Out.SendAASState(result: false);
			using ProduceBussiness produceBussiness = new ProduceBussiness();
			flag = produceBussiness.method_2(aASInfo);
			client.Out.SendAASInfoSet(flag);
		}
		if (flag && aASInfo.State == 1)
		{
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(11019);
			if (ıtemTemplateInfo != null)
			{
				ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 107);
				if (ıtemInfo != null)
				{
					ıtemInfo.IsBinds = true;
					AbstractInventory ıtemInventory = client.Player.GetItemInventory(ıtemInfo.Template);
					if (ıtemInventory.AddItem(ıtemInfo, ıtemInventory.BeginSlot))
					{
						client.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("ASSInfoSetHandle.Success", ıtemInfo.Template.Name));
					}
					else
					{
						client.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("ASSInfoSetHandle.NoPlace"));
					}
				}
			}
		}
		return 0;
	}

	private bool method_0(string string_1)
	{
		bool result = false;
		if (!regex_2.IsMatch(string_1))
		{
			return false;
		}
		int num = int.Parse(string_1.Substring(0, 2));
		if (string_0[num] == null)
		{
			return false;
		}
		if (string_1.Length == 18)
		{
			int num2 = 0;
			for (int i = 0; i < 17; i++)
			{
				num2 += int.Parse(string_1[i].ToString()) * int_0[i];
			}
			int num3 = num2 % 11;
			if (string_1[17] == char_0[num3])
			{
				result = true;
			}
		}
		return result;
	}

	static Class13()
	{
		regex_0 = new Regex("/^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$/");
		regex_1 = new Regex("/^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$/");
		regex_2 = new Regex("\\d{18}|\\d{15}");
		string_0 = new string[92]
		{
			null, null, null, null, null, null, null, null, null, null,
			null, "北京", "天津", "河北", "山西", "内蒙古", null, null, null, null,
			null, "辽宁", "吉林", "黑龙江", null, null, null, null, null, null,
			null, "上海", "江苏", "浙江", "安微", "福建", "江西", "山东", null, null,
			null, "河南", "湖北", "湖南", "广东", "广西", "海南", null, null, null,
			"重庆", "四川", "贵州", "云南", "西藏", null, null, null, null, null,
			null, "陕西", "甘肃", "青海", "宁夏", "新疆", null, null, null, null,
			null, "台湾", null, null, null, null, null, null, null, null,
			null, "香港", "澳门", null, null, null, null, null, null, null,
			null, "国外"
		};
		int_0 = new int[17]
		{
			7, 9, 10, 5, 8, 4, 2, 1, 6, 3,
			7, 9, 10, 5, 8, 4, 2
		};
		char_0 = new char[11]
		{
			'1', '0', 'X', '9', '8', '7', '6', '5', '4', '3',
			'2'
		};
	}
}
