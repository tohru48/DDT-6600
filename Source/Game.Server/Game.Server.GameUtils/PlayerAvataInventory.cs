using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerAvataInventory : PlayerInventory
	{
		private Dictionary<int, List<ItemInfo>> dictionary_0;

		private int int_4;

		private bool bool_2;

		private Dictionary<int, Dictionary<int, ItemInfo>> dictionary_1;

		private Dictionary<int, Dictionary<int, ItemInfo>> dictionary_2;

		private Dictionary<int, UserAvatarColectionInfo> dictionary_3;

		private Dictionary<int, UserAvatarColectionInfo> dictionary_4;

		[CompilerGenerated]
		private static Func<KeyValuePair<int, Dictionary<int, ItemInfo>>, int> func_0;

		[CompilerGenerated]
		private static Func<IGrouping<int, KeyValuePair<int, Dictionary<int, ItemInfo>>>, int> func_1;

		[CompilerGenerated]
		private static Func<IGrouping<int, KeyValuePair<int, Dictionary<int, ItemInfo>>>, Dictionary<int, ItemInfo>> func_2;

		[CompilerGenerated]
		private static Func<KeyValuePair<int, UserAvatarColectionInfo>, int> func_3;

		[CompilerGenerated]
		private static Func<IGrouping<int, KeyValuePair<int, UserAvatarColectionInfo>>, int> func_4;

		[CompilerGenerated]
		private static Func<IGrouping<int, KeyValuePair<int, UserAvatarColectionInfo>>, UserAvatarColectionInfo> func_5;

		public Dictionary<int, List<ItemInfo>> DressModelArr => dictionary_0;

		public int CurrentModel
		{
			get
			{
				return int_4;
			}
			set
			{
				int_4 = value;
			}
		}

		public bool LoadDefaulModelArr
		{
			get
			{
				return bool_2;
			}
			set
			{
				bool_2 = value;
			}
		}

		public Dictionary<int, Dictionary<int, ItemInfo>> MaleItemDic => dictionary_1;

		public Dictionary<int, Dictionary<int, ItemInfo>> FemaleItemDic => dictionary_2;

		public Dictionary<int, UserAvatarColectionInfo> MaleUnitDic => dictionary_3;

		public Dictionary<int, UserAvatarColectionInfo> FemaleUnitDic => dictionary_4;

		public PlayerAvataInventory(GamePlayer player)
			: base(player, saveTodb: true, 392, 0, 80, autoStack: false)
		{
			List<ItemInfo> value = new List<ItemInfo>();
			dictionary_0 = new Dictionary<int, List<ItemInfo>>();
			dictionary_0.Add(0, value);
			dictionary_0.Add(1, value);
			dictionary_0.Add(2, value);
			bool_2 = false;
			dictionary_1 = new Dictionary<int, Dictionary<int, ItemInfo>>();
			dictionary_3 = new Dictionary<int, UserAvatarColectionInfo>();
			dictionary_2 = new Dictionary<int, Dictionary<int, ItemInfo>>();
			dictionary_4 = new Dictionary<int, UserAvatarColectionInfo>();
		}

		public virtual void LoadUserAvatarFromDatabase()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			UserAvatarColectionInfo[] singleUserAvatarColectionInfo = playerBussiness.GetSingleUserAvatarColectionInfo(base.Player.PlayerCharacter.ID);
			if (singleUserAvatarColectionInfo.Length > 0)
			{
				UserAvatarColectionInfo[] array = singleUserAvatarColectionInfo;
				foreach (UserAvatarColectionInfo userAvatarColectionInfo in array)
				{
					AddAvatarColectionInfo(userAvatarColectionInfo.dataId, userAvatarColectionInfo.Sex, userAvatarColectionInfo);
				}
			}
		}

		public virtual void SaveUserAvatarToDatabase()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			bool lockTaken = false;
			object obj = default(object);
			try
			{
				Monitor.Enter(obj = m_lock, ref lockTaken);
				if (dictionary_3.Count > 0)
				{
					foreach (UserAvatarColectionInfo value in dictionary_3.Values)
					{
						if (value != null && value.IsDirty)
						{
							if (value.ID > 0)
							{
								playerBussiness.UpdateUserAvatarColectionInfo(value);
							}
							else
							{
								playerBussiness.AddUserAvatarColectionInfo(value);
							}
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
			bool lockTaken2 = false;
			try
			{
				Monitor.Enter(obj = m_lock, ref lockTaken2);
				foreach (UserAvatarColectionInfo value2 in dictionary_4.Values)
				{
					if (value2 != null && value2.IsDirty)
					{
						if (value2.ID > 0)
						{
							playerBussiness.UpdateUserAvatarColectionInfo(value2);
						}
						else
						{
							playerBussiness.AddUserAvatarColectionInfo(value2);
						}
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

		public void UpdateInfo()
		{
			UpdateAvatarColection(sendToClient: true);
			UpdateCurrentDressModels();
		}

		public void UpdateAvatarColection(bool sendToClient)
		{
			List<ClothPropertyTemplateInfo> clothPropertyTemplate = AvatarColectionMgr.GetClothPropertyTemplate();
			foreach (ClothPropertyTemplateInfo item in clothPropertyTemplate)
			{
				List<ClothGroupTemplateInfo> groups = AvatarColectionMgr.FindClothGroupTemplateInfo(item.ID);
				Dictionary<int, ItemInfo> items = FindAvatarColectionActiveInBag(groups);
				AddAvatarColectionItem(item.ID, items, item.Sex);
				if (!dictionary_3.ContainsKey(item.ID) && !dictionary_4.ContainsKey(item.ID))
				{
					UserAvatarColectionInfo userAvatarColectionInfo = new UserAvatarColectionInfo();
					userAvatarColectionInfo.UserID = m_player.PlayerCharacter.ID;
					userAvatarColectionInfo.endTime = DateTime.Now;
					userAvatarColectionInfo.dataId = item.ID;
					userAvatarColectionInfo.Sex = item.Sex;
					AddAvatarColectionInfo(item.ID, item.Sex, userAvatarColectionInfo);
				}
			}
			if (sendToClient)
			{
				AvatarColectionInfoChange();
			}
		}

		public void AvatarColectionInfoChange()
		{
			base.Player.Out.SendAvatarColectionAllInfo(this);
		}

		public void AddPropAvatarColection(ref int att, ref int def, ref int agi, ref int luk, ref int hp)
		{
			Dictionary<int, Dictionary<int, ItemInfo>> dictionary = CombineItemDic();
			Dictionary<int, UserAvatarColectionInfo> dictionary2 = CombineUnitDic();
			List<ClothPropertyTemplateInfo> clothPropertyTemplate = AvatarColectionMgr.GetClothPropertyTemplate();
			foreach (ClothPropertyTemplateInfo item in clothPropertyTemplate)
			{
				if (!dictionary2.ContainsKey(item.ID) || !dictionary2[item.ID].isValidate)
				{
					continue;
				}
				List<ClothGroupTemplateInfo> list = AvatarColectionMgr.FindClothGroupTemplateInfo(item.ID);
				if (dictionary.ContainsKey(item.ID))
				{
					if (dictionary[item.ID].Count >= list.Count / 2 && dictionary[item.ID].Count < list.Count)
					{
						att += item.Attack;
						def += item.Defend;
						agi += item.Agility;
						luk += item.Luck;
						hp += item.Blood;
					}
					if (dictionary[item.ID].Count >= list.Count)
					{
						att += item.Attack * 2;
						def += item.Defend * 2;
						agi += item.Agility * 2;
						luk += item.Luck * 2;
						hp += item.Blood * 2;
					}
				}
			}
		}

		public void AddBasePropAvatarColection(ref double avatarGuard, ref double avatarDame)
		{
			Dictionary<int, Dictionary<int, ItemInfo>> dictionary = CombineItemDic();
			Dictionary<int, UserAvatarColectionInfo> dictionary2 = CombineUnitDic();
			List<ClothPropertyTemplateInfo> clothPropertyTemplate = AvatarColectionMgr.GetClothPropertyTemplate();
			foreach (ClothPropertyTemplateInfo item in clothPropertyTemplate)
			{
				if (!dictionary2.ContainsKey(item.ID) || !dictionary2[item.ID].isValidate)
				{
					continue;
				}
				List<ClothGroupTemplateInfo> list = AvatarColectionMgr.FindClothGroupTemplateInfo(item.ID);
				if (dictionary.ContainsKey(item.ID))
				{
					if (dictionary[item.ID].Count >= list.Count / 2 && dictionary[item.ID].Count < list.Count)
					{
						avatarGuard += item.Guard;
						avatarDame += item.Damage;
					}
					if (dictionary[item.ID].Count >= list.Count)
					{
						avatarGuard += item.Guard * 2;
						avatarDame += item.Damage * 2;
					}
				}
			}
		}

		public Dictionary<int, Dictionary<int, ItemInfo>> CombineItemDic()
		{
			IEnumerable<KeyValuePair<int, Dictionary<int, ItemInfo>>> source = dictionary_1.Concat(dictionary_2);
			IEnumerable<IGrouping<int, KeyValuePair<int, Dictionary<int, ItemInfo>>>> source2 = from d in source
				group d by d.Key;
			Func<IGrouping<int, KeyValuePair<int, Dictionary<int, ItemInfo>>>, int> keySelector = (IGrouping<int, KeyValuePair<int, Dictionary<int, ItemInfo>>> d) => d.Key;
			return source2.ToDictionary(keySelector, (IGrouping<int, KeyValuePair<int, Dictionary<int, ItemInfo>>> d) => d.First().Value);
		}

		public Dictionary<int, UserAvatarColectionInfo> CombineUnitDic()
		{
			IEnumerable<KeyValuePair<int, UserAvatarColectionInfo>> source = dictionary_3.Concat(dictionary_4);
			IEnumerable<IGrouping<int, KeyValuePair<int, UserAvatarColectionInfo>>> source2 = from d in source
				group d by d.Key;
			Func<IGrouping<int, KeyValuePair<int, UserAvatarColectionInfo>>, int> keySelector = (IGrouping<int, KeyValuePair<int, UserAvatarColectionInfo>> d) => d.Key;
			return source2.ToDictionary(keySelector, (IGrouping<int, KeyValuePair<int, UserAvatarColectionInfo>> d) => d.First().Value);
		}

		public bool ActiveAvatarColection(int dataId, int templateId, int sex)
		{
			new Dictionary<int, ItemInfo>();
			ItemInfo ıtemInfo = base.Player.EquipBag.GetItemByTemplateIDMaxBegin(templateId);
			if (ıtemInfo == null)
			{
				ıtemInfo = base.Player.AvatarBag.GetItemByTemplateID(templateId);
			}
			if (ıtemInfo == null)
			{
				ıtemInfo = base.Player.EquipBag.GetItemByTemplateID(templateId);
			}
			if (ıtemInfo == null)
			{
				return false;
			}
			if (ıtemInfo.Place < base.Player.EquipBag.BeginSlot)
			{
				base.Player.EquipBag.UpdateAvatar(ıtemInfo);
			}
			else
			{
				base.Player.AvatarBag.UpdateAvatar(ıtemInfo);
			}
			UpdateAvatarColection(sendToClient: false);
			return true;
		}

		public bool DelayAvatarColection(int dataId, int delay, ref DateTime delayTime, ref int mySex, ref bool updateProp)
		{
			if (MaleUnitDic.ContainsKey(dataId))
			{
				if (!MaleUnitDic[dataId].isValidate)
				{
					dictionary_3[dataId].endTime = DateTime.Now;
					updateProp = true;
				}
				dictionary_3[dataId].endTime = dictionary_3[dataId].endTime.AddDays(delay);
				delayTime = dictionary_3[dataId].endTime;
				mySex = 1;
				return true;
			}
			if (FemaleUnitDic.ContainsKey(dataId))
			{
				if (!FemaleUnitDic[dataId].isValidate)
				{
					dictionary_4[dataId].endTime = DateTime.Now;
					updateProp = true;
				}
				dictionary_4[dataId].endTime = dictionary_4[dataId].endTime.AddDays(delay);
				delayTime = dictionary_4[dataId].endTime;
				mySex = 2;
				return true;
			}
			return false;
		}

		public Dictionary<int, ItemInfo> FindAvatarColectionActiveInBag(List<ClothGroupTemplateInfo> groups)
		{
			Dictionary<int, ItemInfo> dictionary = new Dictionary<int, ItemInfo>();
			foreach (ClothGroupTemplateInfo group in groups)
			{
				ItemInfo ıtemByTemplateID = m_player.EquipBag.GetItemByTemplateID(0, group.TemplateID);
				if (ıtemByTemplateID != null && ıtemByTemplateID.isDress() && ıtemByTemplateID.AvatarActivity && !dictionary.ContainsKey(ıtemByTemplateID.TemplateID))
				{
					dictionary.Add(ıtemByTemplateID.TemplateID, ıtemByTemplateID);
				}
				ıtemByTemplateID = m_player.AvatarBag.GetItemByTemplateID(80, group.TemplateID);
				if (ıtemByTemplateID != null && ıtemByTemplateID.isDress() && ıtemByTemplateID.AvatarActivity && !dictionary.ContainsKey(ıtemByTemplateID.TemplateID))
				{
					dictionary.Add(ıtemByTemplateID.TemplateID, ıtemByTemplateID);
				}
			}
			return dictionary;
		}

		public void AddAvatarColectionItem(int dataId, Dictionary<int, ItemInfo> items, int sex)
		{
			object obj = default(object);
			if (sex == 1)
			{
				bool lockTaken = false;
				try
				{
					Monitor.Enter(obj = m_lock, ref lockTaken);
					if (!dictionary_1.ContainsKey(dataId))
					{
						dictionary_1.Add(dataId, items);
					}
					else
					{
						dictionary_1[dataId] = items;
					}
					return;
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
				if (!dictionary_2.ContainsKey(dataId))
				{
					dictionary_2.Add(dataId, items);
				}
				else
				{
					dictionary_2[dataId] = items;
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

		public void UpdateAvatarColectionInfo(int dataId, int sex)
		{
			List<ClothGroupTemplateInfo> list = AvatarColectionMgr.FindClothGroupTemplateInfo(dataId);
			bool flag = false;
			object obj = default(object);
			if (sex == 1)
			{
				if (MaleUnitDic.ContainsKey(dataId) && MaleItemDic.ContainsKey(dataId))
				{
					bool lockTaken = false;
					try
					{
						Monitor.Enter(obj = m_lock, ref lockTaken);
						dictionary_3[dataId].ActiveCount = MaleItemDic[dataId].Count;
						if (MaleItemDic[dataId].Count == list.Count / 2)
						{
							dictionary_3[dataId].endTime = DateTime.Now;
							dictionary_3[dataId].endTime = DateTime.Now.AddDays(10.0);
							flag = true;
						}
					}
					finally
					{
						if (lockTaken)
						{
							Monitor.Exit(obj);
						}
					}
					if (MaleItemDic[dataId].Count == list.Count)
					{
						flag = true;
					}
				}
			}
			else if (FemaleUnitDic.ContainsKey(dataId) && FemaleItemDic.ContainsKey(dataId))
			{
				bool lockTaken2 = false;
				try
				{
					Monitor.Enter(obj = m_lock, ref lockTaken2);
					dictionary_4[dataId].ActiveCount = FemaleItemDic[dataId].Count;
					if (FemaleItemDic[dataId].Count == list.Count / 2)
					{
						dictionary_4[dataId].endTime = DateTime.Now;
						dictionary_4[dataId].endTime = DateTime.Now.AddDays(10.0);
						flag = true;
					}
				}
				finally
				{
					if (lockTaken2)
					{
						Monitor.Exit(obj);
					}
				}
				if (FemaleItemDic[dataId].Count == list.Count)
				{
					flag = true;
				}
			}
			if (flag)
			{
				base.Player.EquipBag.UpdatePlayerProperties();
				AvatarColectionInfoChange();
			}
		}

		public void AddAvatarColectionInfo(int dataId, int sex, UserAvatarColectionInfo info)
		{
			lock (m_lock)
			{
				if (sex == 1)
				{
					if (!dictionary_3.ContainsKey(dataId))
					{
						dictionary_3.Add(dataId, info);
					}
				}
				else if (!dictionary_4.ContainsKey(dataId))
				{
					dictionary_4.Add(dataId, info);
				}
			}
		}

		public void UpdateCurrentDressModels()
		{
			if (bool_2)
			{
				List<ItemInfo> list = new List<ItemInfo>();
				for (int i = 0; i < m_player.EquipBag.BeginSlot; i++)
				{
					ItemInfo ıtemAt = m_player.EquipBag.GetItemAt(i);
					if (ıtemAt != null && ıtemAt.isDress())
					{
						list.Add(ıtemAt);
					}
				}
				SaveDressModel(0, list);
			}
			m_player.Out.SendSetDressModelArr(m_player.PlayerCharacter.ID, DressModelArr);
			m_player.Out.SendCurentDressModel(m_player.PlayerCharacter.ID, int_4);
		}

		public void SaveDressModel(int slot, List<ItemInfo> dresses)
		{
			if (dresses.Count != 0)
			{
				if (dictionary_0.ContainsKey(slot))
				{
					dictionary_0[slot] = dresses;
				}
				else
				{
					dictionary_0.Add(slot, dresses);
				}
			}
		}

		public void SetCurrentModel(int slot)
		{
			if (dictionary_0.ContainsKey(0) && dictionary_0.ContainsKey(slot))
			{
				List<ItemInfo> value = dictionary_0[slot];
				dictionary_0[slot] = value;
			}
			int_4 = slot;
			m_player.Out.SendCurentDressModel(m_player.PlayerCharacter.ID, slot);
		}

		public string DressModelArrToString()
		{
			string text = "";
			if (dictionary_0[0].Count > 0)
			{
				string text2 = "";
				foreach (ItemInfo item in dictionary_0[0])
				{
					text2 += $"{item.ItemID}|{item.TemplateID};";
				}
				text2 = text2.Substring(0, text2.Length - 1);
				text += $"{text2},";
			}
			else
			{
				text += ",";
			}
			if (dictionary_0[1].Count > 0)
			{
				string text3 = "";
				foreach (ItemInfo item2 in dictionary_0[1])
				{
					text3 += $"{item2.ItemID}|{item2.TemplateID};";
				}
				text3 = text3.Substring(0, text3.Length - 1);
				text += $"{text3},";
			}
			else
			{
				text += ",";
			}
			if (dictionary_0[2].Count > 0)
			{
				string text4 = "";
				foreach (ItemInfo item3 in dictionary_0[2])
				{
					text4 += $"{item3.ItemID}|{item3.TemplateID};";
				}
				text4 = text4.Substring(0, text4.Length - 1);
				text += $"{text4}";
			}
			return text;
		}

		public void StringToDressModelArr(string ModelArr)
		{
			int num = 0;
			string[] array = ModelArr.Split(',');
			string[] array2 = array;
			foreach (string text in array2)
			{
				if (text.Length > 0)
				{
					List<ItemInfo> list = new List<ItemInfo>();
					string[] array3 = text.Split(';');
					string[] array4 = array3;
					foreach (string id in array4)
					{
						ItemInfo ıtemInfo = FindEquipDressModel(num, id);
						if (ıtemInfo != null)
						{
							list.Add(ıtemInfo);
						}
					}
					SaveDressModel(num, list);
				}
				num++;
			}
		}

		public ItemInfo FindEquipDressModel(int slot, string id)
		{
			int itemId = int.Parse(id.Split('|')[0]);
			int templateId = int.Parse(id.Split('|')[1]);
			if (slot == int_4)
			{
				return m_player.EquipBag.GetEquipDressModel(itemId, templateId);
			}
			return m_player.AvatarBag.GetEquipDressModel(itemId, templateId);
		}

		[CompilerGenerated]
		private static int smethod_0(KeyValuePair<int, Dictionary<int, ItemInfo>> d)
		{
			return d.Key;
		}

		[CompilerGenerated]
		private static int smethod_1(IGrouping<int, KeyValuePair<int, Dictionary<int, ItemInfo>>> d)
		{
			return d.Key;
		}

		[CompilerGenerated]
		private static Dictionary<int, ItemInfo> smethod_2(IGrouping<int, KeyValuePair<int, Dictionary<int, ItemInfo>>> d)
		{
			return d.First().Value;
		}

		[CompilerGenerated]
		private static int smethod_3(KeyValuePair<int, UserAvatarColectionInfo> d)
		{
			return d.Key;
		}

		[CompilerGenerated]
		private static int smethod_4(IGrouping<int, KeyValuePair<int, UserAvatarColectionInfo>> d)
		{
			return d.Key;
		}

		[CompilerGenerated]
		private static UserAvatarColectionInfo smethod_5(IGrouping<int, KeyValuePair<int, UserAvatarColectionInfo>> d)
		{
			return d.First().Value;
		}
	}
}
