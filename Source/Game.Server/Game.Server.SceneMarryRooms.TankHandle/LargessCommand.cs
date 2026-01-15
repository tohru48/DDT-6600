using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.SceneMarryRooms.TankHandle
{
	[MarryCommandAttbute(5)]
	public class LargessCommand : IMarryCommandHandler
	{
		public bool HandleCommand(TankMarryLogicProcessor process, GamePlayer player, GSPacketIn packet)
		{
			if (player.CurrentMarryRoom == null)
			{
				return false;
			}
			int num = packet.ReadInt();
			int num2 = GameProperties.LimitLevel(3);
			if (player.PlayerCharacter.Grade < num2)
			{
				player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("LargessCommand.TankHandle.Msg", num2));
				return false;
			}
			if (num <= 0)
			{
				return false;
			}
			if (!player.ActiveMoneyEnable(num))
			{
				return false;
			}
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				string translation = LanguageMgr.GetTranslation("LargessCommand.Content", player.PlayerCharacter.NickName, num / 2);
				string translation2 = LanguageMgr.GetTranslation("LargessCommand.Title", player.PlayerCharacter.NickName);
				MailInfo mailInfo = new MailInfo();
				mailInfo.Annex1 = "";
				mailInfo.Content = translation;
				mailInfo.Gold = 0;
				mailInfo.IsExist = true;
				mailInfo.Money = num / 2;
				mailInfo.Receiver = player.CurrentMarryRoom.Info.BrideName;
				mailInfo.ReceiverID = player.CurrentMarryRoom.Info.BrideID;
				mailInfo.Sender = LanguageMgr.GetTranslation("LargessCommand.Sender");
				mailInfo.SenderID = 0;
				mailInfo.Title = translation2;
				mailInfo.Type = 14;
				playerBussiness.SendMail(mailInfo);
				player.Out.SendMailResponse(mailInfo.ReceiverID, eMailRespose.Receiver);
				MailInfo mailInfo2 = new MailInfo();
				mailInfo2.Annex1 = "";
				mailInfo2.Content = translation;
				mailInfo2.Gold = 0;
				mailInfo2.IsExist = true;
				mailInfo2.Money = num / 2;
				mailInfo2.Receiver = player.CurrentMarryRoom.Info.GroomName;
				mailInfo2.ReceiverID = player.CurrentMarryRoom.Info.GroomID;
				mailInfo2.Sender = LanguageMgr.GetTranslation("LargessCommand.Sender");
				mailInfo2.SenderID = 0;
				mailInfo2.Title = translation2;
				mailInfo2.Type = 14;
				playerBussiness.SendMail(mailInfo2);
				player.Out.SendMailResponse(mailInfo2.ReceiverID, eMailRespose.Receiver);
			}
			player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("LargessCommand.Succeed"));
			GSPacketIn packet2 = player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("LargessCommand.Notice", player.PlayerCharacter.NickName, num));
			player.CurrentMarryRoom.SendToPlayerExceptSelf(packet2, player);
			return true;
		}
	}
}
