using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(171, "场景用户离开")]
	public class UseReworkNameHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte bageType = packet.ReadByte();
			int slot = packet.ReadInt();
			string newNickName = packet.ReadString();
			string text = LanguageMgr.GetTranslation("UseReworkNameHandler.Msg");
			PlayerInventory ınventory = client.Player.GetInventory((eBageType)bageType);
			ItemInfo ıtemAt = ınventory.GetItemAt(slot);
			if (ıtemAt.TemplateID == 11994)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				if (playerBussiness.RenameNick(client.Player.PlayerCharacter.UserName, client.Player.PlayerCharacter.NickName, newNickName))
				{
					ınventory.RemoveCountFromStack(ıtemAt, 1);
					text = "";
				}
			}
			if (text != "")
			{
				client.Player.SendMessage(text);
			}
			return 0;
		}
	}
}
