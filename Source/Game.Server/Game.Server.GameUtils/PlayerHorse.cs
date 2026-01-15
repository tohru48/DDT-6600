using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Bussiness;
using Game.Logic;
using Game.Server.GameObjects;
using log4net;
using Newtonsoft.Json;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerHorse
	{
		private static readonly ILog ilog_0;

		protected object m_lock;

		protected GamePlayer m_player;

		private MountDataInfo mountDataInfo_0;

		private Dictionary<int, MountSkillDataInfo> dictionary_0;

		private Dictionary<int, int> dictionary_1;

		private bool bool_0;

		private Dictionary<int, MountDrawDataInfo> dictionary_2;

		private bool bool_1;

		public GamePlayer Player => m_player;

		public MountDataInfo Info
		{
			get
			{
				return mountDataInfo_0;
			}
			set
			{
				mountDataInfo_0 = value;
			}
		}

		public Dictionary<int, MountSkillDataInfo> curHasSkill => dictionary_0;

		public Dictionary<int, int> curUsedSkill => dictionary_1;

		public bool UpdateProperties
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

		public Dictionary<int, MountDrawDataInfo> horsePicCherish => dictionary_2;

		public MountSkillDataInfo[] GetSkills => curHasSkill.Values.ToArray();

		public int[] GetHorseSkillEquip => dictionary_1.Values.ToArray();

		public MountDrawDataInfo[] GetPicCherishs => horsePicCherish.Values.ToArray();

		public PlayerHorse(GamePlayer player, bool saveTodb)
		{
			m_lock = new object();
			m_player = player;
			bool_1 = saveTodb;
			dictionary_0 = new Dictionary<int, MountSkillDataInfo>();
			dictionary_1 = new Dictionary<int, int>();
			dictionary_2 = new Dictionary<int, MountDrawDataInfo>();
		}

		public virtual void LoadFromDatabase()
		{
			if (!bool_1)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			try
			{
				MountDataInfo singleMountData = playerBussiness.GetSingleMountData(m_player.PlayerCharacter.ID);
				if (singleMountData == null)
				{
					CreateHorse();
					return;
				}
				lock (m_lock)
				{
					mountDataInfo_0 = singleMountData;
				}
			}
			finally
			{
				DeserializeMount();
			}
		}

		public void UpdateHorsePacket()
		{
			Player.Out.SendHorseInitAllData(Info, GetSkills);
			Player.Out.SendPicCherishInfo(Info.UserID, GetPicCherishs);
		}

		public void TakeUpDownSkill(int place, int skilId)
		{
			if (dictionary_0.ContainsKey(skilId))
			{
				dictionary_0[skilId].IsUse = place;
				UpdateUsedSkill();
			}
		}

		public void UpSkill(int skilId, MountSkillDataInfo newSkill)
		{
			dictionary_0.Remove(skilId);
			if (!dictionary_0.ContainsKey(newSkill.SKillID))
			{
				dictionary_0.Add(newSkill.SKillID, newSkill);
			}
			dictionary_1.Remove(skilId);
			if (!dictionary_1.ContainsKey(newSkill.IsUse))
			{
				dictionary_1.Add(newSkill.IsUse, newSkill.SKillID);
			}
		}

		public MountSkillDataInfo AddHorseSkill()
		{
			MountTemplateInfo mountTemplate = MountMgr.GetMountTemplate(Info.curLevel);
			if (mountTemplate != null && mountTemplate.SkillID > 0)
			{
				int skillID = mountTemplate.SkillID;
				MountSkillTemplateInfo mountSkillTemplate = MountMgr.GetMountSkillTemplate(skillID);
				if (mountSkillTemplate != null)
				{
					MountSkillDataInfo mountSkillDataInfo = new MountSkillDataInfo();
					mountSkillDataInfo.SKillID = skillID;
					mountSkillDataInfo.Exp = 0;
					mountSkillDataInfo.IsUse = 0;
					if (!dictionary_0.ContainsKey(skillID))
					{
						dictionary_0.Add(skillID, mountSkillDataInfo);
						return mountSkillDataInfo;
					}
				}
			}
			return null;
		}

		public void CreateHorse()
		{
			MountDataInfo mountDataInfo = new MountDataInfo();
			MountTemplateInfo mountTemplate = MountMgr.GetMountTemplate(0);
			if (mountTemplate != null)
			{
				mountDataInfo.UserID = Player.PlayerCharacter.ID;
				mountDataInfo.curLevel = mountTemplate.Grade;
				mountDataInfo.curExp = mountTemplate.Experience;
				mountDataInfo.curHasSkill = "";
			}
			else
			{
				mountDataInfo = null;
				Console.WriteLine("MountTemplateInfo not found item!");
			}
			lock (m_lock)
			{
				mountDataInfo_0 = mountDataInfo;
			}
		}

		public void UpdateUsedSkill()
		{
			dictionary_1.Clear();
			foreach (MountSkillDataInfo value in dictionary_0.Values)
			{
				if (value.IsUse > 0 && !dictionary_1.ContainsKey(value.IsUse))
				{
					dictionary_1.Add(value.IsUse, value.SKillID);
				}
			}
		}

		public void ActiveHorsePicCherish(int mountId)
		{
			if (!dictionary_2.ContainsKey(mountId) && mountId > 100)
			{
				MountDrawDataInfo mountDrawDataInfo = new MountDrawDataInfo();
				mountDrawDataInfo.ID = mountId;
				mountDrawDataInfo.Active = 0;
				dictionary_2.Add(mountId, mountDrawDataInfo);
				Player.EquipBag.UpdatePlayerProperties();
			}
			foreach (int key in horsePicCherish.Keys)
			{
				dictionary_2[key].Active = 0;
			}
			if (dictionary_2.ContainsKey(mountId))
			{
				dictionary_2[mountId].Active = 1;
			}
		}

		private void method_0()
		{
			string[] array = Info.curHasSkill.Split('|');
			string[] array2 = array;
			foreach (string text in array2)
			{
				int num = int.Parse(text.Split(',')[0]);
				MountSkillTemplateInfo mountSkillTemplate = MountMgr.GetMountSkillTemplate(num);
				if (mountSkillTemplate != null)
				{
					MountSkillDataInfo mountSkillDataInfo = new MountSkillDataInfo();
					mountSkillDataInfo.SKillID = num;
					mountSkillDataInfo.Exp = int.Parse(text.Split(',')[1]);
					int num2 = (mountSkillDataInfo.IsUse = int.Parse(text.Split(',')[2]));
					if (!dictionary_0.ContainsKey(num))
					{
						dictionary_0.Add(num, mountSkillDataInfo);
					}
					if (num2 > 0 && !dictionary_1.ContainsKey(num2))
					{
						dictionary_1.Add(num2, num);
					}
				}
			}
		}

		public void DeserializeMount()
		{
			try
			{
				if (Info != null && !string.IsNullOrEmpty(Info.horsePicCherish))
				{
					dictionary_2 = JsonConvert.DeserializeObject<Dictionary<int, MountDrawDataInfo>>(Info.horsePicCherish);
				}
				if (Info == null || string.IsNullOrEmpty(Info.curHasSkill))
				{
					return;
				}
				if (Info.curHasSkill.Contains("|"))
				{
					method_0();
					return;
				}
				try
				{
					dictionary_0 = JsonConvert.DeserializeObject<Dictionary<int, MountSkillDataInfo>>(Info.curHasSkill);
					foreach (MountSkillDataInfo value in curHasSkill.Values)
					{
						int ısUse = value.IsUse;
						if (ısUse > 0 && !dictionary_1.ContainsKey(ısUse))
						{
							dictionary_1.Add(ısUse, value.SKillID);
						}
					}
				}
				catch
				{
					method_0();
				}
			}
			catch (Exception exception)
			{
				ilog_0.Error("DeserializeMount fail: ", exception);
			}
		}

		public void SerializeMount()
		{
			try
			{
				Info.curHasSkill = JsonConvert.SerializeObject(curHasSkill);
				Info.horsePicCherish = JsonConvert.SerializeObject(horsePicCherish);
			}
			catch (Exception exception)
			{
				ilog_0.Error("SerializeMount fail: ", exception);
			}
		}

		public virtual void SaveToDatabase()
		{
			if (!bool_1)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				if (Info != null && Info.IsDirty)
				{
					SerializeMount();
					if (Info.ID > 0)
					{
						playerBussiness.UpdateMountData(Info);
					}
					else
					{
						playerBussiness.AddMountDatas(Info);
					}
				}
			}
		}

		static PlayerHorse()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
