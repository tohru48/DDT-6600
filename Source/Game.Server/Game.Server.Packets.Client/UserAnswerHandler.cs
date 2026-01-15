using System.Collections.Generic;
using Game.Base.Packets;
using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(15, "New User Answer Question")]
	public class UserAnswerHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			int num = packet.ReadInt();
			bool flag = false;
			if (b == 1)
			{
				flag = packet.ReadBoolean();
			}
			if (b == 1)
			{
				List<ItemInfo> info = null;
				if (DropInventory.AnswerDrop(num, ref info))
				{
					foreach (ItemInfo item in info)
					{
						if (item != null)
						{
							client.Player.AddTemplate(item, item.Template.BagType, item.Count, eGameView.CaddyTypeGet);
						}
					}
				}
				if (flag)
				{
					client.Player.PlayerCharacter.openFunction((Step)num);
				}
			}
			if (b == 2)
			{
				client.Player.PlayerCharacter.openFunction((Step)num);
			}
			client.Player.UpdateAnswerSite(num);
			return 1;
		}
	}
}
