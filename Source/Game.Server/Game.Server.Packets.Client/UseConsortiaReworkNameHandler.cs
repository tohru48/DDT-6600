using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(188, "场景用户离开")]
	public class UseConsortiaReworkNameHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			byte bageType = packet.ReadByte();
			int slot = packet.ReadInt();
			string newNickName = packet.ReadString();
			string text = "";
			if (client.Player.PlayerCharacter.ConsortiaID == 0)
			{
				return 0;
			}
			PlayerInventory ınventory = client.Player.GetInventory((eBageType)bageType);
			ItemInfo ıtemAt = ınventory.GetItemAt(slot);
			if (ıtemAt.TemplateID == 11993)
			{
				int result;
				using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
				{
					ConsortiaInfo consortiaSingle = consortiaBussiness.GetConsortiaSingle(num);
					if (consortiaSingle == null)
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("UseConsortiaReworkNameHandler.Msg1"));
						result = 0;
					}
					else
					{
						if (client.Player.PlayerCharacter.ID == consortiaSingle.ChairmanID)
						{
							if (consortiaBussiness.RenameConsortia(num, client.Player.PlayerCharacter.NickName, newNickName))
							{
								ınventory.RemoveCountFromStack(ıtemAt, 1);
							}
							else
							{
								text = LanguageMgr.GetTranslation("UseConsortiaReworkNameHandler.Msg3");
							}
							goto IL_016b;
						}
						client.Player.SendMessage(LanguageMgr.GetTranslation("UseConsortiaReworkNameHandler.Msg2"));
						result = 0;
					}
				}
				return result;
			}
			goto IL_016b;
			IL_016b:
			if (text != "")
			{
				client.Player.SendMessage(text);
			}
			return 0;
		}
	}
}
