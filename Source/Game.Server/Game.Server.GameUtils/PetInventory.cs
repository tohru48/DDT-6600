using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using Bussiness;
using Game.Logic;
using Game.Server.GameObjects;
using log4net;
using Newtonsoft.Json;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PetInventory : PetAbstractInventory
	{
		private static readonly ILog ilog_1;

		private bool bool_0;

		private List<UsersPetinfo> list_0;

		protected GamePlayer m_player;

		private UsersPetFormInfo usersPetFormInfo_0;

		private List<PetFormActiveListInfo> list_1;

		private EatPetsInfo eatPetsInfo_0;

		public GamePlayer Player => m_player;

		public UsersPetFormInfo PetForm => usersPetFormInfo_0;

		public List<PetFormActiveListInfo> ActiveList => list_1;

		public EatPetsInfo EatPets => eatPetsInfo_0;

		public PetInventory(GamePlayer player, bool saveTodb, int capibility, int aCapability, int beginSlot)
			: base(capibility, aCapability, beginSlot)
		{
			m_player = player;
			bool_0 = saveTodb;
			list_0 = new List<UsersPetinfo>();
			list_1 = new List<PetFormActiveListInfo>();
		}

		public virtual void LoadFromDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			int ıD = m_player.PlayerCharacter.ID;
			UsersPetinfo[] userPetSingles = playerBussiness.GetUserPetSingles(ıD);
			UsersPetinfo[] userAdoptPetSingles = playerBussiness.GetUserAdoptPetSingles(ıD);
			UsersPetFormInfo allUsersPetFormByID = playerBussiness.GetAllUsersPetFormByID(ıD);
			EatPetsInfo allEatPetsByID = playerBussiness.GetAllEatPetsByID(ıD);
			BeginChanges();
			try
			{
				UsersPetinfo[] array = userPetSingles;
				foreach (UsersPetinfo usersPetinfo in array)
				{
					usersPetinfo.PetEquip = UpdatePetEquip(usersPetinfo);
					AddPetTo(usersPetinfo, usersPetinfo.Place);
				}
				UsersPetinfo[] array2 = userAdoptPetSingles;
				foreach (UsersPetinfo usersPetinfo2 in array2)
				{
					AddAdoptPetTo(usersPetinfo2, usersPetinfo2.Place);
				}
				if (allUsersPetFormByID == null)
				{
					usersPetFormInfo_0 = new UsersPetFormInfo();
					usersPetFormInfo_0.UserID = ıD;
					usersPetFormInfo_0.PetsID = -1;
					usersPetFormInfo_0.ActivePets = "[]";
				}
				else
				{
					usersPetFormInfo_0 = allUsersPetFormByID;
				}
				if (allEatPetsByID == null)
				{
					eatPetsInfo_0 = new EatPetsInfo();
					eatPetsInfo_0.UserID = ıD;
				}
				else
				{
					eatPetsInfo_0 = allEatPetsByID;
				}
			}
			finally
			{
				DeserializeActivityWeapons();
				CommitChanges();
			}
		}

		public virtual void SaveToDatabase(bool saveAdopt)
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			bool lockTaken = false;
			object obj = default(object);
			try
			{
				Monitor.Enter(obj = m_lock, ref lockTaken);
				for (int i = 0; i < m_pets.Length; i++)
				{
					UsersPetinfo usersPetinfo = m_pets[i];
					if (usersPetinfo != null && usersPetinfo.IsDirty)
					{
						if (usersPetinfo.ID > 0)
						{
							playerBussiness.UpdateUserPet(usersPetinfo);
						}
						else
						{
							playerBussiness.AddUserPet(usersPetinfo);
						}
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
			if (saveAdopt)
			{
				bool lockTaken2 = false;
				try
				{
					Monitor.Enter(obj = m_lock, ref lockTaken2);
					for (int j = 0; j < m_adoptPets.Length; j++)
					{
						UsersPetinfo usersPetinfo2 = m_adoptPets[j];
						if (usersPetinfo2 != null && usersPetinfo2.IsDirty && usersPetinfo2.ID == 0)
						{
							playerBussiness.AddUserAdoptPet(usersPetinfo2, isUse: false);
						}
					}
				}
				finally
				{
					if (lockTaken2)
					{
						Monitor.Exit(obj);
					}
				}
			}
			bool lockTaken3 = false;
			try
			{
				Monitor.Enter(obj = m_lock, ref lockTaken3);
				if (usersPetFormInfo_0 != null && usersPetFormInfo_0.IsDirty)
				{
					SerializeActivityWeapons();
					if (usersPetFormInfo_0.ID == 0)
					{
						playerBussiness.AddUsersPetForm(usersPetFormInfo_0);
					}
					else
					{
						playerBussiness.UpdateUsersPetForm(usersPetFormInfo_0);
					}
				}
			}
			finally
			{
				if (lockTaken3)
				{
					Monitor.Exit(obj);
				}
			}
			bool lockTaken4 = false;
			try
			{
				Monitor.Enter(obj = m_lock, ref lockTaken4);
				if (eatPetsInfo_0 != null && eatPetsInfo_0.IsDirty)
				{
					if (eatPetsInfo_0.ID == 0)
					{
						playerBussiness.AddEatPets(eatPetsInfo_0);
					}
					else
					{
						playerBussiness.UpdateEatPets(eatPetsInfo_0);
					}
				}
			}
			finally
			{
				if (lockTaken4)
				{
					Monitor.Exit(obj);
				}
			}
			bool lockTaken5 = false;
			try
			{
				Monitor.Enter(obj = m_lock, ref lockTaken5);
				foreach (UsersPetinfo item in list_0)
				{
					playerBussiness.UpdateUserPet(item);
				}
				list_0.Clear();
			}
			finally
			{
				if (lockTaken5)
				{
					Monitor.Exit(obj);
				}
			}
		}

		public void DeserializeActivityWeapons()
		{
			try
			{
				if (PetForm != null && !string.IsNullOrEmpty(PetForm.ActivePets))
				{
					list_1 = JsonConvert.DeserializeObject<List<PetFormActiveListInfo>>(PetForm.ActivePets);
				}
			}
			catch (Exception exception)
			{
				ilog_1.Error("DeserializeMagicHouse fail: ", exception);
			}
		}

		public void SerializeActivityWeapons()
		{
			try
			{
				usersPetFormInfo_0.ActivePets = JsonConvert.SerializeObject(list_1);
			}
			catch (Exception exception)
			{
				ilog_1.Error("DeserializeMagicHouse fail: ", exception);
			}
		}

		public void UpdatePetFormProp(int hp, ref int enhanceHp, ref int reduceDamagePow)
		{
			int num = 0;
			int num2 = 0;
			foreach (PetFormActiveListInfo active in ActiveList)
			{
				PetFormDataInfo petFormDataInfo = PetMgr.FindPetFormData(active.TemplateID);
				if (petFormDataInfo != null)
				{
					num += petFormDataInfo.HeathUp;
					num2 += petFormDataInfo.DamageReduce;
				}
			}
			enhanceHp = hp + hp * num / 100;
			reduceDamagePow = num2;
		}

		public override bool AddPetTo(UsersPetinfo pet, int place)
		{
			if (base.AddPetTo(pet, place))
			{
				pet.UserID = m_player.PlayerCharacter.ID;
				return true;
			}
			return false;
		}

		public bool AddPetForm(int petId)
		{
			if (petId > 0)
			{
				for (int i = 0; i < ActiveList.Count; i++)
				{
					ActiveList[i].IsFollow = false;
				}
				PetFormActiveListInfo petFormActiveListInfo = new PetFormActiveListInfo();
				petFormActiveListInfo.TemplateID = petId;
				petFormActiveListInfo.IsFollow = true;
				lock (m_lock)
				{
					list_1.Add(petFormActiveListInfo);
				}
			}
			return false;
		}

		public PetFormActiveListInfo GetPetForm(int petId)
		{
			foreach (PetFormActiveListInfo active in ActiveList)
			{
				if (active.TemplateID == petId)
				{
					return active;
				}
			}
			return null;
		}

		public bool PetFormFollow(int petId, bool isFollow)
		{
			for (int i = 0; i < ActiveList.Count; i++)
			{
				ActiveList[i].IsFollow = false;
				if (ActiveList[i].TemplateID == petId)
				{
					ActiveList[i].IsFollow = isFollow;
					usersPetFormInfo_0.PetsID = petId;
				}
			}
			return false;
		}

		public List<ItemInfo> UpdatePetEquip(UsersPetinfo pet)
		{
			return m_player.PetEquipBag.GetAllPetEquipByPetID(pet.ID);
		}

		public virtual bool OnChangedPetEquip(int place)
		{
			lock (m_lock)
			{
				if (m_pets[place] != null)
				{
					m_pets[place].PetEquip = UpdatePetEquip(m_pets[place]);
					if (m_pets[place].IsEquip)
					{
						m_player.EquipBag.UpdatePlayerProperties();
					}
				}
			}
			OnPlaceChanged(place);
			return true;
		}

		public virtual void ReduceHunger()
		{
			UsersPetinfo petIsEquip = GetPetIsEquip();
			if (petIsEquip == null)
			{
				return;
			}
			int num = 40;
			int num2 = 100;
			if (petIsEquip.Hunger >= 100)
			{
				if (petIsEquip.Level >= 60)
				{
					petIsEquip.Hunger -= num2;
				}
				else
				{
					petIsEquip.Hunger -= num;
				}
				UpdatePet(petIsEquip, petIsEquip.Place);
			}
		}

		public override bool RemovePet(UsersPetinfo pet)
		{
			if (!base.RemovePet(pet))
			{
				return false;
			}
			lock (list_0)
			{
				pet.IsExit = false;
				list_0.Add(pet);
			}
			return true;
		}

		public override bool AddAdoptPetTo(UsersPetinfo pet, int place)
		{
			return base.AddAdoptPetTo(pet, place);
		}

		public override bool RemoveAdoptPet(UsersPetinfo pet)
		{
			return base.RemoveAdoptPet(pet);
		}

		public override void UpdateChangedPlaces()
		{
			int[] slots = m_changedPlaces.ToArray();
			m_player.Out.SendUpdateUserPet(this, slots);
			m_player.Out.SendEatPetsInfo(eatPetsInfo_0);
			base.UpdateChangedPlaces();
		}

		public virtual void ClearAdoptPets()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				for (int i = 0; i < base.Int32_0; i++)
				{
					if (m_adoptPets[i] != null && m_adoptPets[i].ID > 0)
					{
						playerBussiness.ClearAdoptPet(m_adoptPets[i].ID);
					}
					m_adoptPets[i] = null;
				}
			}
		}

		static PetInventory()
		{
			ilog_1 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
