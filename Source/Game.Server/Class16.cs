using System.Linq;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server;
using Game.Server.Packets;
using Game.Server.Packets.Client;
using SqlDataProvider.Data;

[PacketHandler(247, "求婚")]
internal class Class16 : IPacketHandler
{
	public int HandlePacket(GameClient client, GSPacketIn packet)
	{
		if (client.Player.PlayerCharacter.IsMarried)
		{
			return 1;
		}
		if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
		{
			client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
			return 1;
		}
		int num = packet.ReadInt();
		string loveProclamation = packet.ReadString();
		packet.ReadBoolean();
		bool flag = true;
		using PlayerBussiness playerBussiness = new PlayerBussiness();
		PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(num);
		if (userSingleByUserID != null && userSingleByUserID.Sex != client.Player.PlayerCharacter.Sex)
		{
			if (userSingleByUserID.IsMarried)
			{
				client.Player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("MarryApplyHandler.Msg2"));
				return 1;
			}
			ItemInfo ıtemByTemplateID = client.Player.PropBag.GetItemByTemplateID(0, 11103);
			if (ıtemByTemplateID == null)
			{
				ShopItemInfo shopItemInfo = ShopMgr.FindShopbyTemplatID(11103).FirstOrDefault();
				if (shopItemInfo == null)
				{
					client.Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("MarryApplyHandler.Msg6"));
					return 1;
				}
				if (!client.Player.MoneyDirect(shopItemInfo.AValue1))
				{
					return 1;
				}
				flag = false;
			}
			MarryApplyInfo marryApplyInfo = new MarryApplyInfo();
			marryApplyInfo.UserID = num;
			marryApplyInfo.ApplyUserID = client.Player.PlayerCharacter.ID;
			marryApplyInfo.ApplyUserName = client.Player.PlayerCharacter.NickName;
			marryApplyInfo.ApplyType = 1;
			marryApplyInfo.LoveProclamation = loveProclamation;
			marryApplyInfo.ApplyResult = false;
			int id = 0;
			if (playerBussiness.SavePlayerMarryNotice(marryApplyInfo, 0, ref id))
			{
				if (flag)
				{
					client.Player.RemoveItem(ıtemByTemplateID);
				}
				else
				{
					ShopMgr.FindShopbyTemplatID(11103).FirstOrDefault();
				}
				client.Player.Out.SendPlayerMarryApply(client.Player, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, loveProclamation, id);
				GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(num);
				string nickName = userSingleByUserID.NickName;
				client.Player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("MarryApplyHandler.Msg3"));
			}
			return 0;
		}
		return 1;
	}
}
