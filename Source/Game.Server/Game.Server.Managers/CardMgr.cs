using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Threading;
using Bussiness;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class CardMgr
	{
		private static readonly ILog ilog_0;

		private static CardGrooveUpdateInfo[] cardGrooveUpdateInfo_0;

		private static Dictionary<int, List<CardGrooveUpdateInfo>> dictionary_0;

		private static Dictionary<int, List<CardBuffInfo>> dictionary_1;

		private static Dictionary<int, CardInfo> dictionary_2;

		private static CardTemplateInfo[] cardTemplateInfo_0;

		private static Dictionary<int, List<CardTemplateInfo>> dictionary_3;

		private static ThreadSafeRandom threadSafeRandom_0;

		[CompilerGenerated]
		private static Func<CardTemplateInfo, int> ajvKojcOjE;

		public static bool ReLoad()
		{
			bool result;
			try
			{
				Dictionary<int, CardInfo> dictionary = LoadCardInfoDb();
				Dictionary<int, List<CardBuffInfo>> value = LoadCardBuffs(dictionary);
				if (dictionary.Count > 0)
				{
					Interlocked.Exchange(ref dictionary_2, dictionary);
					Interlocked.Exchange(ref dictionary_1, value);
				}
				CardGrooveUpdateInfo[] array = LoadGrooveUpdateDb();
				Dictionary<int, List<CardGrooveUpdateInfo>> value2 = LoadGrooveUpdates(array);
				if (array.Length > 0)
				{
					Interlocked.Exchange(ref cardGrooveUpdateInfo_0, array);
					Interlocked.Exchange(ref dictionary_0, value2);
				}
				CardTemplateInfo[] array2 = LoadCardBoxDb();
				Dictionary<int, List<CardTemplateInfo>> value3 = LoadCardBoxs(array2);
				if (array2.Length > 0)
				{
					Interlocked.Exchange(ref cardTemplateInfo_0, array2);
					Interlocked.Exchange(ref dictionary_3, value3);
				}
				return true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("ReLoad CardMgr", exception);
				}
				result = false;
			}
			return result;
		}

		public static bool Init()
		{
			return ReLoad();
		}

		public static CardInfo GetSingleCard(int id)
		{
			if (dictionary_2.Count == 0)
			{
				ReLoad();
			}
			if (dictionary_2.ContainsKey(id))
			{
				return dictionary_2[id];
			}
			return null;
		}

		public static Dictionary<int, CardInfo> LoadCardInfoDb()
		{
			Dictionary<int, CardInfo> dictionary = new Dictionary<int, CardInfo>();
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				CardInfo[] allCard = produceBussiness.GetAllCard();
				CardInfo[] array = allCard;
				foreach (CardInfo cardInfo in array)
				{
					if (!dictionary.ContainsKey(cardInfo.ID))
					{
						dictionary.Add(cardInfo.ID, cardInfo);
					}
				}
			}
			return dictionary;
		}

		public static CardBuffInfo[] LoadCardBuffDb()
		{
			using ProduceBussiness produceBussiness = new ProduceBussiness();
			return produceBussiness.GetAllCardBuff();
		}

		public static Dictionary<int, List<CardBuffInfo>> LoadCardBuffs(Dictionary<int, CardInfo> Cards)
		{
			Dictionary<int, List<CardBuffInfo>> dictionary = new Dictionary<int, List<CardBuffInfo>>();
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				CardBuffInfo[] allCardBuff = produceBussiness.GetAllCardBuff();
				foreach (CardInfo Card in Cards.Values)
				{
					IEnumerable<CardBuffInfo> source = allCardBuff;
					Func<CardBuffInfo, bool> predicate = (CardBuffInfo s) => s.CardID == Card.ID;
					IEnumerable<CardBuffInfo> source2 = source.Where(predicate);
					dictionary.Add(Card.ID, source2.ToList());
				}
			}
			return dictionary;
		}

		public static List<CardBuffInfo> FindCardBuff(int ID)
		{
			if (dictionary_1.ContainsKey(ID))
			{
				return dictionary_1[ID];
			}
			return null;
		}

		public static CardGrooveUpdateInfo[] LoadGrooveUpdateDb()
		{
			using ProduceBussiness produceBussiness = new ProduceBussiness();
			return produceBussiness.GetAllCardGrooveUpdate();
		}

		public static Dictionary<int, List<CardGrooveUpdateInfo>> LoadGrooveUpdates(CardGrooveUpdateInfo[] GrooveUpdates)
		{
			Dictionary<int, List<CardGrooveUpdateInfo>> dictionary = new Dictionary<int, List<CardGrooveUpdateInfo>>();
			foreach (CardGrooveUpdateInfo info in GrooveUpdates)
			{
				if (!dictionary.Keys.Contains(info.Type))
				{
					IEnumerable<CardGrooveUpdateInfo> source = GrooveUpdates.Where((CardGrooveUpdateInfo s) => s.Type == info.Type);
					dictionary.Add(info.Type, source.ToList());
				}
			}
			return dictionary;
		}

		public static CardTemplateInfo[] LoadCardBoxDb()
		{
			using ProduceBussiness produceBussiness = new ProduceBussiness();
			return produceBussiness.GetAllCardTemplate();
		}

		public static Dictionary<int, List<CardTemplateInfo>> LoadCardBoxs(CardTemplateInfo[] CardBoxs)
		{
			Dictionary<int, List<CardTemplateInfo>> dictionary = new Dictionary<int, List<CardTemplateInfo>>();
			foreach (CardTemplateInfo info in CardBoxs)
			{
				if (!dictionary.Keys.Contains(info.CardID))
				{
					IEnumerable<CardTemplateInfo> source = CardBoxs.Where((CardTemplateInfo s) => s.CardID == info.CardID);
					dictionary.Add(info.CardID, source.ToList());
				}
			}
			return dictionary;
		}

		public static CardTemplateInfo GetCard(int cardId)
		{
			CardTemplateInfo cardTemplateInfo = new CardTemplateInfo();
			List<CardTemplateInfo> list = FindCardBox(cardId);
			if (list == null)
			{
				return null;
			}
			int num = 1;
			IEnumerable<CardTemplateInfo> source = list;
			int maxRound = ThreadSafeRandom.NextStatic(source.Select((CardTemplateInfo cardTemplateInfo_1) => cardTemplateInfo_1.probability).Max());
			List<CardTemplateInfo> list2 = list.Where((CardTemplateInfo s) => s.probability >= maxRound).ToList();
			int num2 = list2.Count();
			if (num2 > 0)
			{
				num = ((num > num2) ? num2 : num);
				int[] randomUnrepeatArray = GetRandomUnrepeatArray(0, num2 - 1, num);
				int[] array = randomUnrepeatArray;
				foreach (int index in array)
				{
					cardTemplateInfo = list2[index];
				}
			}
			if (cardTemplateInfo.CardType <= 0)
			{
				return null;
			}
			return cardTemplateInfo;
		}

		public static int[] GetRandomUnrepeatArray(int minValue, int maxValue, int count)
		{
			int[] array = new int[count];
			for (int i = 0; i < count; i++)
			{
				int num = threadSafeRandom_0.Next(minValue, maxValue + 1);
				int num2 = 0;
				for (int j = 0; j < i; j++)
				{
					if (array[j] == num)
					{
						num2++;
					}
				}
				if (num2 == 0)
				{
					array[i] = num;
				}
				else
				{
					i--;
				}
			}
			return array;
		}

		public static List<CardTemplateInfo> FindCardBox(int cardId)
		{
			if (dictionary_3 == null)
			{
				ReLoad();
			}
			if (dictionary_3.ContainsKey(cardId))
			{
				return dictionary_3[cardId];
			}
			return null;
		}

		public static CardTemplateInfo FindCardTemplate(int cardId, int type)
		{
			List<CardTemplateInfo> list = FindCardBox(cardId);
			if (list == null)
			{
				return null;
			}
			foreach (CardTemplateInfo item in list)
			{
				if (type == item.CardType)
				{
					return item;
				}
			}
			return null;
		}

		public static List<CardGrooveUpdateInfo> FindCardGrooveUpdate(int type)
		{
			if (dictionary_0 == null)
			{
				ReLoad();
			}
			if (dictionary_0.ContainsKey(type))
			{
				return dictionary_0[type];
			}
			return null;
		}

		public static int CardCount()
		{
			return cardTemplateInfo_0.Count();
		}

		public static int MaxLv(int type)
		{
			return FindCardGrooveUpdate(type).Count - 1;
		}

		public static int GetLevel(int GP, int type)
		{
			if (GP >= FindCardGrooveUpdate(type)[MaxLv(type)].Exp)
			{
				return FindCardGrooveUpdate(type)[MaxLv(type)].Level;
			}
			for (int i = 1; i <= MaxLv(type); i++)
			{
				if (GP < FindCardGrooveUpdate(type)[i].Exp)
				{
					int index = ((i - 1 != -1) ? (i - 1) : 0);
					return FindCardGrooveUpdate(type)[index].Level;
				}
			}
			return 0;
		}

		public static int GetProp(UsersCardInfo slot, int type)
		{
			int num = 0;
			for (int i = 0; i < slot.Level; i++)
			{
				num += GetGrooveSlot(slot.Type, i, type);
			}
			if (slot.CardID != 0)
			{
				num += GetPropCard(slot.CardType, slot.CardID, type);
			}
			return num;
		}

		public static int GetGrooveSlot(int type, int lv, int typeProp)
		{
			CardGrooveUpdateInfo[] array = cardGrooveUpdateInfo_0;
			foreach (CardGrooveUpdateInfo cardGrooveUpdateInfo in array)
			{
				if (cardGrooveUpdateInfo.Type == type && cardGrooveUpdateInfo.Level == lv)
				{
					switch (typeProp)
					{
					case 0:
						return cardGrooveUpdateInfo.Attack;
					case 1:
						return cardGrooveUpdateInfo.Defend;
					case 2:
						return cardGrooveUpdateInfo.Agility;
					case 3:
						return cardGrooveUpdateInfo.Lucky;
					case 4:
						return cardGrooveUpdateInfo.Damage;
					case 5:
						return cardGrooveUpdateInfo.Guard;
					}
				}
			}
			return 0;
		}

		public static int GetPropCard(int cardtype, int cardID, int type)
		{
			CardTemplateInfo[] array = cardTemplateInfo_0;
			foreach (CardTemplateInfo cardTemplateInfo in array)
			{
				if (cardTemplateInfo.CardType == cardtype && cardTemplateInfo.CardID == cardID)
				{
					switch (type)
					{
					case 0:
						return cardTemplateInfo.AddAttack;
					case 1:
						return cardTemplateInfo.AddDefend;
					case 2:
						return cardTemplateInfo.AddAgility;
					case 3:
						return cardTemplateInfo.AddLucky;
					case 4:
						return cardTemplateInfo.AddDamage;
					case 5:
						return cardTemplateInfo.AddGuard;
					}
				}
			}
			return 0;
		}

		public static int GetGP(int level, int type)
		{
			for (int i = 1; i <= MaxLv(type); i++)
			{
				if (level == FindCardGrooveUpdate(type)[i].Level)
				{
					return FindCardGrooveUpdate(type)[i].Exp;
				}
			}
			return 0;
		}

		[CompilerGenerated]
		private static int smethod_0(CardTemplateInfo cardTemplateInfo_1)
		{
			return cardTemplateInfo_1.probability;
		}

		static CardMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			threadSafeRandom_0 = new ThreadSafeRandom();
		}
	}
}
