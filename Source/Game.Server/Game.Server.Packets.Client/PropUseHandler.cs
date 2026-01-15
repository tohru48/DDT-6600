using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(66, "场景用户离开")]
	public class PropUseHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			eBageType bageType = (eBageType)packet.ReadInt();
			int slot = packet.ReadInt();
			PlayerInventory ınventory = client.Player.GetInventory(bageType);
			if (ınventory != null)
			{
				ItemInfo ıtemAt = ınventory.GetItemAt(slot);
				if (ıtemAt != null)
				{
					int num = packet.ReadInt();
					for (int i = 0; i < num; i++)
					{
						int num2 = packet.ReadInt();
						int num3 = num2;
						if (num3 == 201316)
						{
							UserChickActiveInfo chickActiveData = client.Player.Actives.GetChickActiveData();
							if (chickActiveData.IsKeyOpened == 0 && ıtemAt != null && ıtemAt.Count >= 1)
							{
								ınventory.RemoveCountFromStack(ıtemAt, 1);
								chickActiveData.Active((client.Player.PlayerCharacter.Grade <= 15) ? 1 : 2);
								client.Player.Actives.SaveChickActiveData(chickActiveData);
								client.Player.SendMessage(LanguageMgr.GetTranslation("PropUseHandler.ChickActivation.Success"));
							}
							else
							{
								client.Player.SendMessage(LanguageMgr.GetTranslation("PropUseHandler.ChickActivation.Fail"));
							}
						}
					}
					packet.ReadInt();
					packet.ReadBoolean();
				}
			}
			return 0;
		}
	}
}
