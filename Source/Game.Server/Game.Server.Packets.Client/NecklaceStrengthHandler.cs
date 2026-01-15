using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(95, "客户端日记")]
	public class NecklaceStrengthHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadByte();
			int slot = packet.ReadInt();
			int num2 = packet.ReadInt();
			ItemInfo ıtemAt = client.Player.PropBag.GetItemAt(slot);
			if (ıtemAt == null)
			{
				return 0;
			}
			if (ıtemAt.Count < num2)
			{
				num2 = ıtemAt.Count;
			}
			int num3 = num;
			if (num3 == 2)
			{
				int nECKLACE_MAX_LEVEL = StrengthenMgr.NECKLACE_MAX_LEVEL;
				int property = ıtemAt.Template.Property2;
				int necklaceLevelByGP = StrengthenMgr.GetNecklaceLevelByGP(client.Player.PlayerCharacter.necklaceExp);
				int necklaceExpAdd = client.Player.PlayerCharacter.necklaceExpAdd;
				if (necklaceLevelByGP < nECKLACE_MAX_LEVEL && ıtemAt != null && ıtemAt.TemplateID == 11160 && num2 > 0)
				{
					int num4 = client.Player.PlayerCharacter.necklaceExp + property * num2;
					int necklaceMaxExp = StrengthenMgr.GetNecklaceMaxExp();
					if (necklaceMaxExp == 0)
					{
						return 0;
					}
					if (num4 > necklaceMaxExp)
					{
						int num5 = necklaceMaxExp - client.Player.PlayerCharacter.necklaceExp;
						num4 = client.Player.PlayerCharacter.necklaceExp + num5;
						num2 = ((num5 / property <= 0) ? 1 : (num5 / property));
					}
					client.Player.PlayerCharacter.necklaceExp = num4;
					int necklaceExpAdd2 = StrengthenMgr.GetNecklaceExpAdd(client.Player.PlayerCharacter.necklaceExp, necklaceExpAdd);
					if (necklaceExpAdd < necklaceExpAdd2)
					{
						client.Player.EquipBag.UpdatePlayerProperties();
					}
					client.Player.PlayerCharacter.necklaceExpAdd = necklaceExpAdd2;
					client.Player.RemoveTemplate(ıtemAt.TemplateID, num2);
				}
			}
			client.Player.Out.SendNecklaceStrength(client.Player.PlayerCharacter);
			return 0;
		}
	}
}
