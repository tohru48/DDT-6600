using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Farm.Handle
{
	[Attribute5(33)]
	public class FeedFarmPoultry : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			Console.WriteLine(num);
			if (num == Player.PlayerCharacter.ID)
			{
				if (Player.Farm.CurrentFarm.isFeed())
				{
					Player.Farm.FeedFarmPoultry();
					Player.SendMessage(LanguageMgr.GetTranslation("FeedFarmPoultry.Msg1"));
					Player.Farm.AddLoveScore(2);
				}
				else
				{
					Player.SendMessage(LanguageMgr.GetTranslation("FeedFarmPoultry.Msg2"));
				}
			}
			else if (Player.Farm.OtherFarm.isFeed())
			{
				Player.Farm.FeedFriendFarmPoultry(num);
				Player.SendMessage(LanguageMgr.GetTranslation("FeedFarmPoultry.Msg1"));
				GSPacketIn gSPacketIn = new GSPacketIn(81);
				gSPacketIn.WriteByte(33);
				Player.SendTCP(gSPacketIn);
				Player.Farm.AddLoveScore(2);
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("FeedFarmPoultry.Msg2"));
			}
			return true;
		}
	}
}
