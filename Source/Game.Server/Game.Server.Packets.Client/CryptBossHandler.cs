using Bussiness;
using Game.Base.Packets;
using Game.Server.Rooms;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(275, "场景用户离开")]
	public class CryptBossHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			if (b == 3)
			{
				string text = string.Empty;
				int id = packet.ReadInt();
				int num = packet.ReadInt();
				CryptBossItemInfo cryptBossData = client.Player.Actives.GetCryptBossData(id);
				if (cryptBossData == null)
				{
					text = LanguageMgr.GetTranslation("CryptBossHandler.NotAvable");
				}
				else if (cryptBossData.state == 1)
				{
					if (cryptBossData.star <= num && num <= 5)
					{
						RoomMgr.CreateCryptBossRoom(client.Player, id, num);
					}
					else
					{
						text = LanguageMgr.GetTranslation("CryptBossHandler.NotEnoughLevel");
					}
				}
				else
				{
					text = LanguageMgr.GetTranslation("CryptBossHandler.Done");
				}
				if (!string.IsNullOrEmpty(text))
				{
					client.Player.SendMessage(text);
				}
			}
			return 0;
		}
	}
}
