using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(1)]
	public class PyramidEnter : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.Actives.LoadPyramid())
			{
				GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
				PyramidInfo pyramid = Player.Actives.Pyramid;
				gSPacketIn.WriteByte(1);
				gSPacketIn.WriteInt(pyramid.currentLayer);
				gSPacketIn.WriteInt(pyramid.maxLayer);
				gSPacketIn.WriteInt(pyramid.totalPoint);
				gSPacketIn.WriteInt(pyramid.turnPoint);
				gSPacketIn.WriteInt(pyramid.pointRatio);
				gSPacketIn.WriteInt(pyramid.currentFreeCount);
				gSPacketIn.WriteInt(pyramid.currentReviveCount);
				gSPacketIn.WriteBoolean(pyramid.isPyramidStart);
				if (pyramid.isPyramidStart)
				{
					string[] string_ = pyramid.LayerItems.Split('|');
					int[] array = new int[7] { 8, 7, 6, 5, 4, 3, 2 };
					gSPacketIn.WriteInt(array.Length);
					for (int i = 1; i <= array.Length; i++)
					{
						string[] array2 = method_0(string_, i);
						gSPacketIn.WriteInt(i);
						gSPacketIn.WriteInt(array2.Length);
						for (int j = 0; j < array2.Length; j++)
						{
							int val = int.Parse(array2[j].Split('-')[1]);
							int val2 = int.Parse(array2[j].Split('-')[2]);
							gSPacketIn.WriteInt(val);
							gSPacketIn.WriteInt(val2);
						}
					}
				}
				Player.SendTCP(gSPacketIn);
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("ActiveSystemHandler.Msg10"));
			}
			return true;
		}

		private string[] method_0(string[] string_0, int int_0)
		{
			List<string> list = new List<string>();
			foreach (string text in string_0)
			{
				string text2 = text.Split('-')[0];
				if (text2 == int_0.ToString())
				{
					list.Add(text);
				}
			}
			return list.ToArray();
		}
	}
}
