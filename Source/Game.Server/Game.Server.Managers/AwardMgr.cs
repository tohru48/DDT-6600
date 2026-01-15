using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Server.Buffer;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class AwardMgr
	{
		private static readonly ILog ilog_0;

		private static Dictionary<int, DailyAwardInfo> dictionary_0;

		private static bool bool_0;

		public static bool DailyAwardState
		{
			get
			{
				return bool_0;
			}
			set
			{
				bool_0 = value;
			}
		}

		public static bool ReLoad()
		{
			try
			{
				Dictionary<int, DailyAwardInfo> awards = new Dictionary<int, DailyAwardInfo>();
				if (smethod_0(awards))
				{
					try
					{
						dictionary_0 = awards;
						return true;
					}
					catch
					{
					}
				}
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("AwardMgr", exception);
				}
			}
			return false;
		}

		public static bool Init()
		{
			try
			{
				dictionary_0 = new Dictionary<int, DailyAwardInfo>();
				bool_0 = false;
				return smethod_0(dictionary_0);
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("AwardMgr", exception);
				}
				return false;
			}
		}

		private static bool smethod_0(Dictionary<int, DailyAwardInfo> awards)
		{
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				DailyAwardInfo[] allDailyAward = produceBussiness.GetAllDailyAward();
				DailyAwardInfo[] array = allDailyAward;
				foreach (DailyAwardInfo dailyAwardInfo in array)
				{
					if (!awards.ContainsKey(dailyAwardInfo.ID))
					{
						awards.Add(dailyAwardInfo.ID, dailyAwardInfo);
					}
				}
			}
			return true;
		}

		public static DailyAwardInfo[] GetAllAwardInfo()
		{
			DailyAwardInfo[] array = dictionary_0.Values.ToArray();
			if (array != null)
			{
				return array;
			}
			return new DailyAwardInfo[0];
		}

		public static bool AddDailyAward(GamePlayer player)
		{
			if (DateTime.Now.Date == player.PlayerCharacter.LastAward.Date)
			{
				return false;
			}
			player.PlayerCharacter.DayLoginCount++;
			player.PlayerCharacter.LastAward = DateTime.Now;
			DailyAwardInfo[] allAwardInfo = GetAllAwardInfo();
			DailyAwardInfo[] array = allAwardInfo;
			foreach (DailyAwardInfo dailyAwardInfo in array)
			{
				if (dailyAwardInfo.Type == 0)
				{
					ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(dailyAwardInfo.TemplateID);
					if (ıtemTemplateInfo != null)
					{
						AbstractBuffer abstractBuffer = BufferList.CreateBufferHour(ıtemTemplateInfo, dailyAwardInfo.ValidDate);
						abstractBuffer.Start(player);
						return true;
					}
				}
			}
			return false;
		}

		public static bool AddSignAwards(GamePlayer player, int DailyLog)
		{
			DailyAwardInfo[] allAwardInfo = GetAllAwardInfo();
			new StringBuilder();
			string value = string.Empty;
			bool flag = false;
			int templateId = 0;
			int num = 1;
			int validDate = 0;
			bool ısBinds = true;
			bool result = false;
			DailyAwardInfo[] array = allAwardInfo;
			foreach (DailyAwardInfo dailyAwardInfo in array)
			{
				flag = true;
				switch (DailyLog)
				{
				case 9:
					if (dailyAwardInfo.Type == DailyLog)
					{
						templateId = dailyAwardInfo.TemplateID;
						num = dailyAwardInfo.Count;
						validDate = dailyAwardInfo.ValidDate;
						ısBinds = dailyAwardInfo.IsBinds;
						result = true;
					}
					break;
				case 3:
					if (dailyAwardInfo.Type == DailyLog)
					{
						num = dailyAwardInfo.Count;
						player.AddGiftToken(num);
						result = true;
					}
					break;
				case 26:
					if (dailyAwardInfo.Type == DailyLog)
					{
						templateId = dailyAwardInfo.TemplateID;
						num = dailyAwardInfo.Count;
						validDate = dailyAwardInfo.ValidDate;
						ısBinds = dailyAwardInfo.IsBinds;
						result = true;
					}
					break;
				case 17:
					if (dailyAwardInfo.Type == DailyLog)
					{
						templateId = dailyAwardInfo.TemplateID;
						num = dailyAwardInfo.Count;
						validDate = dailyAwardInfo.ValidDate;
						ısBinds = dailyAwardInfo.IsBinds;
						result = true;
					}
					break;
				}
			}
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(templateId);
			if (ıtemTemplateInfo != null)
			{
				int num2 = num;
				for (int j = 0; j < num2; j += ıtemTemplateInfo.MaxCount)
				{
					int count = ((j + ıtemTemplateInfo.MaxCount > num2) ? (num2 - j) : ıtemTemplateInfo.MaxCount);
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, count, 113);
					ıtemInfo.ValidDate = validDate;
					ıtemInfo.IsBinds = ısBinds;
					if (!player.AddTemplate(ıtemInfo, ıtemInfo.Template.BagType, ıtemInfo.Count, eGameView.CaddyTypeGet))
					{
						flag = true;
						using PlayerBussiness playerBussiness = new PlayerBussiness();
						ıtemInfo.UserID = 0;
						playerBussiness.AddGoods(ıtemInfo);
						MailInfo mailInfo = new MailInfo();
						mailInfo.Annex1 = ıtemInfo.ItemID.ToString();
						mailInfo.Content = LanguageMgr.GetTranslation("AwardMgr.AddDailyAward.Content", ıtemInfo.Template.Name);
						mailInfo.Gold = 0;
						mailInfo.Money = 0;
						mailInfo.Receiver = player.PlayerCharacter.NickName;
						mailInfo.ReceiverID = player.PlayerCharacter.ID;
						mailInfo.Sender = mailInfo.Receiver;
						mailInfo.SenderID = mailInfo.ReceiverID;
						mailInfo.Title = LanguageMgr.GetTranslation("AwardMgr.AddDailyAward.Title", ıtemInfo.Template.Name);
						mailInfo.Type = 15;
						playerBussiness.SendMail(mailInfo);
						value = LanguageMgr.GetTranslation("AwardMgr.AddDailyAward.Mail");
					}
				}
			}
			if (flag && !string.IsNullOrEmpty(value))
			{
				player.Out.SendMailResponse(player.PlayerCharacter.ID, eMailRespose.Receiver);
			}
			return result;
		}

		static AwardMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
