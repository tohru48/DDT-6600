using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Server.Buffer;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class QuestInventory
	{
		private static readonly ILog ilog_0;

		private object object_0;

		protected List<BaseQuest> m_list;

		protected List<QuestDataInfo> m_datas;

		protected ArrayList m_clearList;

		private GamePlayer gamePlayer_0;

		private byte[] byte_0;

		private UnicodeEncoding unicodeEncoding_0;

		protected List<BaseQuest> m_changedQuests;

		private int int_0;

		public QuestInventory(GamePlayer player)
		{
			m_changedQuests = new List<BaseQuest>();
			unicodeEncoding_0 = new UnicodeEncoding();
			gamePlayer_0 = player;
			object_0 = new object();
			m_list = new List<BaseQuest>();
			m_clearList = new ArrayList();
			m_datas = new List<QuestDataInfo>();
		}

		public void LoadFromDatabase(int playerId)
		{
			lock (object_0)
			{
				byte_0 = ((gamePlayer_0.PlayerCharacter.QuestSite.Length == 0) ? method_4() : gamePlayer_0.PlayerCharacter.QuestSite);
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				QuestDataInfo[] userQuest = playerBussiness.GetUserQuest(playerId);
				method_2();
				QuestDataInfo[] array = userQuest;
				foreach (QuestDataInfo questDataInfo in array)
				{
					QuestInfo singleQuest = QuestMgr.GetSingleQuest(questDataInfo.QuestID);
					if (singleQuest != null)
					{
						method_0(new BaseQuest(singleQuest, questDataInfo));
					}
					method_1(questDataInfo);
				}
				method_3();
			}
		}

		public void SaveToDatabase()
		{
			lock (object_0)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				foreach (BaseQuest item in m_list)
				{
					item.SaveData();
					if (item.Data.IsDirty)
					{
						playerBussiness.UpdateDbQuestDataInfo(item.Data);
					}
				}
				foreach (BaseQuest clear in m_clearList)
				{
					clear.SaveData();
					playerBussiness.UpdateDbQuestDataInfo(clear.Data);
				}
				m_clearList.Clear();
			}
		}

		private bool method_0(BaseQuest baseQuest_0)
		{
			lock (m_list)
			{
				m_list.Add(baseQuest_0);
			}
			OnQuestsChanged(baseQuest_0);
			baseQuest_0.AddToPlayer(gamePlayer_0);
			return true;
		}

		private bool method_1(QuestDataInfo questDataInfo_0)
		{
			lock (m_list)
			{
				m_datas.Add(questDataInfo_0);
			}
			return true;
		}

		public bool AddQuest(QuestInfo info, out string msg)
		{
			msg = "";
			try
			{
				if (info == null)
				{
					msg = "Game.Server.Quests.NoQuest";
					return false;
				}
				if (info.TimeMode && DateTime.Now.CompareTo(info.StartDate) < 0)
				{
					msg = "Game.Server.Quests.NoTime";
				}
				if (info.TimeMode && DateTime.Now.CompareTo(info.EndDate) > 0)
				{
					msg = "Game.Server.Quests.TimeOver";
				}
				if (gamePlayer_0.PlayerCharacter.Grade < info.NeedMinLevel)
				{
					msg = "Game.Server.Quests.LevelLow";
				}
				if (gamePlayer_0.PlayerCharacter.Grade > info.NeedMaxLevel)
				{
					msg = "Game.Server.Quests.LevelTop";
				}
				if (info.PreQuestID != "0,")
				{
					string[] array = info.PreQuestID.Split(',');
					for (int i = 0; i < array.Length - 1; i++)
					{
						if (!method_6(Convert.ToInt32(array[i])))
						{
							msg = "Game.Server.Quests.NoFinish";
						}
					}
				}
			}
			catch (Exception ex)
			{
				ilog_0.Info(ex.InnerException);
			}
			if (info.IsOther == 1 && !gamePlayer_0.PlayerCharacter.IsConsortia)
			{
				msg = "Game.Server.Quest.QuestInventory.HaveMarry";
			}
			if (info.IsOther == 2 && !gamePlayer_0.PlayerCharacter.IsMarried)
			{
				msg = "Game.Server.Quest.QuestInventory.HaveMarry";
			}
			BaseQuest baseQuest = FindQuest(info.ID);
			if (baseQuest != null && baseQuest.Data.IsComplete)
			{
				msg = "Game.Server.Quests.Have";
			}
			if (baseQuest != null && !baseQuest.Info.CanRepeat)
			{
				msg = "Game.Server.Quests.NoRepeat";
			}
			if (baseQuest != null && DateTime.Now.CompareTo(baseQuest.Data.CompletedDate.Date.AddDays(baseQuest.Info.RepeatInterval)) < 0 && baseQuest.Data.RepeatFinish < 1)
			{
				msg = "Game.Server.Quests.Rest";
			}
			BaseQuest baseQuest2 = gamePlayer_0.QuestInventory.FindQuest(info.ID);
			if (baseQuest2 != null)
			{
				msg = "Game.Server.Quests.Have";
			}
			if (msg == "")
			{
				QuestMgr.GetQuestCondiction(info);
				int rand = 1;
				if ((decimal)ThreadSafeRandom.NextStatic(1000000) <= info.Rands)
				{
					rand = info.RandDouble;
				}
				method_2();
				if (baseQuest == null)
				{
					baseQuest = new BaseQuest(info, new QuestDataInfo());
					method_0(baseQuest);
					baseQuest.Reset(gamePlayer_0, rand);
				}
				else
				{
					baseQuest.Reset(gamePlayer_0, rand);
					baseQuest.AddToPlayer(gamePlayer_0);
					OnQuestsChanged(baseQuest);
				}
				method_3();
				return true;
			}
			msg = LanguageMgr.GetTranslation(msg);
			return false;
		}

		public bool FindFinishQuestData(int ID, int UserID)
		{
			bool result = false;
			lock (m_datas)
			{
				foreach (QuestDataInfo data in m_datas)
				{
					if (data.QuestID == ID && data.UserID == UserID)
					{
						result = data.IsComplete;
					}
				}
			}
			return result;
		}

		public bool RemoveQuest(BaseQuest quest)
		{
			if (!quest.Info.CanRepeat)
			{
				bool flag = false;
				lock (m_list)
				{
					if (m_list.Remove(quest))
					{
						m_clearList.Add(quest);
						flag = true;
					}
				}
				if (flag)
				{
					quest.RemoveFromPlayer(gamePlayer_0);
					OnQuestsChanged(quest);
				}
				return flag;
			}
			quest.Reset(gamePlayer_0, 2);
			quest.Data.RepeatFinish++;
			quest.SaveData();
			OnQuestsChanged(quest);
			return true;
		}

		public void Update(BaseQuest quest)
		{
			OnQuestsChanged(quest);
		}

		public bool Finish(BaseQuest baseQuest, int selectedItem)
		{
			string text = "";
			QuestInfo ınfo = baseQuest.Info;
			QuestDataInfo data = baseQuest.Data;
			gamePlayer_0.BeginAllChanges();
			try
			{
				if (baseQuest.Finish(gamePlayer_0))
				{
					RemoveQuest(baseQuest);
					List<QuestAwardInfo> questGoods = QuestMgr.GetQuestGoods(ınfo);
					List<ItemInfo> list = new List<ItemInfo>();
					List<ItemInfo> list2 = new List<ItemInfo>();
					List<ItemInfo> list3 = new List<ItemInfo>();
					List<ItemInfo> list4 = new List<ItemInfo>();
					List<ItemInfo> list5 = new List<ItemInfo>();
					foreach (QuestAwardInfo item in questGoods)
					{
						if (item.IsSelect && item.RewardItemID != selectedItem)
						{
							continue;
						}
						ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(item.RewardItemID);
						if (ıtemTemplateInfo == null)
						{
							continue;
						}
						text = text + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardProp", ıtemTemplateInfo.Name, item.RewardItemCount1) + " ";
						int num = item.RewardItemCount1;
						if (item.IsCount)
						{
							num *= data.RandDobule;
						}
						for (int i = 0; i < num; i += ıtemTemplateInfo.MaxCount)
						{
							int count = ((i + ıtemTemplateInfo.MaxCount > item.RewardItemCount1) ? (item.RewardItemCount1 - i) : ıtemTemplateInfo.MaxCount);
							ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, count, 106);
							if (ıtemInfo != null)
							{
								ıtemInfo.ValidDate = item.RewardItemValid;
								ıtemInfo.IsBinds = true;
								ıtemInfo.StrengthenLevel = item.StrengthenLevel;
								ıtemInfo.AttackCompose = item.AttackCompose;
								ıtemInfo.DefendCompose = item.DefendCompose;
								ıtemInfo.AgilityCompose = item.AgilityCompose;
								ıtemInfo.LuckCompose = item.LuckCompose;
								if (ıtemTemplateInfo.BagType == eBageType.PropBag)
								{
									list2.Add(ıtemInfo);
								}
								else if (ıtemTemplateInfo.BagType == eBageType.FarmBag)
								{
									list3.Add(ıtemInfo);
								}
								else if (ıtemTemplateInfo.BagType == eBageType.BeadBag)
								{
									list4.Add(ıtemInfo);
								}
								else
								{
									list.Add(ıtemInfo);
								}
							}
						}
					}
					if (list.Count > 0 && gamePlayer_0.EquipBag.GetEmptyCount() < list.Count)
					{
						baseQuest.CancelFinish(gamePlayer_0);
						gamePlayer_0.Out.SendMessage(eMessageType.ERROR, gamePlayer_0.GetInventoryName(eBageType.EquipBag) + LanguageMgr.GetTranslation("Game.Server.Quests.BagFull") + " ");
						return false;
					}
					if (list2.Count > 0 && gamePlayer_0.PropBag.GetEmptyCount() < list2.Count)
					{
						baseQuest.CancelFinish(gamePlayer_0);
						gamePlayer_0.Out.SendMessage(eMessageType.ERROR, gamePlayer_0.GetInventoryName(eBageType.PropBag) + LanguageMgr.GetTranslation("Game.Server.Quests.BagFull") + " ");
						return false;
					}
					if (list3.Count > 0 && gamePlayer_0.FarmBag.GetEmptyCount() < list3.Count)
					{
						baseQuest.CancelFinish(gamePlayer_0);
						gamePlayer_0.Out.SendMessage(eMessageType.ERROR, gamePlayer_0.GetInventoryName(eBageType.FarmBag) + LanguageMgr.GetTranslation("Game.Server.Quests.BagFull") + " ");
						return false;
					}
					if (list4.Count > 0 && gamePlayer_0.BeadBag.GetEmptyCount() < list4.Count)
					{
						baseQuest.CancelFinish(gamePlayer_0);
						gamePlayer_0.Out.SendMessage(eMessageType.ERROR, gamePlayer_0.GetInventoryName(eBageType.BeadBag) + LanguageMgr.GetTranslation("Game.Server.Quests.BagFull") + " ");
						return false;
					}
					foreach (ItemInfo item2 in list)
					{
						if (item2.isDress())
						{
							if (!gamePlayer_0.AvatarBag.AddItem(item2))
							{
								list5.Add(item2);
							}
						}
						else if (!gamePlayer_0.EquipBag.StackItemToAnother(item2) && !gamePlayer_0.EquipBag.AddItem(item2))
						{
							list5.Add(item2);
						}
					}
					foreach (ItemInfo item3 in list2)
					{
						if (item3.Template.CategoryID != 10)
						{
							if (!gamePlayer_0.PropBag.StackItemToAnother(item3) && !gamePlayer_0.PropBag.AddItem(item3))
							{
								list5.Add(item3);
							}
							continue;
						}
						switch (item3.TemplateID)
						{
						case 10001:
							gamePlayer_0.PlayerCharacter.openFunction(Step.PICK_TWO_TWENTY);
							break;
						case 10003:
							gamePlayer_0.PlayerCharacter.openFunction(Step.POP_WIN);
							break;
						case 10004:
							gamePlayer_0.PlayerCharacter.openFunction(Step.FIFTY_OPEN);
							gamePlayer_0.AddGift(eGiftType.MONEY);
							gamePlayer_0.AddGift(eGiftType.BIG_EXP);
							gamePlayer_0.AddGift(eGiftType.PET_EXP);
							break;
						case 10005:
							gamePlayer_0.PlayerCharacter.openFunction(Step.FORTY_OPEN);
							break;
						case 10006:
							gamePlayer_0.PlayerCharacter.openFunction(Step.THIRTY_OPEN);
							break;
						case 10007:
							gamePlayer_0.PlayerCharacter.openFunction(Step.POP_TWO_TWENTY);
							gamePlayer_0.AddGift(eGiftType.SMALL_EXP);
							break;
						case 10008:
							gamePlayer_0.PlayerCharacter.openFunction(Step.POP_TIP_ONE);
							break;
						case 10024:
							gamePlayer_0.PlayerCharacter.openFunction(Step.PICK_ONE);
							break;
						case 10025:
							gamePlayer_0.PlayerCharacter.openFunction(Step.POP_EXPLAIN_ONE);
							break;
						}
					}
					foreach (ItemInfo item4 in list3)
					{
						if (!gamePlayer_0.FarmBag.StackItemToAnother(item4) && !gamePlayer_0.FarmBag.AddItem(item4))
						{
							list5.Add(item4);
						}
					}
					foreach (ItemInfo item5 in list4)
					{
						if (!gamePlayer_0.BeadBag.AddItem(item5))
						{
							list5.Add(item5);
						}
					}
					if (list5.Count > 0)
					{
						gamePlayer_0.SendItemsToMail(list5, "", "", eMailType.ItemOverdue);
						gamePlayer_0.Out.SendMailResponse(gamePlayer_0.PlayerCharacter.ID, eMailRespose.Receiver);
					}
					text = LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.Reward") + text;
					if (ınfo.RewardBuffID > 0 && ınfo.RewardBuffDate > 0)
					{
						ItemTemplateInfo ıtemTemplateInfo2 = ItemMgr.FindItemTemplate(ınfo.RewardBuffID);
						if (ıtemTemplateInfo2 != null)
						{
							int num2 = ınfo.RewardBuffDate * data.RandDobule;
							AbstractBuffer abstractBuffer = BufferList.CreateBufferHour(ıtemTemplateInfo2, num2);
							abstractBuffer.Start(gamePlayer_0);
							text = text + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardBuff", ıtemTemplateInfo2.Name, num2) + " ";
						}
					}
					if (ınfo.ID == 558)
					{
						gamePlayer_0.AddGift(eGiftType.NEWBIE);
					}
					if (ınfo.RewardGold != 0)
					{
						int num3 = ınfo.RewardGold * data.RandDobule;
						gamePlayer_0.AddGold(num3);
						text = text + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardGold", num3) + " ";
					}
					if (ınfo.RewardMoney != 0)
					{
						int num4 = ınfo.RewardMoney * data.RandDobule;
						gamePlayer_0.AddMoney(ınfo.RewardMoney * data.RandDobule);
						text = text + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardMoney", num4) + " ";
					}
					if (ınfo.RewardGP != 0)
					{
						int num5 = ınfo.RewardGP * data.RandDobule;
						gamePlayer_0.AddGP(num5);
						text = text + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardGB1", num5) + " ";
					}
					if (ınfo.RewardRiches != 0 && gamePlayer_0.PlayerCharacter.ConsortiaID != 0)
					{
						int riches = ınfo.RewardRiches * data.RandDobule;
						gamePlayer_0.AddRichesOffer(riches);
						using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
						{
							consortiaBussiness.ConsortiaRichAdd(gamePlayer_0.PlayerCharacter.ConsortiaID, ref riches);
						}
						text = text + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardRiches", riches) + " ";
					}
					if (ınfo.RewardOffer != 0)
					{
						int num6 = ınfo.RewardOffer * data.RandDobule;
						gamePlayer_0.AddOffer(num6, IsRate: false);
						text = text + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardOffer", num6) + " ";
					}
					if (ınfo.RewardBindMoney != 0)
					{
						int num7 = ınfo.RewardBindMoney * data.RandDobule;
						gamePlayer_0.AddGiftToken(num7);
						text += LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardGiftToken", num7 + " ");
					}
					gamePlayer_0.Out.SendMessage(eMessageType.Normal, text);
					method_5(baseQuest.Info.ID);
					gamePlayer_0.PlayerCharacter.QuestSite = byte_0;
				}
				OnQuestsChanged(baseQuest);
			}
			catch (Exception ex)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("Quest Finish：" + ex);
				}
				return false;
			}
			finally
			{
				gamePlayer_0.CommitAllChanges();
			}
			return true;
		}

		public BaseQuest FindQuest(int id)
		{
			foreach (BaseQuest item in m_list)
			{
				if (item.Info.ID == id)
				{
					return item;
				}
			}
			return null;
		}

		protected void OnQuestsChanged(BaseQuest quest)
		{
			if (!m_changedQuests.Contains(quest))
			{
				m_changedQuests.Add(quest);
			}
			if (int_0 <= 0 && m_changedQuests.Count > 0)
			{
				UpdateChangedQuests();
			}
		}

		private void method_2()
		{
			Interlocked.Increment(ref int_0);
		}

		private void method_3()
		{
			int num = Interlocked.Decrement(ref int_0);
			if (num < 0)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
				}
				Thread.VolatileWrite(ref int_0, 0);
			}
			if (num <= 0 && m_changedQuests.Count > 0)
			{
				UpdateChangedQuests();
			}
		}

		public void UpdateChangedQuests()
		{
			gamePlayer_0.Out.SendUpdateQuests(gamePlayer_0, byte_0, m_changedQuests.ToArray());
			m_changedQuests.Clear();
		}

		private byte[] method_4()
		{
			byte[] array = new byte[200];
			for (int i = 0; i < 200; i++)
			{
				array[i] = 0;
			}
			return array;
		}

		private bool method_5(int int_1)
		{
			if (int_1 <= byte_0.Length * 8 && int_1 >= 1)
			{
				int_1--;
				int num = int_1 / 8;
				int num2 = int_1 % 8;
				byte_0[num] = (byte)(byte_0[num] | (1 << num2));
				return true;
			}
			return false;
		}

		private bool method_6(int int_1)
		{
			if (int_1 <= byte_0.Length * 8 && int_1 >= 1)
			{
				int_1--;
				int num = int_1 / 8;
				int num2 = int_1 % 8;
				int num3 = byte_0[num] & (1 << num2);
				return num3 != 0;
			}
			return false;
		}

		public bool ClearConsortiaQuest()
		{
			return true;
		}

		public bool ClearMarryQuest()
		{
			return true;
		}

		static QuestInventory()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
