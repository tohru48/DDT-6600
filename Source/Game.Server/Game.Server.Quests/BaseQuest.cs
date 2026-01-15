using System;
using System.Collections.Generic;
using Bussiness.Managers;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
	public class BaseQuest
	{
		private QuestInfo questInfo_0;

		private QuestDataInfo questDataInfo_0;

		private List<BaseCondition> list_0;

		private GamePlayer gamePlayer_0;

		private DateTime dateTime_0;

		public QuestInfo Info => questInfo_0;

		public QuestDataInfo Data => questDataInfo_0;

		public BaseQuest(QuestInfo info, QuestDataInfo data)
		{
			questInfo_0 = info;
			questDataInfo_0 = data;
			questDataInfo_0.QuestID = questInfo_0.ID;
			list_0 = new List<BaseCondition>();
			List<QuestConditionInfo> questCondiction = QuestMgr.GetQuestCondiction(info);
			int num = 0;
			foreach (QuestConditionInfo item in questCondiction)
			{
				BaseCondition baseCondition = BaseCondition.CreateCondition(this, item, data.GetConditionValue(num++));
				if (baseCondition != null)
				{
					list_0.Add(baseCondition);
				}
			}
		}

		public BaseCondition GetConditionById(int id)
		{
			foreach (BaseCondition item in list_0)
			{
				if (item.Info.CondictionID == id)
				{
					return item;
				}
			}
			return null;
		}

		public void AddToPlayer(GamePlayer player)
		{
			gamePlayer_0 = player;
			if (!questDataInfo_0.IsComplete)
			{
				method_0(player);
			}
		}

		public void RemoveFromPlayer(GamePlayer player)
		{
			if (!questDataInfo_0.IsComplete)
			{
				method_1(player);
			}
			gamePlayer_0 = null;
		}

		public void CheckRepeat()
		{
			if ((DateTime.Now.Date - questDataInfo_0.CompletedDate.Date).TotalDays >= (double)questInfo_0.RepeatInterval && questInfo_0.CanRepeat && questInfo_0.RepeatInterval > 0)
			{
				questDataInfo_0.RepeatFinish = questInfo_0.RepeatMax;
			}
		}

		public void Reset(GamePlayer player, int rand)
		{
			questDataInfo_0.QuestID = questInfo_0.ID;
			questDataInfo_0.UserID = player.PlayerId;
			questDataInfo_0.IsComplete = false;
			questDataInfo_0.IsExist = true;
			if (questDataInfo_0.CompletedDate == DateTime.MinValue)
			{
				questDataInfo_0.CompletedDate = DateTime.Now;
			}
			if ((DateTime.Now - questDataInfo_0.CompletedDate).TotalDays >= (double)questInfo_0.RepeatInterval)
			{
				questDataInfo_0.RepeatFinish = questInfo_0.RepeatMax;
			}
			questDataInfo_0.RepeatFinish--;
			questDataInfo_0.RandDobule = rand;
			questDataInfo_0.QuestLevel = 1;
			if (!player.PlayerCharacter.method_0())
			{
				questDataInfo_0.QuestLevel = ((player.PlayerCharacter.VIPLevel > 5) ? 3 : 2);
			}
			foreach (BaseCondition item in list_0)
			{
				item.Reset(player);
			}
			SaveData();
		}

		private void method_0(GamePlayer gamePlayer_1)
		{
			foreach (BaseCondition item in list_0)
			{
				item.AddTrigger(gamePlayer_1);
			}
		}

		private void method_1(GamePlayer gamePlayer_1)
		{
			foreach (BaseCondition item in list_0)
			{
				item.RemoveTrigger(gamePlayer_1);
			}
		}

		public void SaveData()
		{
			int num = 0;
			foreach (BaseCondition item in list_0)
			{
				questDataInfo_0.SaveConditionValue(num++, item.Value);
			}
		}

		public void Update()
		{
			SaveData();
			if (questDataInfo_0.IsDirty && gamePlayer_0 != null)
			{
				gamePlayer_0.QuestInventory.Update(this);
			}
		}

		public bool CanCompleted(GamePlayer player)
		{
			if (questDataInfo_0.IsComplete)
			{
				return false;
			}
			int num = questInfo_0.NotMustCount;
			foreach (BaseCondition item in list_0)
			{
				if (!item.IsCompleted(player))
				{
					if (!item.Info.isOpitional)
					{
						return false;
					}
				}
				else
				{
					num--;
				}
			}
			return num <= 0;
		}

		public bool Finish(GamePlayer player)
		{
			if (CanCompleted(player))
			{
				foreach (BaseCondition item in list_0)
				{
					if (!item.Finish(player))
					{
						return false;
					}
				}
				if (!Info.CanRepeat)
				{
					questDataInfo_0.IsComplete = true;
					method_1(player);
				}
				dateTime_0 = questDataInfo_0.CompletedDate;
				questDataInfo_0.CompletedDate = DateTime.Now;
				return true;
			}
			return false;
		}

		public bool CancelFinish(GamePlayer player)
		{
			questDataInfo_0.IsComplete = false;
			questDataInfo_0.CompletedDate = dateTime_0;
			foreach (BaseCondition item in list_0)
			{
				item.CancelFinish(player);
			}
			return true;
		}
	}
}
