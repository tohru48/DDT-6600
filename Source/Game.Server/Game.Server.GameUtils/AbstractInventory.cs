using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Game.Logic;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public abstract class AbstractInventory
	{
		private static readonly ILog ilog_0;

		protected object m_lock;

		private int int_0;

		private int int_1;

		private int int_2;

		private bool bool_0;

		protected ItemInfo[] m_items;

		protected List<int> m_changedPlaces;

		private int int_3;

		public int BeginSlot => int_2;

		public int Capalility
		{
			get
			{
				return int_1;
			}
			set
			{
				int_1 = ((value >= 0) ? ((value > m_items.Length) ? m_items.Length : value) : 0);
			}
		}

		public int BagType => int_0;

		public bool IsEmpty(int slot)
		{
			return slot < 0 || slot >= int_1 || m_items[slot] == null;
		}

		public AbstractInventory(int capability, int type, int beginSlot, bool autoStack)
		{
			m_lock = new object();
			m_changedPlaces = new List<int>();
			int_1 = capability;
			int_0 = type;
			int_2 = beginSlot;
			bool_0 = autoStack;
			m_items = new ItemInfo[capability];
		}

		public bool AddItem(ItemInfo item)
		{
			return AddItem(item, int_2);
		}

		public bool AddItem(ItemInfo item, int minSlot)
		{
			if (item == null)
			{
				return false;
			}
			int place = FindFirstEmptySlot(minSlot);
			return AddItemTo(item, place);
		}

		public virtual bool AddItemTo(ItemInfo item, int place)
		{
			if (item != null && place < int_1 && place >= 0)
			{
				if (item.IsBead() && (item.ItemID == 0 || item.Hole1 <= 0))
				{
					RuneTemplateInfo runeTemplateInfo = RuneMgr.FindRuneByTemplateID(item.TemplateID);
					if (runeTemplateInfo != null)
					{
						item.Hole1 = runeTemplateInfo.BaseLevel;
						item.Hole2 = RuneMgr.FindRuneExp(runeTemplateInfo.BaseLevel - 1);
					}
				}
				lock (m_lock)
				{
					if (m_items[place] != null)
					{
						place = -1;
					}
					else
					{
						m_items[place] = item;
						item.Place = place;
						item.BagType = int_0;
					}
				}
				if (place != -1)
				{
					OnPlaceChanged(place);
				}
				return place != -1;
			}
			return false;
		}

		public virtual bool TakeOutItem(ItemInfo item)
		{
			if (item == null)
			{
				return false;
			}
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < int_1; i++)
				{
					if (m_items[i] == item)
					{
						num = i;
						m_items[i] = null;
						break;
					}
				}
			}
			if (num != -1)
			{
				OnPlaceChanged(num);
				if (item.BagType == BagType)
				{
					item.Place = -1;
					item.BagType = -1;
				}
			}
			return num != -1;
		}

		public bool TakeOutItemAt(int place)
		{
			return TakeOutItem(GetItemAt(place));
		}

		public void RemoveAllItem(List<int> places)
		{
			if (places.Count != 0)
			{
				for (int i = 0; i < places.Count; i++)
				{
					int place = places[i];
					RemoveItemAt(place);
				}
			}
		}

		public virtual bool RemoveItem(ItemInfo item)
		{
			if (item == null)
			{
				return false;
			}
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < int_1; i++)
				{
					if (m_items[i] == item)
					{
						num = i;
						m_items[i] = null;
						break;
					}
				}
			}
			if (num != -1)
			{
				OnPlaceChanged(num);
				if (item.BagType == BagType)
				{
					item.Place = -1;
					item.BagType = -1;
				}
			}
			return num != -1;
		}

		public bool RemoveItemAt(int place)
		{
			return RemoveItem(GetItemAt(place));
		}

		public virtual bool AddCountToStack(ItemInfo item, int count)
		{
			if (item == null)
			{
				return false;
			}
			if (count > 0 && item.BagType == int_0)
			{
				if (item.Count + count > item.Template.MaxCount)
				{
					return false;
				}
				item.Count += count;
				OnPlaceChanged(item.Place);
				return true;
			}
			return false;
		}

		public virtual bool RemoveCountFromStack(ItemInfo item, int count)
		{
			if (item == null)
			{
				return false;
			}
			if (count > 0 && item.BagType == int_0)
			{
				if (item.Count < count)
				{
					return false;
				}
				if (item.Count == count)
				{
					return RemoveItem(item);
				}
				item.Count -= count;
				OnPlaceChanged(item.Place);
				return true;
			}
			return false;
		}

		public virtual bool AddTemplateAt(ItemInfo cloneItem, int count, int place)
		{
			return AddTemplate(cloneItem, count, place, int_1 - 1);
		}

		public virtual bool AddTemplate(ItemInfo cloneItem, int count)
		{
			return AddTemplate(cloneItem, count, int_2, int_1 - 1);
		}

		public virtual bool AddTemplate(ItemInfo cloneItem, int count, int minSlot, int maxSlot)
		{
			if (cloneItem == null)
			{
				return false;
			}
			ItemTemplateInfo template = cloneItem.Template;
			if (template == null)
			{
				return false;
			}
			if (count <= 0)
			{
				return false;
			}
			if (minSlot < int_2 || minSlot > int_1 - 1)
			{
				return false;
			}
			if (maxSlot < int_2 || maxSlot > int_1 - 1)
			{
				return false;
			}
			if (minSlot > maxSlot)
			{
				return false;
			}
			bool result;
			lock (m_lock)
			{
				List<int> list = new List<int>();
				int num = count;
				for (int i = minSlot; i <= maxSlot; i++)
				{
					ItemInfo ıtemInfo = m_items[i];
					if (ıtemInfo == null)
					{
						num -= template.MaxCount;
						list.Add(i);
					}
					else if (bool_0 && cloneItem.CanStackedTo(ıtemInfo))
					{
						num -= template.MaxCount - ıtemInfo.Count;
						list.Add(i);
					}
					if (num <= 0)
					{
						break;
					}
				}
				if (num <= 0)
				{
					BeginChanges();
					try
					{
						num = count;
						foreach (int item in list)
						{
							ItemInfo ıtemInfo2 = m_items[item];
							if (ıtemInfo2 == null)
							{
								ıtemInfo2 = cloneItem.Clone();
								ıtemInfo2.Count = ((num < template.MaxCount) ? num : template.MaxCount);
								num -= ıtemInfo2.Count;
								AddItemTo(ıtemInfo2, item);
							}
							else if (ıtemInfo2.TemplateID == template.TemplateID)
							{
								int num2 = ((ıtemInfo2.Count + num < template.MaxCount) ? num : (template.MaxCount - ıtemInfo2.Count));
								ıtemInfo2.Count += num2;
								num -= num2;
								OnPlaceChanged(item);
							}
							else
							{
								ilog_0.Error("Add template erro: select slot's TemplateId not equest templateId");
							}
						}
						if (num != 0)
						{
							ilog_0.Error("Add template error: last count not equal Zero.");
						}
					}
					finally
					{
						CommitChanges();
					}
					result = true;
				}
				else
				{
					result = false;
				}
			}
			return result;
		}

		public virtual bool RemoveTemplate(int templateId, int count)
		{
			return RemoveTemplate(templateId, count, 0, int_1 - 1);
		}

		public virtual bool RemoveTemplate(int templateId, int count, int minSlot, int maxSlot)
		{
			if (count <= 0)
			{
				return false;
			}
			if (minSlot < 0 || minSlot > int_1 - 1)
			{
				return false;
			}
			if (maxSlot <= 0 || maxSlot > int_1 - 1)
			{
				return false;
			}
			if (minSlot > maxSlot)
			{
				return false;
			}
			bool result;
			lock (m_lock)
			{
				List<int> list = new List<int>();
				int num = count;
				for (int i = minSlot; i <= maxSlot; i++)
				{
					ItemInfo ıtemInfo = m_items[i];
					if (ıtemInfo != null && ıtemInfo.TemplateID == templateId)
					{
						list.Add(i);
						num -= ıtemInfo.Count;
						if (num <= 0)
						{
							break;
						}
					}
				}
				if (num <= 0)
				{
					BeginChanges();
					num = count;
					try
					{
						foreach (int item in list)
						{
							ItemInfo ıtemInfo2 = m_items[item];
							if (ıtemInfo2 != null && ıtemInfo2.TemplateID == templateId)
							{
								if (ıtemInfo2.Count <= num)
								{
									RemoveItem(ıtemInfo2);
									num -= ıtemInfo2.Count;
									continue;
								}
								int num2 = ((ıtemInfo2.Count - num < ıtemInfo2.Count) ? num : 0);
								ıtemInfo2.Count -= num2;
								num -= num2;
								OnPlaceChanged(item);
							}
						}
						if (num != 0)
						{
							ilog_0.Error("Remove templat error:last itemcoutj not equal Zero.");
						}
					}
					finally
					{
						CommitChanges();
					}
					result = true;
				}
				else
				{
					result = false;
				}
			}
			return result;
		}

		public virtual bool MoveItem(int fromSlot, int toSlot, int count)
		{
			if (fromSlot >= 0 && toSlot >= 0 && fromSlot < int_1 && toSlot < int_1)
			{
				bool flag = false;
				lock (m_lock)
				{
					flag = CombineItems(fromSlot, toSlot) || StackItems(fromSlot, toSlot, count) || ExchangeItems(fromSlot, toSlot);
				}
				if (flag)
				{
					BeginChanges();
					try
					{
						OnPlaceChanged(fromSlot);
						OnPlaceChanged(toSlot);
					}
					finally
					{
						CommitChanges();
					}
				}
				return flag;
			}
			return false;
		}

		public bool IsSolt(int slot)
		{
			return slot >= 0 && slot < int_1;
		}

		public void ClearBag()
		{
			BeginChanges();
			lock (m_lock)
			{
				for (int i = int_2; i < int_1; i++)
				{
					if (m_items[i] != null)
					{
						RemoveItem(m_items[i]);
					}
				}
			}
			CommitChanges();
		}

		public bool StackItemToAnother(ItemInfo item)
		{
			lock (m_lock)
			{
				for (int num = int_1 - 1; num >= 0; num--)
				{
					if (item != null && m_items[num] != null && m_items[num] != item && item.CanStackedTo(m_items[num]) && m_items[num].Count + item.Count <= item.Template.MaxCount)
					{
						m_items[num].Count += item.Count;
						item.IsExist = false;
						item.RemoveType = 26;
						UpdateItem(m_items[num]);
						return true;
					}
				}
			}
			return false;
		}

		protected virtual bool CombineItems(int fromSlot, int toSlot)
		{
			return false;
		}

		protected virtual bool StackItems(int fromSlot, int toSlot, int itemCount)
		{
			ItemInfo ıtemInfo = m_items[fromSlot];
			ItemInfo ıtemInfo2 = m_items[toSlot];
			if (itemCount == 0)
			{
				itemCount = ((ıtemInfo.Count <= 0) ? 1 : ıtemInfo.Count);
			}
			if (ıtemInfo2 != null && ıtemInfo2.TemplateID == ıtemInfo.TemplateID && ıtemInfo2.CanStackedTo(ıtemInfo))
			{
				if (ıtemInfo.Count + ıtemInfo2.Count > ıtemInfo.Template.MaxCount)
				{
					ıtemInfo.Count -= ıtemInfo2.Template.MaxCount - ıtemInfo2.Count;
					ıtemInfo2.Count = ıtemInfo2.Template.MaxCount;
				}
				else
				{
					ıtemInfo2.Count += itemCount;
					RemoveItem(ıtemInfo);
				}
				return true;
			}
			if (ıtemInfo2 != null || ıtemInfo.Count <= itemCount)
			{
				return false;
			}
			ItemInfo ıtemInfo3 = ıtemInfo.Clone();
			ıtemInfo3.Count = itemCount;
			if (AddItemTo(ıtemInfo3, toSlot))
			{
				ıtemInfo.Count -= itemCount;
				return true;
			}
			return false;
		}

		protected virtual bool ExchangeItems(int fromSlot, int toSlot)
		{
			ItemInfo ıtemInfo = m_items[toSlot];
			ItemInfo ıtemInfo2 = m_items[fromSlot];
			m_items[fromSlot] = ıtemInfo;
			m_items[toSlot] = ıtemInfo2;
			if (ıtemInfo != null)
			{
				ıtemInfo.Place = fromSlot;
			}
			if (ıtemInfo2 != null)
			{
				ıtemInfo2.Place = toSlot;
			}
			return true;
		}

		public virtual ItemInfo GetItemAt(int slot)
		{
			if (slot >= 0 && slot < int_1)
			{
				return m_items[slot];
			}
			return null;
		}

		public virtual ItemInfo GetAvatarAt(int slot)
		{
			if (slot >= 0 && slot < int_1)
			{
				return m_items[slot];
			}
			return null;
		}

		public int FindFirstEmptySlot()
		{
			return FindFirstEmptySlot(int_2);
		}

		public int FindEmptySlotCount()
		{
			return FindEmptySlotCount(int_2);
		}

		public int FindEmptySlotCount(int minSlot)
		{
			if (minSlot >= int_1)
			{
				return 0;
			}
			int num = 0;
			int result;
			lock (m_lock)
			{
				for (int i = minSlot; i < int_1; i++)
				{
					if (m_items[i] == null)
					{
						num++;
					}
				}
				result = num;
			}
			return result;
		}

		public int FindFirstEmptySlot(int minSlot)
		{
			if (minSlot >= int_1)
			{
				return -1;
			}
			int result;
			lock (m_lock)
			{
				for (int i = minSlot; i < int_1; i++)
				{
					if (m_items[i] == null)
					{
						result = i;
						return result;
					}
				}
				result = -1;
			}
			return result;
		}

		public int FindLastEmptySlot()
		{
			int result;
			lock (m_lock)
			{
				for (int num = int_1 - 1; num >= 0; num--)
				{
					if (m_items[num] == null)
					{
						result = num;
						return result;
					}
				}
				result = -1;
			}
			return result;
		}

		public virtual void Clear()
		{
			BeginChanges();
			lock (m_lock)
			{
				for (int i = 0; i < int_1; i++)
				{
					m_items[i] = null;
					OnPlaceChanged(i);
				}
			}
			CommitChanges();
		}

		public virtual ItemInfo GetItemByCategoryID(int minSlot, int categoryID, int property)
		{
			ItemInfo result;
			lock (m_lock)
			{
				for (int i = minSlot; i < int_1; i++)
				{
					if (m_items[i] != null && m_items[i].Template.CategoryID == categoryID && (property == -1 || m_items[i].Template.Property1 == property))
					{
						result = m_items[i];
						return result;
					}
				}
				result = null;
			}
			return result;
		}

		public virtual ItemInfo GetItemByTemplateID(int templateId)
		{
			return GetItemByTemplateID(int_2, templateId);
		}

		public virtual ItemInfo GetItemByTemplateID(int minSlot, int templateId)
		{
			ItemInfo result;
			lock (m_lock)
			{
				for (int i = minSlot; i < int_1; i++)
				{
					if (m_items[i] != null && m_items[i].TemplateID == templateId)
					{
						result = m_items[i];
						return result;
					}
				}
				result = null;
			}
			return result;
		}

		public virtual ItemInfo GetItemByTemplateIDMaxBegin(int templateId)
		{
			ItemInfo result;
			lock (m_lock)
			{
				for (int i = 0; i < int_2; i++)
				{
					if (m_items[i] != null && m_items[i].TemplateID == templateId)
					{
						result = m_items[i];
						return result;
					}
				}
				result = null;
			}
			return result;
		}

		public virtual ItemInfo GetEquipDressModel(int itemId, int templateId)
		{
			ItemInfo result;
			lock (m_lock)
			{
				for (int i = 0; i < int_1; i++)
				{
					if (m_items[i] != null && m_items[i].ItemID == itemId && m_items[i].TemplateID == templateId)
					{
						result = m_items[i];
						return result;
					}
				}
				result = null;
			}
			return result;
		}

		public virtual int GetItemCount(int templateId)
		{
			return GetItemCount(int_2, templateId);
		}

		public int GetItemCount(int minSlot, int templateId)
		{
			int num = 0;
			lock (m_lock)
			{
				for (int i = minSlot; i < int_1; i++)
				{
					if (m_items[i] != null && m_items[i].TemplateID == templateId)
					{
						num += m_items[i].Count;
					}
				}
			}
			return num;
		}

		public virtual List<ItemInfo> GetItems()
		{
			return GetItems(int_2, int_1);
		}

		public virtual List<ItemInfo> GetItems(int minSlot, int maxSlot)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			lock (m_lock)
			{
				for (int i = minSlot; i < maxSlot; i++)
				{
					if (m_items[i] != null)
					{
						list.Add(m_items[i]);
					}
				}
			}
			return list;
		}

		public virtual ItemInfo[] FindItemsByTempleteID(int templateID)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			lock (m_lock)
			{
				for (int i = 0; i < int_1; i++)
				{
					if (m_items[i] != null && m_items[i].TemplateID == templateID)
					{
						list.Add(m_items[i]);
					}
				}
			}
			return list.ToArray();
		}

		public int GetEmptyCount()
		{
			return GetEmptyCount(int_2);
		}

		public virtual int GetEmptyCount(int minSlot)
		{
			if (minSlot >= 0 && minSlot <= int_1 - 1)
			{
				int num = 0;
				lock (m_lock)
				{
					for (int i = minSlot; i < int_1; i++)
					{
						if (m_items[i] == null)
						{
							num++;
						}
					}
				}
				return num;
			}
			return 0;
		}

		public virtual void UseItem(ItemInfo item)
		{
			bool flag = false;
			if (!item.IsBinds && (item.Template.BindType == 2 || item.Template.BindType == 3))
			{
				item.IsBinds = true;
				flag = true;
			}
			if (!item.IsUsed)
			{
				item.IsUsed = true;
				item.BeginDate = DateTime.Now;
				flag = true;
			}
			if (flag)
			{
				OnPlaceChanged(item.Place);
			}
		}

		public virtual void UpdateItem(ItemInfo item)
		{
			if (item.BagType == int_0)
			{
				if (item.Count <= 0)
				{
					RemoveItem(item);
				}
				else
				{
					OnPlaceChanged(item.Place);
				}
			}
		}

		public virtual void UpdateAvatar(ItemInfo item)
		{
			lock (m_lock)
			{
				if (item.BagType == int_0)
				{
					m_items[item.Place].AvatarActivity = true;
				}
			}
		}

		public virtual void AllUpdateItem(List<ItemInfo> list)
		{
			foreach (ItemInfo item in list)
			{
				UpdateItem(item);
			}
		}

		public virtual bool RemoveCountFromStack(ItemInfo item, int count, eItemRemoveType type)
		{
			if (item == null)
			{
				return false;
			}
			if (count > 0 && item.BagType == int_0)
			{
				if (item.Count < count)
				{
					return false;
				}
				if (item.Count == count)
				{
					return RemoveItem(item);
				}
				item.Count -= count;
				OnPlaceChanged(item.Place);
				return true;
			}
			return false;
		}

		public virtual bool RemoveItem(ItemInfo item, eItemRemoveType type)
		{
			if (item == null)
			{
				return false;
			}
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < int_1; i++)
				{
					if (m_items[i] == item)
					{
						num = i;
						m_items[i] = null;
						break;
					}
				}
			}
			if (num != -1)
			{
				OnPlaceChanged(num);
				if (item.BagType == BagType && item.Place == num)
				{
					item.Place = -1;
					item.BagType = -1;
				}
			}
			return num != -1;
		}

		protected void OnPlaceChanged(int place)
		{
			if (!m_changedPlaces.Contains(place))
			{
				m_changedPlaces.Add(place);
			}
			if (int_3 <= 0 && m_changedPlaces.Count > 0)
			{
				UpdateChangedPlaces();
			}
		}

		public void DressEquip(int place)
		{
			if (m_items[place] != null)
			{
				m_items[place].IsBinds = true;
				OnPlaceChanged(place);
			}
		}

		public void BeginChanges()
		{
			Interlocked.Increment(ref int_3);
		}

		public void CommitChanges()
		{
			int num = Interlocked.Decrement(ref int_3);
			if (num < 0)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
				}
				Thread.VolatileWrite(ref int_3, 0);
			}
			if (num <= 0 && m_changedPlaces.Count > 0)
			{
				UpdateChangedPlaces();
			}
		}

		public virtual void UpdateChangedPlaces()
		{
			m_changedPlaces.Clear();
		}

		public ItemInfo[] GetRawSpaces()
		{
			lock (m_lock)
			{
				return m_items.Clone() as ItemInfo[];
			}
		}

		static AbstractInventory()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
