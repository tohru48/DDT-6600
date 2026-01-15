using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Game.Logic;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public abstract class PetAbstractInventory
	{
		private static readonly ILog ilog_0;

		protected object m_lock;

		private int int_0;

		private int int_1;

		private int ljhnbxwxTy;

		protected UsersPetinfo[] m_pets;

		protected UsersPetinfo[] m_adoptPets;

		protected ItemInfo[] m_adoptItems;

		protected ItemInfo[] m_petEquipItems;

		protected List<int> m_changedPlaces;

		private int int_2;

		public int BeginSlot => ljhnbxwxTy;

		public int Capalility
		{
			get
			{
				return int_0;
			}
			set
			{
				int_0 = ((value >= 0) ? ((value > m_pets.Length) ? m_pets.Length : value) : 0);
			}
		}

		public int Int32_0
		{
			get
			{
				return int_1;
			}
			set
			{
				int_1 = ((value >= 0) ? ((value > m_adoptPets.Length) ? m_adoptPets.Length : value) : 0);
			}
		}

		public PetAbstractInventory(int capability, int aCapability, int beginSlot)
		{
			m_lock = new object();
			m_changedPlaces = new List<int>();
			int_0 = capability;
			int_1 = aCapability;
			ljhnbxwxTy = beginSlot;
			m_pets = new UsersPetinfo[capability];
			m_adoptPets = new UsersPetinfo[aCapability];
			m_adoptItems = new ItemInfo[aCapability];
			m_petEquipItems = new ItemInfo[capability * 3];
		}

		public virtual UsersPetinfo GetPetIsEquip()
		{
			for (int i = 0; i < int_0; i++)
			{
				if (m_pets[i] != null && m_pets[i].IsEquip)
				{
					return m_pets[i];
				}
			}
			return null;
		}

		public virtual bool AddAdoptPetTo(UsersPetinfo pet, int place)
		{
			if (pet == null || place >= int_1 || place < 0)
			{
				return false;
			}
			lock (m_lock)
			{
				if (m_adoptPets[place] != null)
				{
					place = -1;
				}
				else
				{
					m_adoptPets[place] = pet;
					pet.Place = place;
				}
			}
			return place != -1;
		}

		public virtual bool RemoveAdoptPet(UsersPetinfo pet)
		{
			if (pet == null)
			{
				return false;
			}
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < int_1; i++)
				{
					if (m_adoptPets[i] == pet)
					{
						num = i;
						m_adoptPets[i] = null;
						break;
					}
				}
			}
			return num != -1;
		}

		public virtual bool AddPetTo(UsersPetinfo pet, int place)
		{
			if (pet != null && place < int_0 && place >= 0)
			{
				lock (m_lock)
				{
					if (m_pets[place] == null)
					{
						m_pets[place] = pet;
						pet.Place = place;
					}
					else
					{
						place = -1;
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

		public virtual bool RemovePet(UsersPetinfo pet)
		{
			if (pet == null)
			{
				return false;
			}
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < int_0; i++)
				{
					if (m_pets[i] == pet)
					{
						num = i;
						m_pets[i] = null;
						break;
					}
				}
			}
			if (num != -1)
			{
				OnPlaceChanged(num);
				pet.Place = -1;
			}
			return num != -1;
		}

		public virtual UsersPetinfo GetAdoptPetAt(int slot)
		{
			if (slot >= 0 && slot < int_1)
			{
				return m_adoptPets[slot];
			}
			return null;
		}

		public virtual UsersPetinfo GetPetAt(int slot)
		{
			if (slot >= 0 && slot < int_0)
			{
				return m_pets[slot];
			}
			return null;
		}

		public virtual UsersPetinfo[] GetAdoptPet()
		{
			List<UsersPetinfo> list = new List<UsersPetinfo>();
			for (int i = 0; i < int_1; i++)
			{
				if (m_adoptPets[i] != null && m_adoptPets[i].IsExit)
				{
					list.Add(m_adoptPets[i]);
				}
			}
			list.Add(PetMgr.CreateNewPet());
			return list.ToArray();
		}

		public int FindFirstEmptySlot()
		{
			return FindFirstEmptySlot(ljhnbxwxTy);
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
					if (m_pets[i] == null)
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
				for (int num = int_0 - 1; num >= 0; num--)
				{
					if (m_pets[num] == null)
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
			lock (m_lock)
			{
				for (int i = 0; i < int_0; i++)
				{
					m_pets[i] = null;
				}
			}
		}

		public virtual UsersPetinfo GetPetByTemplateID(int minSlot, int templateId)
		{
			UsersPetinfo result;
			lock (m_lock)
			{
				for (int i = minSlot; i < int_0; i++)
				{
					if (m_pets[i] != null && m_pets[i].TemplateID == templateId)
					{
						result = m_pets[i];
						return result;
					}
				}
				result = null;
			}
			return result;
		}

		public virtual UsersPetinfo[] GetPets()
		{
			List<UsersPetinfo> list = new List<UsersPetinfo>();
			for (int i = 0; i < int_0; i++)
			{
				if (m_pets[i] != null)
				{
					list.Add(m_pets[i]);
				}
			}
			return list.ToArray();
		}

		public int GetEmptyCount()
		{
			return GetEmptyCount(ljhnbxwxTy);
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
						if (m_pets[i] == null)
						{
							num++;
						}
					}
				}
				return num;
			}
			return 0;
		}

		protected void OnPlaceChanged(int place)
		{
			if (!m_changedPlaces.Contains(place))
			{
				m_changedPlaces.Add(place);
			}
			if (int_2 <= 0 && m_changedPlaces.Count > 0)
			{
				UpdateChangedPlaces();
			}
		}

		public void BeginChanges()
		{
			Interlocked.Increment(ref int_2);
		}

		public void CommitChanges()
		{
			int num = Interlocked.Decrement(ref int_2);
			if (num < 0)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
				}
				Thread.VolatileWrite(ref int_2, 0);
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

		public virtual bool RenamePet(int place, string name)
		{
			lock (m_lock)
			{
				if (m_pets[place] != null)
				{
					m_pets[place].Name = name;
				}
			}
			OnPlaceChanged(place);
			return true;
		}

		public bool IsEquipSkill(int slot, string kill)
		{
			List<string> skillEquip = m_pets[slot].GetSkillEquip();
			for (int i = 0; i < skillEquip.Count; i++)
			{
				if (skillEquip[i].Split(',')[0] == kill)
				{
					return false;
				}
			}
			return true;
		}

		public virtual bool EquipSkillPet(int place, int killId, int killindex)
		{
			string skill = killId + "," + killindex;
			UsersPetinfo pet = m_pets[place];
			lock (m_lock)
			{
				if (killId == 0)
				{
					m_pets[place].SkillEquip = SetSkillEquip(pet, killindex, skill);
					OnPlaceChanged(place);
					return true;
				}
				if (IsEquipSkill(place, killId.ToString()))
				{
					m_pets[place].SkillEquip = SetSkillEquip(pet, killindex, skill);
					OnPlaceChanged(place);
					return true;
				}
			}
			return false;
		}

		public string SetSkillEquip(UsersPetinfo pet, int place, string skill)
		{
			List<string> skillEquip = pet.GetSkillEquip();
			skillEquip[place] = skill;
			string text = skillEquip[0];
			for (int i = 1; i < skillEquip.Count; i++)
			{
				text = text + "|" + skillEquip[i];
			}
			return text;
		}

		public virtual bool UpdatePet(UsersPetinfo pet, int place)
		{
			if (pet == null)
			{
				return false;
			}
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < m_pets.Length; i++)
				{
					if (m_pets[i] != null)
					{
						num = m_pets[i].Place;
						if (num == place)
						{
							m_pets[i] = pet;
						}
						OnPlaceChanged(num);
					}
				}
			}
			return num > -1;
		}

		public virtual bool EquipPet(int place, bool isEquip)
		{
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < m_pets.Length; i++)
				{
					if (m_pets[i] == null)
					{
						continue;
					}
					num = m_pets[i].Place;
					if (num == place)
					{
						if (m_pets[i].Hunger == 0)
						{
							return false;
						}
						m_pets[i].IsEquip = isEquip;
					}
					else
					{
						m_pets[i].IsEquip = false;
					}
					OnPlaceChanged(num);
				}
			}
			return num > -1;
		}

		public virtual bool UpGracePet(UsersPetinfo pet, int place, bool isUpdateProp, int min, int max, int Level, ref string msg)
		{
			if (isUpdateProp)
			{
				int blood = 0;
				int attack = 0;
				int defence = 0;
				int agility = 0;
				int lucky = 0;
				PetMgr.PlusPetProp(pet, min, max, ref blood, ref attack, ref defence, ref agility, ref lucky);
				pet.Blood = blood;
				pet.Attack = attack;
				pet.Defence = defence;
				pet.Agility = agility;
				pet.Luck = lucky;
				int num = PetMgr.UpdateEvolution(pet.TemplateID, max);
				pet.TemplateID = ((num == 0) ? pet.TemplateID : num);
				string skill = pet.Skill;
				string text = PetMgr.UpdateSkillPet(max, pet.TemplateID, Level);
				pet.Skill = ((text == "") ? skill : text);
				pet.SkillEquip = PetMgr.ActiveEquipSkill(max);
				if (max > min)
				{
					msg = pet.Name + " thăng cấp " + max;
				}
			}
			lock (m_lock)
			{
				m_pets[place] = pet;
			}
			OnPlaceChanged(place);
			return true;
		}

		static PetAbstractInventory()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
