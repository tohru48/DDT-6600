using System.Collections.Generic;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(36)]
	public class CatchbeastGetAward : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			int num = packet.ReadInt();
			string[] array = GameProperties.YearMonsterBoxInfo.Split('|');
			bool val;
			if (val = method_0(Player.Actives.Info.DamageNum, num, array))
			{
				int dateId = int.Parse(array[num].Split(',')[0]);
				gSPacketIn.WriteByte(36);
				gSPacketIn.WriteBoolean(val);
				gSPacketIn.WriteInt(num);
				Player.Out.SendTCP(gSPacketIn);
				Player.Actives.SetYearMonterBoxState(num);
				List<ItemInfo> list = new List<ItemInfo>();
				SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
				ItemBoxMgr.CreateItemBox(dateId, list, ref specialValue);
				StringBuilder stringBuilder = new StringBuilder();
				foreach (ItemInfo item in list)
				{
					stringBuilder.Append(item.Template.Name + " x" + item.Count + ", ");
				}
				Player.Out.SendMessage(eMessageType.Normal, stringBuilder.ToString());
				Player.AddTemplate(list);
			}
			return true;
		}

		private bool method_0(int int_0, int int_1, string[] string_0)
		{
			if (int_1 <= 4 && int_1 >= 0)
			{
				int num = int.Parse(string_0[int_1].Split(',')[1]) * 10000;
				return num <= int_0;
			}
			return false;
		}
	}
}
