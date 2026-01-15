using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(106)]
	public class TreasurepuzzleUsePice : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int place = packet.ReadInt();
			int num = packet.ReadInt();
			ItemInfo ıtemAt = Player.GetItemAt(eBageType.PropBag, place);
			if (ıtemAt != null && num > 0)
			{
				if (ıtemAt.IsPuzzle())
				{
					if (ıtemAt.Count < num)
					{
						num = ıtemAt.Count;
					}
					int num2 = 0;
					switch (ıtemAt.TemplateID)
					{
					case 201386:
						num2 = Player.Actives.AddHole(1, num);
						break;
					case 201387:
						num2 = Player.Actives.AddHole(2, num);
						break;
					case 201388:
						num2 = Player.Actives.AddHole(3, num);
						break;
					case 201389:
						num2 = Player.Actives.AddHole(4, num);
						break;
					case 201390:
						num2 = Player.Actives.AddHole(5, num);
						break;
					case 201391:
						num2 = Player.Actives.AddHole(6, num);
						break;
					}
					if (num2 > 0)
					{
						Player.RemoveTemplate(ıtemAt.TemplateID, num2);
						Player.SendMessage(LanguageMgr.GetTranslation("TreasurepuzzleUsePice.UseSuccess"));
						Player.Actives.SaveTreasurepuzzleDatabase();
					}
					else
					{
						Player.SendMessage(LanguageMgr.GetTranslation("TreasurepuzzleUsePice.FullSlot"));
					}
				}
				else
				{
					Player.SendMessage(LanguageMgr.GetTranslation("TreasurepuzzleUsePice.HaveNotPice"));
				}
			}
			else
			{
				Player.SendMessage(LanguageMgr.GetTranslation("TreasurepuzzleUsePice.HaveNotPice"));
			}
			return true;
		}
	}
}
