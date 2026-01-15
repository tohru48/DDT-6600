using Bussiness;
using Game.Base.Packets;
using Game.Server;
using Game.Server.Packets;
using Game.Server.Packets.Client;
using SqlDataProvider.Data;

[PacketHandler(248, "离婚")]
internal class Class15 : IPacketHandler
{
	public int HandlePacket(GameClient client, GSPacketIn packet)
	{
		bool flag = packet.ReadBoolean();
		if (!client.Player.PlayerCharacter.IsMarried)
		{
			return 1;
		}
		if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
		{
			client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
			return 0;
		}
		if (client.Player.PlayerCharacter.IsCreatedMarryRoom)
		{
			client.Player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("DivorceApplyHandler.Msg2"));
			return 1;
		}
		int value = GameProperties.PRICE_DIVORCED;
		if (flag)
		{
			value = GameProperties.PRICE_DIVORCED_DISCOUNT;
		}
		if (!client.Player.MoneyDirect(value))
		{
			return 1;
		}
		using (PlayerBussiness playerBussiness = new PlayerBussiness())
		{
			PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(client.Player.PlayerCharacter.SpouseID);
			if (userSingleByUserID == null || userSingleByUserID.Sex == client.Player.PlayerCharacter.Sex)
			{
				return 1;
			}
			MarryApplyInfo marryApplyInfo = new MarryApplyInfo();
			marryApplyInfo.UserID = client.Player.PlayerCharacter.SpouseID;
			marryApplyInfo.ApplyUserID = client.Player.PlayerCharacter.ID;
			marryApplyInfo.ApplyUserName = client.Player.PlayerCharacter.NickName;
			marryApplyInfo.ApplyType = 3;
			marryApplyInfo.LoveProclamation = "";
			marryApplyInfo.ApplyResult = false;
			int id = 0;
			if (playerBussiness.SavePlayerMarryNotice(marryApplyInfo, 0, ref id))
			{
				GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(userSingleByUserID.ID);
				client.Player.LoadMarryProp();
			}
		}
		client.Player.QuestInventory.ClearMarryQuest();
		client.Player.Out.SendPlayerDivorceApply(client.Player, result: true, isProposer: true);
		client.Player.SendMessage(LanguageMgr.GetTranslation("DivorceApplyHandler.Msg3"));
		return 0;
	}
}
