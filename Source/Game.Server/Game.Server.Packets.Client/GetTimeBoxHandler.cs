using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(53, "场景用户离开")]
	public class GetTimeBoxHandler : IPacketHandler
	{
		private static readonly ILog ilog_0;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int receiebox = packet.ReadInt();
			packet.ReadInt();
			packet.ReadInt();
			bool result = false;
			List<ItemInfo> list = new List<ItemInfo>();
			int ıD = client.Player.PlayerCharacter.ID;
			int receiebox2 = client.Player.PlayerCharacter.receiebox;
			string translation = LanguageMgr.GetTranslation("GetTimeBoxHandler.Msg1");
			switch (num)
			{
			case 0:
				client.Player.UpdateTimeBox(receiebox, 20, 0);
				client.Out.SendGetBoxTime(ıD, receiebox2, result);
				break;
			case 1:
			{
				result = true;
				LoadUserBoxInfo loadUserBoxInfo = ItemMgr.FindItemBoxTemplate(receiebox2);
				if (loadUserBoxInfo == null)
				{
					ilog_0.Warn("receiebox not found id: " + receiebox2);
					return 0;
				}
				list = ItemBoxMgr.GetAllItemBoxAward(loadUserBoxInfo.TemplateID);
				foreach (ItemInfo item in list)
				{
					if (!client.Player.AddTemplate(item, item.Template.BagType, item.Count, eGameView.BatleTypeGet, LanguageMgr.GetTranslation("GetTimeBoxHandler.Msg2")))
					{
						using (PlayerBussiness playerBussiness = new PlayerBussiness())
						{
							item.UserID = 0;
							playerBussiness.AddGoods(item);
							MailInfo mailInfo = new MailInfo();
							mailInfo.Annex1 = item.ItemID.ToString();
							mailInfo.Content = LanguageMgr.GetTranslation("GetTimeBoxHandler.Msg3");
							mailInfo.Gold = 0;
							mailInfo.Money = 0;
							mailInfo.Receiver = client.Player.PlayerCharacter.NickName;
							mailInfo.ReceiverID = client.Player.PlayerCharacter.ID;
							mailInfo.Sender = mailInfo.Receiver;
							mailInfo.SenderID = mailInfo.ReceiverID;
							mailInfo.Title = LanguageMgr.GetTranslation("GetTimeBoxHandler.Msg4");
							mailInfo.Type = 12;
							playerBussiness.SendMail(mailInfo);
							translation = LanguageMgr.GetTranslation("GetTimeBoxHandler.Msg5");
						}
						client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
					}
				}
				client.Out.SendGetBoxTime(ıD, receiebox2, result);
				client.Out.SendMessage(eMessageType.Normal, translation);
				break;
			}
			}
			return 0;
		}

		static GetTimeBoxHandler()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
