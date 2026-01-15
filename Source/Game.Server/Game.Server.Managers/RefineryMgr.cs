using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class RefineryMgr
	{
		private static Dictionary<int, RefineryInfo> dictionary_0;

		private static readonly ILog ilog_0;

		private static ThreadSafeRandom threadSafeRandom_0;

		public static bool Init()
		{
			return Reload();
		}

		public static bool Reload()
		{
			try
			{
				Dictionary<int, RefineryInfo> dictionary = new Dictionary<int, RefineryInfo>();
				dictionary = LoadFromBD();
				if (dictionary.Count > 0)
				{
					Interlocked.Exchange(ref dictionary_0, dictionary);
				}
				return true;
			}
			catch (Exception exception)
			{
				ilog_0.Error("NPCInfoMgr", exception);
			}
			return false;
		}

		public static Dictionary<int, RefineryInfo> LoadFromBD()
		{
			List<RefineryInfo> list = new List<RefineryInfo>();
			Dictionary<int, RefineryInfo> dictionary = new Dictionary<int, RefineryInfo>();
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				list = produceBussiness.GetAllRefineryInfo();
				foreach (RefineryInfo item in list)
				{
					if (!dictionary.ContainsKey(item.RefineryID))
					{
						dictionary.Add(item.RefineryID, item);
					}
				}
			}
			return dictionary;
		}

		public static ItemTemplateInfo Refinery(GamePlayer player, List<ItemInfo> Items, ItemInfo Item, bool Luck, int OpertionType, ref bool result, ref int defaultprobability, ref bool IsFormula)
		{
			new ItemTemplateInfo();
			foreach (int key in dictionary_0.Keys)
			{
				if (dictionary_0[key].m_Equip.Contains(Item.TemplateID))
				{
					IsFormula = true;
					int num = 0;
					List<int> list = new List<int>();
					foreach (ItemInfo Item2 in Items)
					{
						if (Item2.TemplateID == dictionary_0[key].Item1 && Item2.Count >= dictionary_0[key].Int32_0 && !list.Contains(Item2.TemplateID))
						{
							list.Add(Item2.TemplateID);
							if (OpertionType != 0)
							{
								Item2.Count -= dictionary_0[key].Int32_0;
							}
							num++;
						}
						if (Item2.TemplateID == dictionary_0[key].Item2 && Item2.Count >= dictionary_0[key].Int32_1 && !list.Contains(Item2.TemplateID))
						{
							list.Add(Item2.TemplateID);
							if (OpertionType != 0)
							{
								Item2.Count -= dictionary_0[key].Int32_1;
							}
							num++;
						}
						if (Item2.TemplateID == dictionary_0[key].Item3 && Item2.Count >= dictionary_0[key].Int32_2 && !list.Contains(Item2.TemplateID))
						{
							list.Add(Item2.TemplateID);
							if (OpertionType != 0)
							{
								Item2.Count -= dictionary_0[key].Int32_2;
							}
							num++;
						}
					}
					if (num != 3)
					{
						continue;
					}
					for (int i = 0; i < dictionary_0[key].m_Reward.Count; i++)
					{
						if (Items[Items.Count - 1].TemplateID == dictionary_0[key].m_Reward[i])
						{
							if (Luck)
							{
								defaultprobability += 20;
							}
							if (OpertionType == 0)
							{
								int templateId = dictionary_0[key].m_Reward[i + 1];
								return ItemMgr.FindItemTemplate(templateId);
							}
							if (threadSafeRandom_0.Next(100) < defaultprobability)
							{
								int templateId = dictionary_0[key].m_Reward[i + 1];
								result = true;
								return ItemMgr.FindItemTemplate(templateId);
							}
						}
					}
				}
				else
				{
					IsFormula = false;
				}
			}
			return null;
		}

		public static ItemTemplateInfo RefineryTrend(int Operation, ItemInfo Item, ref bool result)
		{
			if (Item != null)
			{
				foreach (int key in dictionary_0.Keys)
				{
					if (!dictionary_0[key].m_Reward.Contains(Item.TemplateID))
					{
						continue;
					}
					for (int i = 0; i < dictionary_0[key].m_Reward.Count; i++)
					{
						if (dictionary_0[key].m_Reward[i] == Operation)
						{
							int templateId = dictionary_0[key].m_Reward[i + 2];
							result = true;
							return ItemMgr.FindItemTemplate(templateId);
						}
					}
				}
			}
			return null;
		}

		static RefineryMgr()
		{
			dictionary_0 = new Dictionary<int, RefineryInfo>();
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			threadSafeRandom_0 = new ThreadSafeRandom();
		}
	}
}
