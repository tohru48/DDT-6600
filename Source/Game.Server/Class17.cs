using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.Packets.Client;
using SqlDataProvider.Data;

[PacketHandler(250, "求婚答复")]
internal class Class17 : IPacketHandler
{
	public int HandlePacket(GameClient client, GSPacketIn packet)
	{
		bool flag = packet.ReadBoolean();
		int userID = packet.ReadInt();
		int answerId = packet.ReadInt();
		if (flag && client.Player.PlayerCharacter.IsMarried)
		{
			client.Player.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("MarryApplyReplyHandler.Msg2"));
		}
		using PlayerBussiness playerBussiness = new PlayerBussiness();
		PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(userID);
		if (!flag)
		{
			method_1(userSingleByUserID.NickName, userSingleByUserID.ID, client.Player.PlayerCharacter.NickName, client.Player.PlayerCharacter.ID, playerBussiness);
			GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(userSingleByUserID.ID);
		}
		if (userSingleByUserID != null && userSingleByUserID.Sex != client.Player.PlayerCharacter.Sex)
		{
			if (userSingleByUserID.IsMarried)
			{
				client.Player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("MarryApplyReplyHandler.Msg3"));
			}
			MarryApplyInfo marryApplyInfo = new MarryApplyInfo();
			marryApplyInfo.UserID = userID;
			marryApplyInfo.ApplyUserID = client.Player.PlayerCharacter.ID;
			marryApplyInfo.ApplyUserName = client.Player.PlayerCharacter.NickName;
			marryApplyInfo.ApplyType = 2;
			marryApplyInfo.LoveProclamation = "";
			marryApplyInfo.ApplyResult = flag;
			int id = 0;
			if (playerBussiness.SavePlayerMarryNotice(marryApplyInfo, answerId, ref id))
			{
				if (flag)
				{
					client.Player.Out.SendMarryApplyReply(client.Player, userSingleByUserID.ID, userSingleByUserID.NickName, flag, isApplicant: false, id);
					client.Player.LoadMarryProp();
				}
				GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(userSingleByUserID.ID);
				return 0;
			}
			return 1;
		}
		return 1;
	}

	public void method_0(GamePlayer gamePlayer_0, PlayerInfo playerInfo_0)
	{
		string text = (gamePlayer_0.PlayerCharacter.Sex ? gamePlayer_0.PlayerCharacter.NickName : playerInfo_0.NickName);
		string text2 = (gamePlayer_0.PlayerCharacter.Sex ? playerInfo_0.NickName : gamePlayer_0.PlayerCharacter.NickName);
		string translation = LanguageMgr.GetTranslation("MarryApplyReplyHandler.Msg1", text, text2);
		GSPacketIn gSPacketIn = new GSPacketIn(10);
		gSPacketIn.WriteInt(2);
		gSPacketIn.WriteString(translation);
		GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
		GamePlayer[] array = allPlayers;
		foreach (GamePlayer gamePlayer in array)
		{
			gamePlayer.Out.SendTCP(gSPacketIn);
		}
	}

	public void method_1(string string_0, int int_0, string string_1, int int_1, PlayerBussiness playerBussiness_0)
	{
		ItemTemplateInfo goods = ItemMgr.FindItemTemplate(11105);
		ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(goods, 1, 112);
		ıtemInfo.IsBinds = true;
		ıtemInfo.UserID = 0;
		playerBussiness_0.AddGoods(ıtemInfo);
		playerBussiness_0.SendMail(new MailInfo
		{
			Annex1 = ıtemInfo.ItemID.ToString(),
			Content = LanguageMgr.GetTranslation("MarryApplyReplyHandler.Content"),
			Gold = 0,
			IsExist = true,
			Money = 0,
			Receiver = string_0,
			ReceiverID = int_0,
			Sender = string_1,
			SenderID = int_1,
			Title = LanguageMgr.GetTranslation("MarryApplyReplyHandler.Title"),
			Type = 14
		});
	}
}
