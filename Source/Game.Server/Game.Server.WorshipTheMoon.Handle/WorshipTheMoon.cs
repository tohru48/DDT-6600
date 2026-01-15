using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.WorshipTheMoon.Handle
{
	[Attribute16(3)]
	public class WorshipTheMoon : IWorshipTheMoonCommandHadler
	{
		private static ThreadSafeRandom threadSafeRandom_0;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			packet.ReadBoolean();
			if (num <= 0)
			{
				return false;
			}
			int num2 = int.Parse(GameProperties.WorshipMoonPriceInfo.Split('|')[1]);
			int num3 = num * num2;
			int updateFreeCounts = Player.Actives.Info.updateFreeCounts;
			if (updateFreeCounts > 0)
			{
				num3 = ((num != 1) ? (num3 - updateFreeCounts * num2) : (num3 - num2));
			}
			if (Player.MoneyDirect(num3))
			{
				if (updateFreeCounts > 0)
				{
					if (num == 1)
					{
						Player.Actives.Info.updateFreeCounts--;
					}
					else
					{
						Player.Actives.Info.updateFreeCounts -= updateFreeCounts;
					}
				}
				Player.Actives.Info.updateWorshipedCounts += num;
				List<ItemInfo> list = new List<ItemInfo>();
				GSPacketIn gSPacketIn = new GSPacketIn(281);
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(num);
				for (int i = 0; i < num; i++)
				{
					int int_ = method_0();
					int num4 = method_1(int_);
					gSPacketIn.WriteInt(method_0());
					gSPacketIn.WriteInt(num4);
					ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(num4);
					if (ıtemTemplateInfo != null)
					{
						ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 105);
						ıtemInfo.IsBinds = true;
						list.Add(ıtemInfo);
					}
				}
				Player.AddTemplate(list);
				Player.SendTCP(gSPacketIn);
				Player.Actives.SendUpdateFreeCount();
			}
			return false;
		}

		private int method_0()
		{
			List<int> list = new List<int>();
			string[] array = GameProperties.WorshipMoonProb.Split('|');
			int num = int.Parse(array[5]) + int.Parse(array[4]) + int.Parse(array[3]) + int.Parse(array[2]) + int.Parse(array[1]) + int.Parse(array[0]);
			for (int i = 0; i < num; i++)
			{
				if (i < int.Parse(array[5]))
				{
					list.Add(6);
				}
				if (i < int.Parse(array[5]) + int.Parse(array[4]))
				{
					list.Add(5);
				}
				if (i < int.Parse(array[5]) + int.Parse(array[4]) + int.Parse(array[3]))
				{
					list.Add(4);
				}
				if (i < int.Parse(array[5]) + int.Parse(array[4]) + int.Parse(array[3]) + int.Parse(array[2]))
				{
					list.Add(3);
				}
				if (i < int.Parse(array[5]) + int.Parse(array[4]) + int.Parse(array[3]) + int.Parse(array[2]) + int.Parse(array[1]))
				{
					list.Add(2);
				}
				else
				{
					list.Add(1);
				}
			}
			threadSafeRandom_0.ShufferList(list);
			return list[threadSafeRandom_0.Next(list.Count)];
		}

		private int method_1(int int_0)
		{
			string[] array = GameProperties.WorshipMoonReward.Split('|');
			return int_0 switch
			{
				1 => int.Parse(array[int_0 - 1]), 
				2 => int.Parse(array[int_0 - 1]), 
				3 => int.Parse(array[int_0 - 1]), 
				4 => int.Parse(array[int_0 - 1]), 
				5 => int.Parse(array[int_0 - 1]), 
				6 => int.Parse(array[int_0 - 1]), 
				_ => -1, 
			};
		}

		static WorshipTheMoon()
		{
			threadSafeRandom_0 = new ThreadSafeRandom();
		}
	}
}
