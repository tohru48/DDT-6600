using System;
using System.Collections.Generic;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(13, "场景用户离开")]
	public class DailyAwardHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			StringBuilder stringBuilder = new StringBuilder();
			List<ItemInfo> list = new List<ItemInfo>();
			string text = "";
			switch (num)
			{
			case 0:
				if (AwardMgr.AddDailyAward(client.Player))
				{
					using PlayerBussiness playerBussiness = new PlayerBussiness();
					if (playerBussiness.UpdatePlayerLastAward(client.Player.PlayerCharacter.ID, num))
					{
						stringBuilder.Append(LanguageMgr.GetTranslation("DailyAwardHandler.Msg1"));
					}
					else
					{
						stringBuilder.Append(LanguageMgr.GetTranslation("GameUserDailyAward.Fail"));
					}
				}
				else
				{
					stringBuilder.Append(LanguageMgr.GetTranslation("GameUserDailyAward.Fail1"));
				}
				break;
			case 2:
			{
				if (DateTime.Now.Date == client.Player.PlayerCharacter.LastGetEgg.Date)
				{
					stringBuilder.Append(LanguageMgr.GetTranslation("DailyAwardHandler.Msg2"));
					break;
				}
				using (PlayerBussiness playerBussiness3 = new PlayerBussiness())
				{
					playerBussiness3.UpdatePlayerLastAward(client.Player.PlayerCharacter.ID, num);
				}
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(112059);
				if (ItemBoxMgr.CreateItemBox(ıtemTemplateInfo.TemplateID, list, ref specialValue))
				{
					break;
				}
				client.Player.SendMessage(LanguageMgr.GetTranslation("DailyAwardHandler.Msg3"));
				return 0;
			}
			case 3:
			{
				if (!client.Player.PlayerCharacter.CanTakeVipReward)
				{
					stringBuilder.Append(LanguageMgr.GetTranslation("DailyAwardHandler.Msg4"));
					break;
				}
				int vIPLevel = client.Player.PlayerCharacter.VIPLevel;
				client.Player.LastVIPPackTime();
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(ItemMgr.FindItemBoxTypeAndLv(2, vIPLevel).TemplateID);
				if (!ItemBoxMgr.CreateItemBox(ıtemTemplateInfo.TemplateID, list, ref specialValue))
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("DailyAwardHandler.Msg3"));
					return 0;
				}
				using (PlayerBussiness playerBussiness2 = new PlayerBussiness())
				{
					playerBussiness2.UpdateLastVIPPackTime(client.Player.PlayerCharacter.ID);
				}
				break;
			}
			case 5:
			{
				using (ProduceBussiness produceBussiness = new ProduceBussiness())
				{
					DailyLogListInfo dailyLogListSingle = produceBussiness.GetDailyLogListSingle(client.Player.PlayerCharacter.ID);
					string dayLog = dailyLogListSingle.DayLog;
					dayLog.Split(',');
					if (!string.IsNullOrEmpty(dayLog) && !string.IsNullOrEmpty(dayLog.Split(',')[0]))
					{
						dayLog += ",True";
					}
					else
					{
						dayLog = "True";
						dailyLogListSingle.UserAwardLog = 0;
					}
					dailyLogListSingle.DayLog = dayLog;
					dailyLogListSingle.UserAwardLog++;
					produceBussiness.UpdateDailyLogList(dailyLogListSingle);
				}
				stringBuilder.Append(LanguageMgr.GetTranslation("DailyAwardHandler.Msg5"));
				break;
			}
			}
			StringBuilder stringBuilder2 = new StringBuilder();
			foreach (ItemInfo item in list)
			{
				stringBuilder2.Append(item.Template.Name + "x" + item.Count + ",");
				if (!client.Player.AddTemplate(item, item.Template.BagType, item.Count, eGameView.RouletteTypeGet))
				{
					using PlayerBussiness playerBussiness4 = new PlayerBussiness();
					item.UserID = 0;
					playerBussiness4.AddGoods(item);
					MailInfo mailInfo = new MailInfo();
					mailInfo.Annex1 = item.ItemID.ToString();
					mailInfo.Content = LanguageMgr.GetTranslation("OpenUpArkHandler.Content1") + item.Template.Name + LanguageMgr.GetTranslation("OpenUpArkHandler.Content2");
					mailInfo.Gold = 0;
					mailInfo.Money = 0;
					mailInfo.Receiver = client.Player.PlayerCharacter.NickName;
					mailInfo.ReceiverID = client.Player.PlayerCharacter.ID;
					mailInfo.Sender = mailInfo.Receiver;
					mailInfo.SenderID = mailInfo.ReceiverID;
					mailInfo.Title = LanguageMgr.GetTranslation("OpenUpArkHandler.Title") + item.Template.Name + "]";
					mailInfo.Type = 12;
					playerBussiness4.SendMail(mailInfo);
					text = LanguageMgr.GetTranslation("OpenUpArkHandler.Mail");
				}
			}
			if (stringBuilder2.Length > 0)
			{
				stringBuilder2.Remove(stringBuilder2.Length - 1, 1);
				string[] array = stringBuilder2.ToString().Split(',');
				for (int i = 0; i < array.Length; i++)
				{
					int num2 = 1;
					for (int j = i + 1; j < array.Length; j++)
					{
						if (array[i].Contains(array[j]) && array[j].Length == array[i].Length)
						{
							num2++;
							array[j] = j.ToString();
						}
					}
					if (num2 > 1)
					{
						array[i] = array[i].Remove(array[i].Length - 1, 1);
						string[] array3;
						string[] array2 = (array3 = array);
						int num3 = i;
						nint num4 = num3;
						array2[num3] = array3[num4] + num2;
					}
					if (array[i] != i.ToString())
					{
						string[] array3;
						string[] array4 = (array3 = array);
						int num5 = i;
						nint num4 = num5;
						array4[num5] = array3[num4] + ",";
						stringBuilder.Append(array[i]);
					}
				}
			}
			if (stringBuilder.Length - 1 > 0)
			{
				stringBuilder.Remove(stringBuilder.Length - 1, 1);
				stringBuilder.Append(".");
			}
			client.Out.SendMessage(eMessageType.Normal, text + stringBuilder.ToString());
			client.Player.DirectAddValue(specialValue);
			if (!string.IsNullOrEmpty(text))
			{
				client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
			}
			return 2;
		}
	}
}
