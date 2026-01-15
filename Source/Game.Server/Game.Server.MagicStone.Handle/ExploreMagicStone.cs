using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.MagicStone.Handle
{
	[Attribute11(1)]
	public class ExploreMagicStone : IMagicStoneCommandHadler
	{
		public static ThreadSafeRandom random;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			packet.ReadBoolean();
			int num2 = packet.ReadInt();
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			PlayerMagicStoneInventory magicStoneBag = Player.MagicStoneBag;
			string[] array = GameProperties.OpenMagicBoxMoney.Split('|');
			if (array.Length == 0)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ExploreMagicStone.Msg1"));
				return false;
			}
			int value = int.Parse(array[0].Split(',')[0]);
			int value2 = int.Parse(array[0].Split(',')[1]);
			int minValue = 1;
			int maxValue = 3;
			switch (num)
			{
			case 2:
				value = int.Parse(array[1].Split(',')[0]);
				value2 = int.Parse(array[1].Split(',')[1]);
				minValue = 1;
				maxValue = 4;
				break;
			case 3:
				value = int.Parse(array[2].Split(',')[0]);
				value2 = int.Parse(array[2].Split(',')[1]);
				minValue = 2;
				maxValue = 5;
				break;
			}
			int num3 = magicStoneBag.FindEmptySlotCount();
			if (num3 == 0)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ExploreMagicStone.Msg2"));
				return false;
			}
			if (num2 > num3)
			{
				num2 = num3;
			}
			new List<ItemInfo>();
			for (int i = 0; i < num2; i++)
			{
				int num4 = random.Next(minValue, maxValue);
				if (num4 == 4)
				{
				}
				List<ItemTemplateInfo> list = ItemMgr.FindMagicStoneTemplate(random.Next(minValue, maxValue));
				if (list.Count == 0)
				{
					return false;
				}
				if (Player.MoneyDirect(value))
				{
					int index = random.Next(list.Count);
					ItemInfo item = magicStoneBag.CreateMagicstone(list[index], 1);
					int place = magicStoneBag.FindFirstEmptySlot();
					if (magicStoneBag.AddItemTo(item, place))
					{
						Player.AddScoreMagicstone(value2);
					}
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(258, Player.PlayerId);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(Player.Extra.Info.ScoreMagicstone);
			Player.SendTCP(gSPacketIn);
			return true;
		}

		static ExploreMagicStone()
		{
			random = new ThreadSafeRandom();
		}
	}
}
