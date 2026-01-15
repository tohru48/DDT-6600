using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bussiness;
using Bussiness.Managers;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerDice
	{
		public int MAX_LEVEL;

		public int refreshPrice;

		public int commonDicePrice;

		public int doubleDicePrice;

		public int bigDicePrice;

		public int smallDicePrice;

		public int[] IntegralPoint;

		protected GamePlayer m_player;

		protected object m_lock;

		private int int_0;

		private List<EventAwardInfo> list_0;

		private string string_0;

		private Dictionary<int, List<DiceLevelAwardInfo>> dictionary_0;

		private DiceDataInfo uuuneScodm;

		private bool bool_0;

		public GamePlayer Player => m_player;

		public int result
		{
			get
			{
				return int_0;
			}
			set
			{
				int_0 = value;
			}
		}

		public List<EventAwardInfo> RewardItem
		{
			get
			{
				return list_0;
			}
			set
			{
				list_0 = value;
			}
		}

		public string RewardName
		{
			get
			{
				return string_0;
			}
			set
			{
				string_0 = value;
			}
		}

		public Dictionary<int, List<DiceLevelAwardInfo>> LevelAward
		{
			get
			{
				return dictionary_0;
			}
			set
			{
				dictionary_0 = value;
			}
		}

		public DiceDataInfo Data
		{
			get
			{
				return uuuneScodm;
			}
			set
			{
				uuuneScodm = value;
			}
		}

		public PlayerDice(GamePlayer player, bool saveTodb)
		{
			MAX_LEVEL = 5;
			refreshPrice = GameProperties.DiceRefreshPrice;
			commonDicePrice = GameProperties.CommonDicePrice;
			doubleDicePrice = GameProperties.DoubleDicePrice;
			bigDicePrice = GameProperties.BigDicePrice;
			smallDicePrice = GameProperties.SmallDicePrice;
			IntegralPoint = new int[5] { 100, 300, 700, 1500, 3100 };
			m_lock = new object();
			m_player = player;
			bool_0 = saveTodb;
			int_0 = 0;
			string_0 = "";
		}

		public void LoadFromDatabase()
		{
			if (!IsDiceOpen())
			{
				return;
			}
			if (uuuneScodm == null)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				uuuneScodm = playerBussiness.GetSingleDiceData(Player.PlayerCharacter.ID);
				if (uuuneScodm == null)
				{
					method_0();
				}
			}
			ReceiveLevelAward();
		}

		public bool IsDiceOpen()
		{
			Convert.ToDateTime(GameProperties.DiceBeginTime);
			DateTime dateTime = Convert.ToDateTime(GameProperties.DiceEndTime);
			return DateTime.Now.Date < dateTime.Date;
		}

		public void SendDiceActiveOpen()
		{
			if (IsDiceOpen())
			{
				Player.Out.SendDiceActiveOpen(this);
			}
		}

		public void Reset()
		{
			if (!IsDiceOpen())
			{
				return;
			}
			lock (m_lock)
			{
				uuuneScodm.LuckIntegral = 0;
				uuuneScodm.CurrentPosition = -1;
				uuuneScodm.LuckIntegralLevel = -1;
				uuuneScodm.UserFirstCell = false;
				uuuneScodm.FreeCount = 3;
				uuuneScodm.Level = 0;
			}
		}

		private void method_0()
		{
			lock (m_lock)
			{
				uuuneScodm = new DiceDataInfo();
				uuuneScodm.UserID = Player.PlayerCharacter.ID;
				uuuneScodm.LuckIntegral = 0;
				uuuneScodm.CurrentPosition = -1;
				uuuneScodm.LuckIntegralLevel = -1;
				uuuneScodm.UserFirstCell = false;
				uuuneScodm.FreeCount = 3;
				uuuneScodm.Level = 0;
				uuuneScodm.AwardArray = "";
			}
		}

		public void ReceiveData()
		{
			if (string.IsNullOrEmpty(uuuneScodm.AwardArray))
			{
				CreateDiceAward();
				return;
			}
			list_0 = new List<EventAwardInfo>();
			string[] array = uuuneScodm.AwardArray.Split('|');
			string[] array2 = array;
			foreach (string text in array2)
			{
				string[] array3 = text.Split(',');
				EventAwardInfo eventAwardInfo = new EventAwardInfo();
				eventAwardInfo.TemplateID = int.Parse(array3[0]);
				eventAwardInfo.StrengthenLevel = int.Parse(array3[1]);
				eventAwardInfo.Count = int.Parse(array3[2]);
				eventAwardInfo.ValidDate = int.Parse(array3[3]);
				eventAwardInfo.IsBinds = bool.Parse(array3[4]);
				list_0.Add(eventAwardInfo);
			}
			if (list_0.Count < 19)
			{
				CreateDiceAward();
			}
		}

		public void ReceiveLevelAward()
		{
			lock (m_lock)
			{
				dictionary_0 = new Dictionary<int, List<DiceLevelAwardInfo>>();
				for (int i = 0; i < MAX_LEVEL; i++)
				{
					List<DiceLevelAwardInfo> value = DiceLevelAwardMgr.FindDiceLevelAward(i + 1);
					if (!dictionary_0.ContainsKey(i))
					{
						dictionary_0.Add(i, value);
					}
					else
					{
						dictionary_0[i] = value;
					}
				}
			}
		}

		public void GetLevelAward()
		{
			StringBuilder stringBuilder = new StringBuilder();
			IList<DiceLevelAwardInfo> list = dictionary_0[uuuneScodm.LuckIntegralLevel];
			foreach (DiceLevelAwardInfo item in list)
			{
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(item.TemplateID);
				if (ıtemTemplateInfo != null)
				{
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, item.Count, 103);
					Player.AddTemplate(ıtemInfo);
					stringBuilder.Append(ıtemInfo.Template.Name + "x" + ıtemInfo.Count + "; ");
				}
			}
			if (uuuneScodm.LuckIntegralLevel > 3)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("PlayerDice.GetLevelAward", stringBuilder.ToString()));
			}
		}

		public void CreateDiceAward()
		{
			lock (m_lock)
			{
				list_0 = new List<EventAwardInfo>();
				Dictionary<int, EventAwardInfo> dictionary = new Dictionary<int, EventAwardInfo>();
				int num = 0;
				while (list_0.Count < 19)
				{
					List<EventAwardInfo> diceAward = EventAwardMgr.GetDiceAward(eEventType.DICE);
					if (diceAward.Count > 0)
					{
						EventAwardInfo eventAwardInfo = diceAward[0];
						if (!dictionary.Keys.Contains(eventAwardInfo.TemplateID))
						{
							dictionary.Add(eventAwardInfo.TemplateID, eventAwardInfo);
							list_0.Add(eventAwardInfo);
						}
					}
					num++;
				}
			}
			ConvertAwardArray();
		}

		public void ConvertAwardArray()
		{
			if (list_0.Count <= 0)
			{
				return;
			}
			string text = "";
			foreach (EventAwardInfo item in list_0)
			{
				text += $"{item.TemplateID},{item.StrengthenLevel},{item.Count},{item.ValidDate},{item.IsBinds.ToString()}|";
			}
			text = text.Substring(0, text.Length - 1);
			uuuneScodm.AwardArray = text;
		}

		public virtual void SaveToDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				if (uuuneScodm != null && uuuneScodm.IsDirty)
				{
					if (uuuneScodm.ID > 0)
					{
						playerBussiness.UpdateDiceData(uuuneScodm);
					}
					else
					{
						playerBussiness.AddDiceData(uuuneScodm);
					}
				}
			}
		}
	}
}
