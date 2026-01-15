using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(33)]
	public class CatchbeastViewInfo : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.Actives.YearMonterValidate())
			{
				GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(33);
				gSPacketIn.WriteInt(Player.Actives.Info.ChallengeNum);
				gSPacketIn.WriteInt(Player.Actives.Info.BuyBuffNum);
				gSPacketIn.WriteInt(GameProperties.YearMonsterBuffMoney);
				gSPacketIn.WriteInt(Player.Actives.Info.DamageNum);
				string[] array = GameProperties.YearMonsterBoxInfo.Split('|');
				string[] array2 = Player.Actives.Info.BoxState.Split('-');
				gSPacketIn.WriteInt(array.Length);
				for (int i = 0; i < array.Length; i++)
				{
					string[] array3 = array[i].Split(',');
					gSPacketIn.WriteInt(int.Parse(array3[0]));
					gSPacketIn.WriteInt(int.Parse(array3[1]) * 10000);
					gSPacketIn.WriteInt(int.Parse(array2[i]));
				}
				Player.Out.SendTCP(gSPacketIn);
			}
			return true;
		}
	}
}
