using System;
using System.Collections.Generic;
using Bussiness.Managers;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Achievements
{
	public class BaseAchievement
	{
		private AchievementInfo DiUpMuOx4;

		private AchievementDataInfo achievementDataInfo_0;

		private List<BaseCondition> list_0;

		private GamePlayer gamePlayer_0;

		public AchievementInfo Info => DiUpMuOx4;

		public AchievementDataInfo Data => achievementDataInfo_0;

		public BaseAchievement(AchievementInfo info, AchievementDataInfo data)
		{
			CreateBaseAchievement(info, data);
		}

		public void CreateBaseAchievement(AchievementInfo info, AchievementDataInfo data)
		{
			DiUpMuOx4 = info;
			achievementDataInfo_0 = data;
			achievementDataInfo_0.AchievementID = DiUpMuOx4.ID;
			list_0 = new List<BaseCondition>();
			List<AchievementConditionInfo> achievementCondition = AchievementMgr.GetAchievementCondition(info);
			foreach (AchievementConditionInfo item in achievementCondition)
			{
				int value = (data.IsComplete ? 1 : 0);
				BaseCondition baseCondition = BaseCondition.CreateCondition(this, item, value);
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
			achievementDataInfo_0.UserID = player.PlayerCharacter.ID;
			if (!achievementDataInfo_0.IsComplete)
			{
				method_0(player);
			}
		}

		public void RemoveFromPlayer(GamePlayer player)
		{
			if (achievementDataInfo_0.IsComplete)
			{
				method_1(player);
			}
			gamePlayer_0 = null;
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
			if (gamePlayer_0 == null)
			{
				return;
			}
			foreach (BaseCondition item in list_0)
			{
			}
		}

		public void Update()
		{
			SaveData();
			if (gamePlayer_0 != null)
			{
				gamePlayer_0.AchievementInventory.Update(this);
				if (CanCompleted(gamePlayer_0))
				{
					gamePlayer_0.AchievementInventory.Finish(this);
				}
			}
		}

		public bool CanCompleted(GamePlayer player)
		{
			if (achievementDataInfo_0.IsComplete)
			{
				return false;
			}
			foreach (BaseCondition item in list_0)
			{
				if (!item.IsCompleted(player))
				{
					return false;
				}
			}
			return true;
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
				achievementDataInfo_0.IsComplete = true;
				method_1(player);
				achievementDataInfo_0.CompletedDate = DateTime.Now;
				return true;
			}
			return false;
		}
	}
}
