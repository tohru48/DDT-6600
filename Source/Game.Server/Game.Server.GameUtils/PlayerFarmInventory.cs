using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Logic;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public abstract class PlayerFarmInventory
	{
		private static readonly ILog ilog_0;

		protected object m_lock;

		private int int_0;

		private int int_1;

		protected UserFarmInfo m_farm;

		protected UserFieldInfo[] m_fields;

		protected UserFarmInfo m_otherFarm;

		protected UserFieldInfo[] m_otherFields;

		protected int m_farmstatus;

		protected bool m_midAutumnFlag;

		public UserFarmInfo OtherFarm => m_otherFarm;

		public UserFieldInfo[] OtherFields => m_otherFields;

		public UserFarmInfo CurrentFarm => m_farm;

		public UserFieldInfo[] CurrentFields => m_fields;

		public int Status => m_farmstatus;

		public int BeginSlot => int_1;

		public int Capalility
		{
			get
			{
				return int_0;
			}
			set
			{
				int_0 = ((value >= 0) ? ((value > m_fields.Length) ? m_fields.Length : value) : 0);
			}
		}

		public bool midAutumnFlag => m_midAutumnFlag;

		public bool IsEmpty(int slot)
		{
			return slot < 0 || slot >= int_0 || m_fields[slot] == null;
		}

		public PlayerFarmInventory(int capability, int beginSlot)
		{
			m_lock = new object();
			int_0 = capability;
			int_1 = beginSlot;
			m_fields = new UserFieldInfo[capability];
			m_otherFields = new UserFieldInfo[capability];
			m_farmstatus = 0;
		}

		public int ripeNum()
		{
			int num = 0;
			lock (m_lock)
			{
				for (int i = 0; i < m_fields.Length; i++)
				{
					if (m_fields[i] != null && m_fields[i].SeedID != 0)
					{
						num++;
					}
				}
			}
			return num;
		}

		public virtual void GropFastforward(bool isAllField, int fieldId)
		{
			lock (m_lock)
			{
				if (isAllField)
				{
					for (int i = 0; i < m_fields.Length; i++)
					{
						if (m_fields[i] != null && m_fields[i].SeedID != 0)
						{
							m_fields[i].AccelerateTime += GameProperties.FastGrowSubTime;
						}
					}
				}
				else if (m_fields[fieldId] != null && m_fields[fieldId].SeedID != 0)
				{
					m_fields[fieldId].AccelerateTime += GameProperties.FastGrowSubTime;
				}
			}
		}

		public bool AddField(UserFieldInfo item)
		{
			return AddField(item, int_1);
		}

		public bool AddField(UserFieldInfo item, int minSlot)
		{
			if (item == null)
			{
				return false;
			}
			int place = FindFirstEmptySlot(minSlot);
			return AddFieldTo(item, place);
		}

		public virtual bool AddFieldTo(UserFieldInfo item, int place)
		{
			if (item == null || place >= int_0 || place < 0)
			{
				return false;
			}
			lock (m_lock)
			{
				m_fields[place] = item;
				if (m_fields[place] != null)
				{
					place = -1;
				}
				else
				{
					m_fields[place] = item;
					item.FieldID = place;
				}
			}
			return place != -1;
		}

		public virtual bool AddOtherFieldTo(UserFieldInfo item, int place)
		{
			if (item == null || place >= int_0 || place < 0)
			{
				return false;
			}
			lock (m_lock)
			{
				m_otherFields[place] = item;
				if (m_otherFields[place] != null)
				{
					place = -1;
				}
				else
				{
					m_otherFields[place] = item;
					item.FieldID = place;
				}
			}
			return place != -1;
		}

		public virtual bool RemoveField(UserFieldInfo item)
		{
			if (item == null)
			{
				return false;
			}
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < int_0; i++)
				{
					if (m_fields[i] == item)
					{
						num = i;
						m_fields[i] = null;
						break;
					}
				}
			}
			return num != -1;
		}

		public virtual bool RemoveOtherField(UserFieldInfo item)
		{
			if (item == null)
			{
				return false;
			}
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < int_0; i++)
				{
					if (m_otherFields[i] == item)
					{
						num = i;
						m_otherFields[i] = null;
						break;
					}
				}
			}
			return num != -1;
		}

		public bool RemoveFieldAt(int place)
		{
			return RemoveField(GetFieldAt(place));
		}

		public virtual UserFieldInfo GetFieldAt(int slot)
		{
			if (slot >= 0 && slot < int_0)
			{
				return m_fields[slot];
			}
			return null;
		}

		public int FindFirstEmptySlot()
		{
			return FindFirstEmptySlot(int_1);
		}

		public int FindFirstEmptySlot(int minSlot)
		{
			if (minSlot >= int_0)
			{
				return -1;
			}
			int result;
			lock (m_lock)
			{
				for (int i = minSlot; i < int_0; i++)
				{
					if (m_fields[i] == null)
					{
						result = i;
						return result;
					}
				}
				result = -1;
			}
			return result;
		}

		public void ClearFields()
		{
			lock (m_lock)
			{
				for (int i = int_1; i < int_0; i++)
				{
					if (m_fields[i] != null)
					{
						RemoveField(m_fields[i]);
					}
				}
			}
		}

		public void ClearOtherFields()
		{
			lock (m_lock)
			{
				for (int i = int_1; i < int_0; i++)
				{
					if (m_otherFields[i] != null)
					{
						RemoveOtherField(m_otherFields[i]);
					}
				}
			}
		}

		public int FindLastEmptySlot()
		{
			int result;
			lock (m_lock)
			{
				for (int num = int_0 - 1; num >= 0; num--)
				{
					if (m_fields[num] == null)
					{
						result = num;
						return result;
					}
				}
				result = -1;
			}
			return result;
		}

		public virtual void ClearFarm()
		{
			lock (m_lock)
			{
				m_farm = null;
			}
		}

		public virtual void ResetFarmProp()
		{
			lock (m_lock)
			{
				if (m_farm != null)
				{
					m_farm.isArrange = false;
					m_farm.buyExpRemainNum = 20;
				}
			}
		}

		public virtual void ClearIsArrange()
		{
			lock (m_lock)
			{
				m_farm.isArrange = true;
			}
		}

		public virtual void UpdateGainCount(int fieldId, int count)
		{
			lock (m_lock)
			{
				m_fields[fieldId].GainCount = count;
			}
		}

		public virtual void UpdateFarm(UserFarmInfo farm)
		{
			lock (m_lock)
			{
				m_farm = farm;
			}
		}

		public virtual void UpdateOtherFarm(UserFarmInfo farm)
		{
			lock (m_lock)
			{
				m_otherFarm = farm;
			}
		}

		public virtual bool GrowField(int fieldId, int templateID)
		{
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(templateID);
			lock (m_lock)
			{
				m_fields[fieldId].SeedID = ıtemTemplateInfo.TemplateID;
				m_fields[fieldId].PlantTime = DateTime.Now;
				m_fields[fieldId].GainCount = ıtemTemplateInfo.Property2;
				m_fields[fieldId].FieldValidDate = ıtemTemplateInfo.Property3;
			}
			return true;
		}

		public virtual bool killCropField(int fieldId)
		{
			lock (m_lock)
			{
				if (m_fields[fieldId] != null)
				{
					m_fields[fieldId].SeedID = 0;
					m_fields[fieldId].FieldValidDate = 1;
					m_fields[fieldId].AccelerateTime = 0;
					m_fields[fieldId].GainCount = 0;
					return true;
				}
			}
			return false;
		}

		public virtual void StopHelperSwitchField()
		{
			lock (m_lock)
			{
				m_farm.isFarmHelper = false;
				m_farm.isAutoId = 0;
				m_farm.AutoPayTime = DateTime.Now;
				m_farm.AutoValidDate = 0;
				m_farm.GainFieldId = 0;
				m_farm.KillCropId = 0;
			}
		}

		public virtual void CreateFarm(int ID, string name)
		{
			string value = PetMgr.FindConfig("PayFieldMoney").Value;
			string value2 = PetMgr.FindConfig("PayAutoMoney").Value;
			UpdateFarm(new UserFarmInfo
			{
				ID = 0,
				FarmID = ID,
				FarmerName = name,
				isFarmHelper = false,
				isAutoId = 0,
				AutoPayTime = DateTime.Now,
				AutoValidDate = 1,
				GainFieldId = 0,
				KillCropId = 0,
				PayAutoMoney = value2,
				PayFieldMoney = value,
				buyExpRemainNum = 20,
				isArrange = false,
				TreeLevel = 0,
				TreeExp = 0,
				LoveScore = 0,
				MonsterExp = 0,
				PoultryState = 0,
				CountDownTime = DateTime.Now,
				TreeCostExp = 0
			});
			CreateNewField(ID, 0, 8);
		}

		public virtual bool HelperSwitchFields(bool isHelper, int seedID, int seedTime, int haveCount, int getCount)
		{
			object obj = default(object);
			if (isHelper)
			{
				bool lockTaken = false;
				try
				{
					Monitor.Enter(obj = m_lock, ref lockTaken);
					for (int i = 0; i < m_fields.Length; i++)
					{
						if (m_fields[i] != null)
						{
							m_fields[i].SeedID = 0;
							m_fields[i].FieldValidDate = 1;
							m_fields[i].AccelerateTime = 0;
							m_fields[i].GainCount = 0;
						}
					}
				}
				finally
				{
					if (lockTaken)
					{
						Monitor.Exit(obj);
					}
				}
			}
			bool lockTaken2 = false;
			try
			{
				Monitor.Enter(obj = m_lock, ref lockTaken2);
				m_farm.isFarmHelper = isHelper;
				m_farm.isAutoId = seedID;
				m_farm.AutoPayTime = DateTime.Now;
				m_farm.AutoValidDate = seedTime;
				m_farm.GainFieldId = getCount / 10;
				m_farm.KillCropId = getCount;
			}
			finally
			{
				if (lockTaken2)
				{
					Monitor.Exit(obj);
				}
			}
			return true;
		}

		public virtual void CreateNewField(int ID, int minslot, int maxslot)
		{
			for (int i = minslot; i < maxslot; i++)
			{
				AddFieldTo(new UserFieldInfo
				{
					ID = 0,
					FarmID = ID,
					FieldID = i,
					SeedID = 0,
					PayTime = DateTime.Now.AddYears(100),
					payFieldTime = 876000,
					PlantTime = DateTime.Now,
					GainCount = 0,
					FieldValidDate = 1,
					AccelerateTime = 0,
					AutomaticTime = DateTime.Now,
					IsExit = true
				}, i);
			}
		}

		public virtual bool CreateField(int ID, List<int> fieldIds, int payFieldTime)
		{
			for (int i = 0; i < fieldIds.Count; i++)
			{
				int num = fieldIds[i];
				if (m_fields[num] == null)
				{
					AddFieldTo(new UserFieldInfo
					{
						FarmID = ID,
						FieldID = num,
						SeedID = 0,
						PayTime = DateTime.Now.AddDays(payFieldTime / 24),
						payFieldTime = payFieldTime,
						PlantTime = DateTime.Now,
						GainCount = 0,
						FieldValidDate = 1,
						AccelerateTime = 0,
						AutomaticTime = DateTime.Now,
						IsExit = true
					}, num);
				}
				else
				{
					m_fields[num].PayTime = DateTime.Now.AddDays(payFieldTime / 24);
					m_fields[num].payFieldTime = payFieldTime;
				}
			}
			return true;
		}

		public virtual UserFieldInfo[] GetFields()
		{
			List<UserFieldInfo> list = new List<UserFieldInfo>();
			lock (m_lock)
			{
				for (int i = 0; i < int_0; i++)
				{
					if (m_fields[i] != null && m_fields[i].IsValidField())
					{
						list.Add(m_fields[i]);
					}
				}
			}
			return list.ToArray();
		}

		public virtual UserFieldInfo[] GetOtherFields()
		{
			List<UserFieldInfo> list = new List<UserFieldInfo>();
			lock (m_lock)
			{
				for (int i = 0; i < int_0; i++)
				{
					if (m_otherFields[i] != null && m_otherFields[i].IsValidField())
					{
						list.Add(m_otherFields[i]);
					}
				}
			}
			return list.ToArray();
		}

		public virtual UserFieldInfo GetOtherFieldAt(int slot)
		{
			if (slot >= 0 && slot < int_0)
			{
				return m_otherFields[slot];
			}
			return null;
		}

		public int GetEmptyCount()
		{
			return GetEmptyCount(int_1);
		}

		public virtual int GetEmptyCount(int minSlot)
		{
			if (minSlot >= 0 && minSlot <= int_0 - 1)
			{
				int num = 0;
				lock (m_lock)
				{
					for (int i = minSlot; i < int_0; i++)
					{
						if (m_fields[i] == null)
						{
							num++;
						}
					}
				}
				return num;
			}
			return 0;
		}

		public virtual int payFieldMoneyToWeek()
		{
			return int.Parse(m_farm.PayFieldMoney.Split('|')[0].Split(',')[1]);
		}

		public virtual int payFieldTimeToWeek()
		{
			return int.Parse(m_farm.PayFieldMoney.Split('|')[0].Split(',')[0]);
		}

		public virtual int payFieldMoneyToMonth()
		{
			return int.Parse(m_farm.PayFieldMoney.Split('|')[1].Split(',')[1]);
		}

		public virtual int payFieldTimeToMonth()
		{
			return int.Parse(m_farm.PayFieldMoney.Split('|')[1].Split(',')[0]);
		}

		public virtual UserFarmInfo CreateFarmForNulll(int ID)
		{
			UserFarmInfo userFarmInfo = new UserFarmInfo();
			userFarmInfo.FarmID = ID;
			userFarmInfo.FarmerName = "Null";
			userFarmInfo.isFarmHelper = false;
			userFarmInfo.isAutoId = 0;
			userFarmInfo.AutoPayTime = DateTime.Now;
			userFarmInfo.AutoValidDate = 1;
			userFarmInfo.GainFieldId = 0;
			userFarmInfo.KillCropId = 0;
			userFarmInfo.isArrange = true;
			return userFarmInfo;
		}

		public virtual UserFieldInfo[] CreateFieldsForNull(int ID)
		{
			List<UserFieldInfo> list = new List<UserFieldInfo>();
			for (int i = 0; i < 8; i++)
			{
				list.Add(new UserFieldInfo
				{
					FarmID = ID,
					FieldID = i,
					SeedID = 0,
					PayTime = DateTime.Now,
					payFieldTime = 365000,
					PlantTime = DateTime.Now,
					GainCount = 0,
					FieldValidDate = 1,
					AccelerateTime = 0,
					AutomaticTime = DateTime.Now
				});
			}
			return list.ToArray();
		}

		static PlayerFarmInventory()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
